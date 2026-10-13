<template>
  <div id="userLayout">
    <div class="user-layout-header">
      <img class="logo" :src="logoImage" alt="" />
      <span>民宿短租后台</span>
    </div>
    <div class="main-container">
      <div class="main">
        <div class="main_right">
          <h2 class="sys_title">管理员登录</h2>
          <a-form
            ref="myform"
            layout="vertical"
            :model="data.loginForm"
            :rules="data.rules"
            :hideRequiredMark="true"
          >
            <a-form-item name="username" label="用户名" :colon="false">
              <a-input
                v-model:value="data.loginForm.username"
                size="large"
                placeholder="请输入用户名"
                @pressEnter="handleSubmit"
              />
            </a-form-item>
            <a-form-item name="password" label="密码" :colon="false">
              <a-input
                v-model:value="data.loginForm.password"
                size="large"
                type="password"
                placeholder="请输入密码"
                @pressEnter="handleSubmit"
              />
            </a-form-item>
            <a-form-item v-if="data.captchaEnabled" name="code" label="验证码" :colon="false">
              <div class="captcha-box">
                <a-input
                  v-model:value="data.loginForm.code"
                  size="large"
                  placeholder="请输入验证码"
                  @pressEnter="handleSubmit"
                />
                <img
                  v-if="data.captchaImg"
                  :src="data.captchaImg"
                  alt="验证码"
                  class="captcha-img"
                  @click="getCaptcha"
                />
              </div>
            </a-form-item>
            <a-form-item style="padding-top: 24px">
              <a-button class="login-button" type="primary" :loading="loginBtn" size="large" block @click="handleSubmit">
                登录
              </a-button>
            </a-form-item>
          </a-form>
          <div class="error-tip"></div>
        </div>
      </div>
    </div>
    <footer class="footer">
      <div class="copyright">
        <span></span>
      </div>
    </footer>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { getCaptchaApi } from '/@/api/user';
import { useUserStore } from '/@/store';
import logoImage from '/@/assets/images/k-logo.png';

const router = useRouter();
const userStore = useUserStore();
const myform = ref();
const loginBtn = ref(false);

const data = reactive({
  loginForm: {
    username: '',
    password: '',
    code: '',
    uuid: '',
  },
  captchaEnabled: false,
  captchaImg: '',
  rules: {
    username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
    password: [{ required: true, message: '请输入密码', trigger: 'blur' }],
    code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
  },
});

const getCaptcha = async () => {
  try {
    const res = await getCaptchaApi();
    data.captchaEnabled = !!res?.captchaEnabled;
    if (data.captchaEnabled) {
      data.loginForm.uuid = res?.uuid || '';
      data.loginForm.code = '';
      data.captchaImg = res?.img ? `data:image/gif;base64,${res.img}` : '';
    } else {
      data.loginForm.uuid = '';
      data.loginForm.code = '';
      data.captchaImg = '';
    }
  } catch (_err) {
    data.captchaEnabled = false;
    data.loginForm.uuid = '';
    data.loginForm.code = '';
    data.captchaImg = '';
  }
};

const handleSubmit = () => {
  myform.value
    ?.validate()
    .then(() => {
      handleLogin();
    })
    .catch(() => {
      message.warn('请填写必填项');
    });
};

const handleLogin = async () => {
  loginBtn.value = true;
  try {
    await userStore.adminLogin({
      username: data.loginForm.username,
      password: data.loginForm.password,
      code: data.loginForm.code,
      uuid: data.loginForm.uuid,
    });
    loginSuccess();
  } catch (err: any) {
    message.warn(err?.msg || '登录失败');
    await getCaptcha();
  } finally {
    loginBtn.value = false;
  }
};

const loginSuccess = () => {
  router.push({ path: '/admin' });
  message.success('登录成功');
};

onMounted(() => {
  getCaptcha();
});
</script>

<style lang="less" scoped>
#userLayout {
  position: relative;
  height: 100vh;

  .user-layout-header {
    height: 80px;
    padding: 0 24px;
    color: fade(#000, 85%);
    font-size: 28px;
    font-weight: bold;
    line-height: 80px;

    .logo {
      width: 36px;
      height: 36px;
      margin-right: 16px;
      margin-top: -4px;
    }
  }

  .main-container {
    width: 100%;
    height: calc(100vh - 160px);
    background-image: url('../images/admin-login-bg.jpg');
    background-position: center;
    background-repeat: no-repeat;
    background-size: cover;

    .main {
      position: absolute;
      right: 80px;
      top: 50%;
      display: flex;
      transform: translate(0, -50%);
      border-radius: 8px;
      overflow: hidden;
      -webkit-box-shadow: 2px 2px 6px #aaa;
      box-shadow: 2px 2px 6px #aaa;

      .main_right {
        background: #ffffff;
        padding: 24px;
        width: 420px;
        user-select: none;

        .sys_title {
          font-size: 24px;
          color: fade(#000, 85%);
          font-weight: bold;
          user-select: none;
          padding-bottom: 8px;
        }

        :deep(.ant-form-item label) {
          font-weight: bold;
        }

        .login-button {
          background: linear-gradient(128deg, #00aaeb, #00c1cd 59%, #0ac2b0 100%);
        }
      }

      .error-tip {
        text-align: center;
      }
    }
  }

  .footer {
    height: 80px;
  }
}

.captcha-box {
  display: flex;
  gap: 8px;
}

.captcha-img {
  width: 120px;
  height: 40px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  cursor: pointer;
}
</style>
