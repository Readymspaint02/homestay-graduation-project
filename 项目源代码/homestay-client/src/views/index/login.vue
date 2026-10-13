<template>
  <div class="container">
    <div class="login-page pc-style">
      <img :src="LogoIcon" alt="logo" class="logo-icon" />
      <div class="login-tab">
        <div class="tab-selected" :class="{'active': pageData.role === 'tenant'}" @click="pageData.role = 'tenant'">
          <span>租客登录</span>
          <span class="tabline" :class="{'tabline-width': pageData.role === 'tenant'}"></span>
        </div>
        <div :class="{'tab-selected': pageData.role === 'landlord'}" @click="pageData.role = 'landlord'">
          <span>房东登录</span>
          <span class="tabline" :class="{'tabline-width': pageData.role === 'landlord'}"></span>
        </div>
      </div>
      <div class="mail-login" type="login">
        <div class="common-input">
          <img :src="MailIcon" class="left-icon" />
          <div class="input-view">
            <input
              v-model="pageData.loginForm.username"
              placeholder="用户名"
              type="text"
              class="input"
            />
          </div>
        </div>
        <div class="common-input">
          <img :src="PwdIcon" class="left-icon" />
          <div class="input-view">
            <input
              v-model="pageData.loginForm.password"
              placeholder="密码"
              type="password"
              class="input"
            />
          </div>
        </div>
        <div v-if="pageData.captchaEnabled" class="captcha-row">
          <input
            v-model="pageData.loginForm.code"
            placeholder="验证码"
            type="text"
            class="captcha-input"
            @keyup.enter="handleLogin"
          />
          <img
            v-if="pageData.captchaImg"
            :src="pageData.captchaImg"
            alt="验证码"
            class="captcha-img"
            @click="getCaptcha"
          />
          <div v-else class="captcha-placeholder" @click="getCaptcha">点击加载验证码</div>
        </div>
        <div class="next-btn-view">
          <button class="next-btn btn-active" style="margin: 16px 0" @click="handleLogin">{{ pageData.role === 'tenant' ? '租客登录' : '房东登录' }}</button>
        </div>
      </div>
      <div class="operation">
        <a @click="handleCreateUser" class="forget-pwd" style="text-align: left">注册</a>
        <a class="forget-pwd" style="text-align: right">忘记密码</a>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { useUserStore } from '/@/store';
import { getCaptchaApi } from '/@/api/user';
import LogoIcon from '/@/assets/images/k-logo.png';
import MailIcon from '/@/assets/images/mail-icon.svg';
import PwdIcon from '/@/assets/images/pwd-icon.svg';

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

const pageData = reactive({
  role: 'tenant',
  loginForm: {
    username: '',
    password: '',
    code: '',
    uuid: '',
  },
  captchaEnabled: false,
  captchaImg: '',
});

const getCaptcha = async () => {
  try {
    const res = await getCaptchaApi();
    pageData.captchaEnabled = !!res?.captchaEnabled;
    if (pageData.captchaEnabled) {
      pageData.loginForm.uuid = res?.uuid || '';
      pageData.loginForm.code = '';
      pageData.captchaImg = res?.img ? `data:image/gif;base64,${res.img}` : '';
    } else {
      pageData.loginForm.uuid = '';
      pageData.loginForm.code = '';
      pageData.captchaImg = '';
    }
  } catch (_err) {
    pageData.captchaEnabled = false;
    pageData.loginForm.uuid = '';
    pageData.loginForm.code = '';
    pageData.captchaImg = '';
  }
};

const handleLogin = async () => {
  if (!pageData.loginForm.username || !pageData.loginForm.password) {
    message.warn('用户名和密码不能为空');
    return;
  }
  if (pageData.captchaEnabled && !pageData.loginForm.code) {
    message.warn('请输入验证码');
    return;
  }
  try {
    const result = await userStore.login({
      username: pageData.loginForm.username,
      password: pageData.loginForm.password,
      code: pageData.loginForm.code,
      uuid: pageData.loginForm.uuid,
    });
    if (result?.code === 200) {
      if (pageData.role === 'landlord') {
        router.push('/landlord/overview');
      } else {
        loginSuccess();
      }
    } else {
      message.warn(result?.msg || '登录失败');
      await getCaptcha();
    }
  } catch (err: any) {
    message.warn(err?.msg || '登录失败');
    await getCaptcha();
  }
};

const handleCreateUser = () => {
  router.push({ name: 'register' });
};

const goQa = () => {
  router.push({ name: 'qa' });
};

const loginSuccess = () => {
  const redirect = String(route.query.redirect || '');
  if (redirect && redirect.startsWith('/')) {
    router.push(redirect);
  } else {
    router.push({ name: 'portal' });
  }
  message.success('登录成功');
};

onMounted(() => {
  getCaptcha().catch(() => {});
});
</script>

<style scoped lang="less">
div {
  display: block;
}

.container {
  background-image: url('../images/admin-login-bg.jpg');
  background-size: cover;
  object-fit: cover;
  height: 100%;
  max-width: 100%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.login-page {
  overflow: hidden;
  background: #fff;

  .logo-icon {
    margin-top: 20px;
    margin-left: 175px;
    width: 48px;
    height: 48px;
  }
}

.pc-style {
  position: relative;
  width: 400px;
  min-height: 464px;
  background: #fff;
  border-radius: 4px;
  -webkit-box-shadow: 2px 2px 6px #aaa;
  box-shadow: 2px 2px 6px #aaa;
  padding-bottom: 16px;
}

.login-tab {
  display: flex;
  color: #1e1e1e;
  font-size: 14px;
  font-weight: 500;
  height: 46px;
  line-height: 44px;
  margin-bottom: 40px;
  border-bottom: 1px solid #c3c9d5;

  div {
    position: relative;
    flex: 1;
    text-align: center;
    cursor: pointer;
  }

  .tabline {
    position: absolute;
    bottom: 0;
    left: 0;
    right: 0;
    margin: 0 auto;
    display: inline-block;
    width: 0;
    height: 2px;
    background: #3d5b96;
    -webkit-transition: width 0.5s cubic-bezier(0.46, 1, 0.23, 1.52);
    transition: width 0.5s cubic-bezier(0.46, 1, 0.23, 1.52);
  }

  .tabline-width {
    width: 80px;
  }
}

.mail-login {
  margin: 0 24px;
}

.common-input {
  display: flex;
  align-items: flex-start;

  .left-icon {
    margin-right: 12px;
    width: 24px;
  }

  .input-view {
    flex: 1;

    .input {
      font-weight: 500;
      font-size: 14px;
      color: #1e1e1e;
      height: 26px;
      line-height: 26px;
      border: none;
      padding: 0;
      display: block;
      width: 100%;
      letter-spacing: 1.5px;
      border-bottom: 1px solid #e5e5e5;
      margin-bottom: 18px;
    }
  }
}

.captcha-row {
  margin-top: 4px;
  display: flex;
  align-items: center;
  gap: 8px;
  margin-left: 36px;
}

.captcha-input {
  flex: 1;
  height: 34px;
  padding: 0 10px;
  border: 1px solid #e5e5e5;
  border-radius: 4px;
}

.captcha-img {
  width: 118px;
  height: 34px;
  border-radius: 4px;
  cursor: pointer;
  border: 1px solid #e5e5e5;
}

.captcha-placeholder {
  width: 118px;
  height: 34px;
  border-radius: 4px;
  border: 1px dashed #cbd5e1;
  color: #64748b;
  font-size: 12px;
  line-height: 34px;
  text-align: center;
  cursor: pointer;
  user-select: none;
}

.next-btn {
  background: #3d5b96;
  border-radius: 4px;
  color: #fff;
  font-size: 14px;
  font-weight: 500;
  height: 40px;
  line-height: 40px;
  text-align: center;
  width: 100%;
  outline: none;
  cursor: pointer;
}

button {
  background: transparent;
  padding: 0;
  border-width: 0;
}

button,
input,
select,
textarea {
  margin: 0;
  padding: 0;
  outline: none;
}

.operation {
  display: flex;
  flex-direction: row;
  margin: 0 24px;
}

.forget-pwd {
  display: block;
  overflow: hidden;
  flex: 1;
  margin: 0 auto;
  color: #3d5b96;
  font-size: 14px;
  cursor: pointer;
}
</style>
