<template>
  <div class="container">
    <div class="tel-regist-page pc-style">
      <div class="regist-title">
        <span>手机号注册</span>
        <span @click="router.push({ name: 'login' })" class="to-login">已有账号，去登录</span>
      </div>

      <div class="regist-padding">
        <div class="common-input">
          <img :src="MailIcon" class="left-icon" />
          <div class="input-view">
            <input v-model="form.mobile" placeholder="请输入手机号" type="text" class="input" />
          </div>
        </div>
      </div>

      <div class="regist-padding">
        <div class="common-input">
          <img :src="PwdIcon" class="left-icon" />
          <div class="input-view">
            <input v-model="form.password" placeholder="请输入密码" type="password" class="input" />
          </div>
        </div>
      </div>

      <div class="regist-padding">
        <div class="common-input">
          <img :src="PwdIcon" class="left-icon" />
          <div class="input-view">
            <input v-model="form.repassword" placeholder="请再次输入密码" type="password" class="input" />
          </div>
        </div>
      </div>

      <div class="regist-padding">
        <div class="role-row">
          <span class="role-label">注册身份</span>
          <div class="role-options">
            <span class="role-option" :class="{ active: form.role === 'hs:tenant' }" @click="form.role = 'hs:tenant'">租客</span>
            <span class="role-option" :class="{ active: form.role === 'hs:landlord' }" @click="form.role = 'hs:landlord'">房东</span>
          </div>
        </div>
      </div>

      <div v-if="captchaEnabled" class="regist-padding">
        <div class="captcha-row">
          <input
            v-model="form.code"
            placeholder="请输入验证码"
            type="text"
            class="captcha-input"
            @keyup.enter="handleRegister"
          />
          <img v-if="captchaImg" :src="captchaImg" alt="captcha" class="captcha-img" @click="getCaptcha" />
        </div>
      </div>

      <div class="tel-login">
        <div class="next-btn-view">
          <button class="next-btn" @click="handleRegister">注册</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { getCaptchaApi, userRegisterApi } from '/@/api/user';
import MailIcon from '/@/assets/images/mail-icon.svg';
import PwdIcon from '/@/assets/images/pwd-icon.svg';

const router = useRouter();

const form = reactive({
  mobile: '',
  password: '',
  repassword: '',
  role: 'hs:tenant',
  code: '',
  uuid: '',
});

const captchaEnabled = ref(false);
const captchaImg = ref('');

const mobilePattern = /^1\d{10}$/;

const getCaptcha = async () => {
  try {
    const res = await getCaptchaApi();
    captchaEnabled.value = !!res?.captchaEnabled;
    if (captchaEnabled.value) {
      form.uuid = res?.uuid || '';
      form.code = '';
      captchaImg.value = res?.img ? `data:image/gif;base64,${res.img}` : '';
    } else {
      form.uuid = '';
      form.code = '';
      captchaImg.value = '';
    }
  } catch (_error) {
    captchaEnabled.value = false;
    form.uuid = '';
    form.code = '';
    captchaImg.value = '';
  }
};

const validateForm = () => {
  if (!form.mobile || !form.password || !form.repassword) {
    message.warning('手机号和密码不能为空');
    return false;
  }
  if (!mobilePattern.test(form.mobile)) {
    message.warning('请输入正确的11位手机号');
    return false;
  }
  if (form.password !== form.repassword) {
    message.warning('两次输入的密码不一致');
    return false;
  }
  if (captchaEnabled.value && !form.code) {
    message.warning('请输入验证码');
    return false;
  }
  return true;
};

const handleRegister = async () => {
  if (!validateForm()) return;
  try {
    await userRegisterApi({
      mobile: form.mobile,
      username: form.mobile,
      password: form.password,
      role: form.role,
      code: form.code,
      uuid: form.uuid,
    });
    message.success('注册成功，请登录');
    router.push({ name: 'login' });
  } catch (err: any) {
    message.error(err?.msg || '注册失败');
    await getCaptcha();
  }
};

onMounted(() => {
  getCaptcha();
});
</script>

<style scoped lang="less">
div {
  display: block;
}

*, :after, :before, img {
  border-style: none;
}

*, :after, :before {
  border-width: 0;
  border-color: #dae1e7;
}

.container {
  max-width: 100%;
  background-image: url('../images/admin-login-bg.jpg');
  background-size: cover;
  object-fit: cover;
  height: 100vh;
  overflow: hidden;
  display: flex;
  justify-content: center;
  align-items: center;
}

.pc-style {
  position: relative;
  width: 400px;
  min-height: 464px;
  background: #fff;
  -webkit-box-shadow: 2px 2px 6px #aaa;
  box-shadow: 2px 2px 6px #aaa;
  border-radius: 4px;
  padding-bottom: 16px;
}

.tel-regist-page {
  overflow: hidden;

  .regist-title {
    font-size: 14px;
    color: #1e1e1e;
    font-weight: 500;
    height: 24px;
    line-height: 24px;
    margin: 40px 0;
    padding: 0 28px;

    .to-login {
      color: #3d5b96;
      float: right;
      cursor: pointer;
    }
  }

  .regist-padding {
    padding: 0 28px;
    margin-bottom: 8px;
  }
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
      padding: 0;
      display: block;
      width: 100%;
      letter-spacing: 1.5px;
      border-bottom: 1px solid #e5e5e5;
      outline: none;
    }
  }
}

.role-row {
  display: flex;
  align-items: center;
  margin-left: 36px;
  gap: 16px;
}

.role-label {
  font-size: 14px;
  color: #333;
  white-space: nowrap;
}

.role-options {
  display: flex;
  gap: 12px;
}

.role-option {
  padding: 6px 24px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  cursor: pointer;
  font-size: 14px;
  color: #666;
  background: #fff;
  transition: all 0.2s;
}

.role-option:hover {
  border-color: #3d5b96;
  color: #3d5b96;
}

.role-option.active {
  background: #3d5b96;
  border-color: #3d5b96;
  color: #fff;
}

.captcha-row {
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

.tel-login {
  padding: 0 28px;
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
</style>
