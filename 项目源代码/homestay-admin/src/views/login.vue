<template>
  <div class="login">
    <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">民宿短租系统</h3>
      <el-form-item prop="username">
        <el-input
          v-model="loginForm.username"
          type="text"
          size="large"
          auto-complete="off"
          placeholder="账号"
        >
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password">
        <el-input
          v-model="loginForm.password"
          type="password"
          size="large"
          auto-complete="off"
          placeholder="密码"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="code" v-if="captchaEnabled">
        <el-input
          v-model="loginForm.code"
          size="large"
          auto-complete="off"
          placeholder="验证码"
          style="width: 63%"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img"/>
        </div>
      </el-form-item>
      <el-checkbox v-model="loginForm.rememberMe" style="margin:0px 0px 25px 0px;">记住密码</el-checkbox>
      <el-form-item style="width:100%;">
        <el-button
          :loading="loading"
          size="large"
          type="primary"
          style="width:100%;"
          @click.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
    <el-dialog
      v-model="smsDialogVisible"
      title="请输入手机验证码"
      width="350px"
      :close-on-click-modal="false"
      :close-on-press-escape="false"
      center
    >
      <el-form
        :model="loginForm"
        :rules="smsRules"
        ref="loginFormRef"
        label-width="80px"
      >
        <el-form-item label="验证码" prop="smsCode">
          <el-input
            v-model="loginForm.smsCode"
            placeholder="请输入收到的验证码"
          ></el-input>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="cancelSms">取消</el-button>
        <el-button type="primary" @click="handleLoginBySms">确定</el-button>
      </template>
    </el-dialog>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>Copyright © 2023-2025 <a target="_blank" href="https://www.undsky.com">undsky.com</a> All Rights Reserved.</span>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue'
import { getCodeImg } from "@/api/login";
import Cookies from "js-cookie";
import { encrypt, decrypt } from "@/utils/jsencrypt";
import { setToken } from '@/utils/auth'
import useUserStore from '@/store/modules/user'
import usePermissionStore from '@/store/modules/permission'

const userStore = useUserStore()
const route = useRoute();
const router = useRouter();
const { proxy } = getCurrentInstance();

const loginForm = ref({
  roleType: "landlord",
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: "",
  smsCode: ""
});

const smsRules = {
  smsCode: [{ required: true, trigger: "blur", message: "请输入验证码" }]
};

const loginRules = {
  username: [{ required: true, trigger: "blur", message: "请输入您的账号" }],
  password: [{ required: true, trigger: "blur", message: "请输入您的密码" }],
  code: [{ required: true, trigger: "change", message: "请输入验证码" }]
};

const codeUrl = ref("");
const loading = ref(false);
const captchaEnabled = ref(true);
const register = ref(false);
const redirect = ref(undefined);
const smsDialogVisible = ref(false);
const secondaryVerificationEnabled = import.meta.env.VITE_APP_SECONDARY_VERIFICATION_ENABLED === 'true';

watch(route, (newRoute) => {
    redirect.value = newRoute.query && newRoute.query.redirect;
}, { immediate: true });

function cancelSms() {
  smsDialogVisible.value = false;
  loginForm.value.smsCode = "";
}

function handleLoginBySms() {
  const smsCode = loginForm.value.smsCode;
  if (!/^\d{6}$/.test(smsCode)) {
    if (proxy.$modal) {
       proxy.$modal.msgError("请输入6位数字的短信验证码");
    } else {
       console.error("请输入6位数字的短信验证码");
    }
    return;
  }
  handleLogin();
}

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true;
      if (loginForm.value.rememberMe) {
        Cookies.set("username", loginForm.value.username, { expires: 30 });
        Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 });
        Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 });
      } else {
        Cookies.remove("username");
        Cookies.remove("password");
        Cookies.remove("rememberMe");
      }
      userStore.login(loginForm.value).then(() => {
        const query = route.query;
        const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
          if (cur !== "redirect") {
            acc[cur] = query[cur];
          }
          return acc;
        }, {});
        router.push({ path: redirect.value || "/", query: otherQueryParams });
      }).catch((e) => {
        loading.value = false;
        if (e === "sms" && secondaryVerificationEnabled) {
          smsDialogVisible.value = true;
        } else {
          if (captchaEnabled.value) {
            getCode();
          }
        }
      });
    }
  });
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled;
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img;
      loginForm.value.uuid = res.uuid;
    }
  });
}

function getCookie() {
  const username = Cookies.get("username");
  const password = Cookies.get("password");
  const rememberMe = Cookies.get("rememberMe");
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  };
}

onMounted(() => {
  const tokenParam = route.query.token
  if (tokenParam) {
    setToken(tokenParam)
    userStore.token = tokenParam
    userStore.getInfo().then(() => {
      const permissionStore = usePermissionStore()
      permissionStore.generateRoutes().then(() => {
        const redirectPath = redirect.value || '/index'
        router.push({ path: redirectPath, replace: true })
      })
    })
  } else {
    getCode()
    getCookie()
  }
})
</script>

<style lang='scss' scoped>
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background.jpg");
  background-size: cover;
}
.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;
  .el-input {
    height: 40px;
    input {
      height: 40px;
    }
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.login-code {
  width: 33%;
  height: 40px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}
.login-code-img {
  height: 40px;
  padding-left: 12px;
}
</style>
