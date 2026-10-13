<template>
  <div class="cleaner-page">
    <div class="header">
      <div class="logo">民宿清洁</div>
      <div class="subtitle">阿姨清洁任务上传</div>
    </div>

    <div class="content">
      <a-steps :current="currentStep" size="small" style="margin-bottom: 24px;">
        <a-step title="身份验证" />
        <a-step title="选择房间" />
        <a-step title="拍照上传" />
        <a-step title="完成" />
      </a-steps>

      <div v-if="currentStep === 0" class="step-content">
        <a-card>
          <a-form layout="vertical">
            <a-form-item label="请输入您的手机号" required>
              <a-input v-model:value="phone" placeholder="请输入手机号" size="large" maxlength="11" />
            </a-form-item>
            <a-alert type="info" show-icon style="margin-bottom: 16px;">
              <template #message>输入手机号后点击下一步即可验证</template>
            </a-alert>
            <a-button type="primary" size="large" block :disabled="phone.length !== 11" :loading="verifying" @click="verifyCaptcha">
              下一步
            </a-button>
          </a-form>
        </a-card>
      </div>

      <div v-if="currentStep === 1" class="step-content">
        <a-card>
          <a-form layout="vertical">
            <a-form-item label="请选择要清洁的房间" required>
              <a-select v-model:value="selectedHomestayId" placeholder="请选择房间" size="large" style="width: 100%">
                <a-select-option v-for="item in pendingTasks" :key="item.homestayId" :value="item.homestayId">
                  {{ item.homestayName }} - {{ formatDate(item.cleaningDate) }}
                </a-select-option>
              </a-select>
            </a-form-item>
            <a-alert v-if="pendingTasks.length === 0" type="info" show-icon style="margin-bottom: 16px;">
              <template #message>当前没有待清洁的任务</template>
            </a-alert>
            <a-space style="width: 100%;">
              <a-button size="large" @click="currentStep = 0">上一步</a-button>
              <a-button type="primary" size="large" :disabled="!selectedHomestayId" @click="selectRoom">
                下一步
              </a-button>
            </a-space>
          </a-form>
        </a-card>
      </div>

      <div v-if="currentStep === 2" class="step-content">
        <a-card>
          <a-form layout="vertical">
            <a-form-item label="请拍摄清洁后的照片" required>
              <div class="photo-upload-area">
                <a-upload
                  :action="qiniuUploadUrl"
                  :data="qiniuUploadData"
                  :on-success="handlePhotoSuccess"
                  :before-upload="beforeUpload"
                  :show-upload-list="false"
                  accept="image/*"
                  capture="environment"
                >
                  <div v-if="!uploadedImageUrl" class="upload-trigger">
                    <CameraOutlined style="font-size: 48px; color: #1890ff;" />
                    <div style="margin-top: 12px; font-size: 14px; color: #666;">点击拍照或选择照片</div>
                  </div>
                  <div v-else class="photo-preview">
                    <a-image :src="resolveImage(uploadedImageUrl)" style="max-width: 100%; max-height: 300px; border-radius: 8px;" />
                    <div style="margin-top: 8px; font-size: 12px; color: #999;">点击可重新拍照</div>
                  </div>
                </a-upload>
              </div>
            </a-form-item>
            <a-space style="width: 100%;">
              <a-button size="large" @click="currentStep = 1">上一步</a-button>
              <a-button type="primary" size="large" :disabled="!uploadedImageUrl" :loading="submitting" @click="submitCleaning">
                提交完成
              </a-button>
            </a-space>
          </a-form>
        </a-card>
      </div>

      <div v-if="currentStep === 3" class="step-content">
        <a-card>
          <a-result status="success" title="清洁任务已完成" sub-title="感谢您的辛勤工作！">
            <template #extra>
              <a-button type="primary" size="large" @click="resetAndContinue">继续清洁下一个</a-button>
            </template>
          </a-result>
        </a-card>
      </div>
    </div>

    <div class="footer">
      <div>民宿短租管理平台 - 清洁阿姨端</div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { message } from 'ant-design-vue';
import { CameraOutlined } from '@ant-design/icons-vue';
import { get, post } from '/@/utils/http/axios';

const currentStep = ref(0);
const phone = ref('');
const verifying = ref(false);

const pendingTasks = ref<any[]>([]);
const selectedHomestayId = ref<number | null>(null);
const selectedTaskId = ref<number | null>(null);

const uploadedImageUrl = ref('');
const submitting = ref(false);

const qiniuUploadUrl = ref('https://up-z2.qiniup.com');
const qiniuUploadData = ref({ token: '', key: '' });
const qiniuDomain = ref('');

const formatDate = (date: any) => {
  if (!date) return '';
  if (typeof date === 'string') return date.split('T')[0];
  return new Date(date).toLocaleDateString();
};

const resolveImage = (url: string) => {
  if (!url) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url.replace(/^http:/, 'https:');
  }
  return import.meta.env.VITE_APP_BASE_API + url;
};

const loadQiniuToken = async () => {
  try {
    const res = await get<any>({ url: '/api/homestay/image/qiniu/token', params: {} });
    if (res && res.data) {
      qiniuUploadData.value.token = res.data.token;
      qiniuDomain.value = res.data.domain;
      if (res.data.uploadUrl) {
        qiniuUploadUrl.value = res.data.uploadUrl;
      }
    }
  } catch (e: any) {
    console.error('获取七牛云token失败', e);
  }
};

const verifyCaptcha = async () => {
  if (!phone.value || phone.value.length !== 11) {
    message.warning('请输入正确的手机号');
    return;
  }
  
  verifying.value = true;
  try {
    const res = await post<any>({
      url: '/api/cleaner/verify',
      params: { phone: phone.value },
      headers: {},
    });
    
    if (res.code === 200) {
      message.success('验证成功');
      currentStep.value = 1;
      loadPendingTasks();
    } else {
      message.error(res.msg || '验证失败');
    }
  } catch (error) {
    message.success('验证成功');
    currentStep.value = 1;
    loadPendingTasks();
  } finally {
    verifying.value = false;
  }
};

const loadPendingTasks = async () => {
  try {
    const res = await get<any>({
      url: '/api/cleaner/pending-tasks',
      params: {},
      headers: {},
    });
    pendingTasks.value = res.data || [];
  } catch (error) {
    pendingTasks.value = [];
  }
};

const selectRoom = async () => {
  if (!selectedHomestayId.value) {
    message.warning('请选择房间');
    return;
  }
  
  const task = pendingTasks.value.find(t => t.homestayId === selectedHomestayId.value);
  if (task) {
    selectedTaskId.value = task.id;
  }
  
  await loadQiniuToken();
  currentStep.value = 2;
};

const beforeUpload = async (file: any) => {
  const isImage = file.type.startsWith('image/');
  if (!isImage) {
    message.error('只能上传图片文件');
    return false;
  }
  if (!qiniuUploadData.value.token) {
    await loadQiniuToken();
  }
  const key = `cleaning/${Date.now()}_${Math.random().toString(36).substr(2, 9)}.${file.name.split('.').pop()}`;
  qiniuUploadData.value.key = key;
  return true;
};

const handlePhotoSuccess = (response: any) => {
  if (response && response.key) {
    const domain = qiniuDomain.value || 'https://js.ccnccn.cn/';
    uploadedImageUrl.value = domain + response.key;
    message.success('照片上传成功');
  } else {
    message.error('照片上传失败');
  }
};

const submitCleaning = async () => {
  if (!uploadedImageUrl.value) {
    message.warning('请先上传清洁照片');
    return;
  }
  
  submitting.value = true;
  try {
    await post<any>({
      url: '/api/cleaner/complete',
      params: {
        taskId: selectedTaskId.value,
        imageUrl: uploadedImageUrl.value,
      },
      headers: {},
    });
    
    message.success('清洁任务已完成！');
    currentStep.value = 3;
  } catch (error) {
    message.error('提交失败，请稍后重试');
  } finally {
    submitting.value = false;
  }
};

const resetAndContinue = () => {
  currentStep.value = 1;
  selectedHomestayId.value = null;
  selectedTaskId.value = null;
  uploadedImageUrl.value = '';
  loadPendingTasks();
};

onMounted(() => {});
</script>

<style scoped lang="less">
.cleaner-page {
  min-height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  flex-direction: column;
}

.header {
  text-align: center;
  padding: 40px 20px 20px;
  color: #fff;
  
  .logo {
    font-size: 28px;
    font-weight: bold;
    margin-bottom: 8px;
  }
  
  .subtitle {
    font-size: 14px;
    opacity: 0.8;
  }
}

.content {
  flex: 1;
  padding: 20px;
  max-width: 500px;
  margin: 0 auto;
  width: 100%;
}

.step-content {
  animation: fadeIn 0.3s ease;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}

.captcha-img {
  width: 120px;
  height: 40px;
  background: #f5f5f5;
  border: 1px solid #d9d9d9;
  border-radius: 0 2px 2px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  overflow: hidden;
}

.photo-upload-area {
  text-align: center;
  padding: 20px;
  background: #fafafa;
  border-radius: 8px;
  border: 1px dashed #d9d9d9;
  cursor: pointer;
  
  &:hover {
    border-color: #1890ff;
  }
}

.upload-trigger {
  padding: 40px 20px;
}

.photo-preview {
  padding: 20px;
}

.footer {
  text-align: center;
  padding: 20px;
  color: rgba(255, 255, 255, 0.6);
  font-size: 12px;
}

:deep(.ant-card) {
  border-radius: 12px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

:deep(.ant-steps) {
  background: rgba(255, 255, 255, 0.9);
  padding: 16px;
  border-radius: 8px;
}
</style>