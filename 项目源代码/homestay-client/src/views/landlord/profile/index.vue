<template>
  <div class="profile-page">
    <a-card title="个人信息" :bordered="false" class="profile-card">
      <a-spin :spinning="loading">
        <div class="profile-content">
          <div class="avatar-section">
            <a-avatar :size="100" :src="displayAvatar">
              <template #icon><UserOutlined /></template>
            </a-avatar>
            <a-upload
              :action="qiniuUploadUrl"
              :data="qiniuUploadData"
              accept="image/*"
              :multiple="false"
              :before-upload="beforeQiniuUpload"
              @change="handleQiniuUploadChange"
              :show-upload-list="false"
            >
              <a-button type="link" style="margin-top: 12px;">
                <UploadOutlined />
                更换头像
              </a-button>
            </a-upload>
          </div>

          <a-divider />

          <a-form :model="profileForm" layout="vertical" class="profile-form">
            <a-form-item label="昵称">
              <a-input v-model:value="profileForm.nickname" placeholder="请输入昵称" maxlength="20" />
            </a-form-item>

            <a-form-item label="手机号">
              <a-input v-model:value="profileForm.mobile" placeholder="请输入手机号" maxlength="11" />
            </a-form-item>

            <a-form-item label="邮箱">
              <a-input v-model:value="profileForm.email" placeholder="请输入邮箱" />
            </a-form-item>

            <a-form-item label="个人简介">
              <a-textarea v-model:value="profileForm.description" placeholder="请输入简介" :rows="3" maxlength="200" />
            </a-form-item>

            <a-form-item>
              <a-button type="primary" @click="handleSaveProfile" :loading="saving">保存修改</a-button>
            </a-form-item>
          </a-form>

          <a-divider />

          <div class="password-section">
            <div class="section-header">
              <span class="section-title">修改密码</span>
            </div>
            <div v-if="!showPwdForm">
              <a-button @click="showPwdForm = true">修改密码</a-button>
            </div>
            <div v-else class="password-form">
              <a-form :model="pwdForm" layout="vertical">
                <a-form-item label="原密码">
                  <a-input-password v-model:value="pwdForm.oldPassword" placeholder="请输入原密码" />
                </a-form-item>
                <a-form-item label="新密码">
                  <a-input-password v-model:value="pwdForm.newPassword" placeholder="请输入新密码（至少6位）" />
                </a-form-item>
                <a-form-item label="确认密码">
                  <a-input-password v-model:value="pwdForm.confirmPassword" placeholder="请再次输入新密码" />
                </a-form-item>
                <a-form-item>
                  <a-space>
                    <a-button type="primary" @click="handleSavePwd" :loading="savingPwd">确认修改</a-button>
                    <a-button @click="cancelPwdEdit">取消</a-button>
                  </a-space>
                </a-form-item>
              </a-form>
            </div>
          </div>
        </div>
      </a-spin>
    </a-card>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { message } from 'ant-design-vue';
import { UserOutlined, UploadOutlined } from '@ant-design/icons-vue';
import { useUserStore } from '/@/store';
import { get, post } from '/@/utils/http/axios';
import { BASE_URL, USER_NAME, USER_TOKEN } from '/@/store/constants';
import AvatarImg from '/@/assets/images/avatar.jpg';

const router = useRouter();
const userStore = useUserStore();

const loading = ref(false);
const saving = ref(false);
const savingPwd = ref(false);
const showPwdForm = ref(false);

const qiniuUploadUrl = ref('https://upload.qiniup.com');
const qiniuUploadData = ref({ token: '', key: '' });
const qiniuDomain = ref('');

const profileForm = reactive({
  avatar: '',
  nickname: '',
  mobile: '',
  email: '',
  description: '',
});

const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: '',
});

const displayAvatar = computed(() => {
  return resolveAvatar(profileForm.avatar) || AvatarImg;
});

const PHONE_REG = /^1\d{10}$/;
const EMAIL_REG = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;

const resolveAvatar = (avatar: string) => {
  const raw = String(avatar || '').trim();
  if (!raw) return '';
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:');
  if (raw.startsWith('/profile/')) return `${BASE_URL}${raw}`;
  if (raw.startsWith('/')) return raw;
  if (raw.includes('/') || raw.includes('.')) return raw;
  return `${BASE_URL}/profile/${raw}`;
};

const loadQiniuToken = async () => {
  try {
    const res = await get({ url: '/api/homestay/image/qiniu/token', params: {}, headers: {} });
    if (res && res.data) {
      qiniuUploadData.value.token = res.data.token;
      qiniuDomain.value = res.data.domain;
      if (res.data.uploadUrl) {
        qiniuUploadUrl.value = res.data.uploadUrl;
      }
    }
  } catch (e) {
    console.error('获取七牛云token失败', e);
  }
};

const beforeQiniuUpload = async (file: File) => {
  const isImage = file.type.startsWith('image/');
  if (!isImage) {
    message.error('只能上传图片文件');
    return false;
  }
  const isLt4M = file.size / 1024 / 1024 < 4;
  if (!isLt4M) {
    message.error('图片大小不能超过4MB');
    return false;
  }
  if (!qiniuUploadData.value.token) {
    await loadQiniuToken();
  }
  const key = `avatar/${Date.now()}_${Math.random().toString(36).substr(2, 9)}.${file.name.split('.').pop()}`;
  qiniuUploadData.value.key = key;
  return true;
};

const handleQiniuUploadChange = (info: any) => {
  if (info.file.status === 'done' && info.file.response) {
    if (info.file.response && info.file.response.key) {
      const domain = qiniuDomain.value || 'https://js.ccnccn.cn/';
      const url = domain + info.file.response.key;
      profileForm.avatar = url;
      message.success('头像上传成功');
    } else {
      message.error('上传失败');
    }
  } else if (info.file.status === 'error') {
    message.error('上传失败，请重试');
  }
};

const loadProfile = async () => {
  loading.value = true;
  try {
    const res = await get({ url: '/api/user/detail', params: {}, headers: {} });
    if (res && res.data) {
      profileForm.avatar = res.data.avatar || '';
      profileForm.nickname = res.data.nickname || res.data.username || '';
      profileForm.mobile = res.data.mobile || '';
      profileForm.email = res.data.email || '';
      profileForm.description = res.data.description || '';
    }
  } catch (e) {
    console.error('获取用户信息失败', e);
    profileForm.nickname = userStore.user_name || '';
  } finally {
    loading.value = false;
  }
};

const handleSaveProfile = async () => {
  const nickname = String(profileForm.nickname || '').trim();
  const mobile = String(profileForm.mobile || '').trim();
  const email = String(profileForm.email || '').trim();
  const description = String(profileForm.description || '').trim();
  const avatar = String(profileForm.avatar || '').trim();

  if (mobile && !PHONE_REG.test(mobile)) {
    message.warning('请输入正确的11位手机号');
    return;
  }
  if (email && !EMAIL_REG.test(email)) {
    message.warning('请输入正确的邮箱格式');
    return;
  }

  saving.value = true;
  try {
    const formData = new FormData();
    formData.append('nickname', nickname);
    formData.append('email', email);
    formData.append('mobile', mobile);
    formData.append('description', description);
    formData.append('avatar', avatar);

    const res = await post({ url: '/api/user/update', data: formData, headers: {} });
    if (res.code === 200) {
      message.success('保存成功');
      if (nickname) {
        userStore.user_name = nickname;
        localStorage.setItem(USER_NAME, nickname);
      }
      window.dispatchEvent(new CustomEvent('profile-updated', {
        detail: { avatar: profileForm.avatar, nickname: profileForm.nickname },
      }));
    } else {
      message.warning(res.msg || '保存失败');
    }
  } catch (e: any) {
    message.error(e?.msg || '保存失败');
  } finally {
    saving.value = false;
  }
};

const cancelPwdEdit = () => {
  showPwdForm.value = false;
  pwdForm.oldPassword = '';
  pwdForm.newPassword = '';
  pwdForm.confirmPassword = '';
};

const handleSavePwd = async () => {
  const oldPassword = String(pwdForm.oldPassword || '').trim();
  const newPassword = String(pwdForm.newPassword || '').trim();
  const confirmPassword = String(pwdForm.confirmPassword || '').trim();

  if (!oldPassword || !newPassword) {
    message.warning('请填写原密码和新密码');
    return;
  }
  if (newPassword.length < 6) {
    message.warning('新密码长度不能少于6位');
    return;
  }
  if (newPassword !== confirmPassword) {
    message.warning('两次输入的新密码不一致');
    return;
  }

  savingPwd.value = true;
  try {
    const res = await post({ url: '/api/user/updatePwd', data: { oldPassword, newPassword }, headers: {} });
    if (res.code === 200) {
      message.success('密码修改成功，请重新登录');
      userStore.logout();
      localStorage.removeItem(USER_TOKEN);
      localStorage.removeItem(USER_NAME);
      router.push({ name: 'login' });
    } else {
      message.warning(res.msg || '修改失败');
    }
  } catch (e: any) {
    message.error(e?.msg || '密码修改失败');
  } finally {
    savingPwd.value = false;
  }
};

onMounted(() => {
  loadProfile();
  loadQiniuToken();
});
</script>

<style scoped lang="less">
.profile-page {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 64px);
}

.profile-card {
  max-width: 600px;
  margin: 0 auto;
  border-radius: 8px;
}

.profile-content {
  padding: 16px 0;
}

.avatar-section {
  text-align: center;
  padding: 16px 0;
}

.profile-form {
  max-width: 400px;
  margin: 0 auto;
}

.password-section {
  margin-top: 16px;

  .section-header {
    margin-bottom: 16px;
  }

  .section-title {
    font-size: 16px;
    font-weight: 600;
    color: #333;
  }

  .password-form {
    max-width: 400px;
    margin: 16px auto 0;
  }
}
</style>
