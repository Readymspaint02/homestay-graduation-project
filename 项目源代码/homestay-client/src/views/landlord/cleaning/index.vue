<template>
  <div class="page-view">
    <a-alert type="info" show-icon style="margin-bottom: 16px;">
      <template #message>清洁任务管理</template>
      <template #description>
        <div>点击"叫清洁"将语音提醒阿姨，阿姨扫码拍照上传后自动完成清洁。</div>
        <div style="margin-top: 8px;">
          <a-button type="link" size="small" @click="showQrTip">查看阿姨扫码入口</a-button>
        </div>
      </template>
    </a-alert>

    <div class="table-operations">
      <a-space wrap>
        <a-select v-model:value="filters.homestayId" style="width: 200px" placeholder="房源" allow-clear>
          <a-select-option v-for="item in homestayOptions" :key="item.id" :value="item.id">{{ item.title }}</a-select-option>
        </a-select>
        <a-select v-model:value="filters.status" style="width: 120px" placeholder="清洁状态" allow-clear>
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">待清洁</a-select-option>
          <a-select-option value="1">已清洁</a-select-option>
        </a-select>
        <a-button type="primary" @click="handleQuery" :loading="loading">查询</a-button>
        <a-button @click="handleReset">重置</a-button>
        <a-button type="primary" danger @click="handleCallCleaning" :disabled="homestayOptions.length === 0">叫清洁</a-button>
      </a-space>
    </div>

    <a-table
      size="middle"
      rowKey="id"
      :loading="loading"
      :columns="columns"
      :data-source="rows"
      :pagination="false"
    >
      <template #bodyCell="{ record, column }">
        <template v-if="column.key === 'status'">
          <a-tag :color="record.status === '0' ? 'orange' : 'green'">
            {{ record.status === '0' ? '待清洁' : '已清洁' }}
          </a-tag>
        </template>

        <template v-if="column.key === 'imageUrl'">
          <div class="image-cell">
            <a-image
              v-if="record.imageUrl"
              :src="resolveImage(record.imageUrl)"
              :width="60"
              :height="60"
              :preview="false"
            />
            <span v-else class="text-gray">无</span>
          </div>
        </template>

        <template v-if="column.key === 'cleanerPhone'">
          <a v-if="record.cleanerPhone" :href="'tel:' + record.cleanerPhone" style="color: #1890ff;">{{ record.cleanerPhone }}</a>
          <span v-else class="text-gray">-</span>
        </template>

        <template v-if="column.key === 'action'">
          <a-space>
            <a-button v-if="record.status === '0'" type="primary" size="small" @click="handleMarkClean(record)">标记已清洁</a-button>
            <a-button v-if="record.status === '1'" disabled size="small">已完成</a-button>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal v-model:open="callDialog.visible" title="叫清洁" width="420px" @ok="submitCallCleaning" :confirmLoading="callDialog.loading">
      <a-form layout="vertical">
        <a-form-item label="选择房源" required>
          <a-select v-model:value="callDialog.homestayId" placeholder="请选择房源" style="width: 100%">
            <a-select-option v-for="item in homestayOptions" :key="item.id" :value="item.id">{{ item.title }}</a-select-option>
          </a-select>
        </a-form-item>
        <a-form-item label="备注">
          <a-textarea v-model:value="callDialog.remark" :rows="2" placeholder="清洁要求备注" />
        </a-form-item>
        <a-alert type="info" show-icon style="margin-top: 12px;">
          <template #message>点击确定后将语音提醒阿姨前往清洁</template>
          <template #description>阿姨可通过扫码进入清洁页面，拍照上传后自动完成</template>
        </a-alert>
      </a-form>
    </a-modal>

    <a-modal v-model:open="qrDialog.visible" title="阿姨扫码入口" width="500px" :footer="null">
      <a-alert type="info" show-icon style="margin-bottom: 16px;">
        <template #message>阿姨可通过以下地址进入清洁页面</template>
      </a-alert>
      <div style="text-align: center; padding: 20px;">
        <div style="font-size: 18px; font-weight: bold; margin-bottom: 16px;">清洁阿姨入口</div>
        <div style="font-size: 14px; color: #666; margin-bottom: 8px;">访问地址：</div>
        <div style="background: #f5f5f5; padding: 12px; border-radius: 4px; font-size: 14px; word-break: break-all;">
          {{ cleanerUrl }}
        </div>
        <a-button type="primary" style="margin-top: 16px;" @click="copyCleanerUrl">复制地址</a-button>
      </div>
      <a-divider />
      <div style="font-size: 13px; color: #666;">
        <div>阿姨操作流程：</div>
        <ol style="margin: 8px 0; padding-left: 20px;">
          <li>访问上述地址</li>
          <li>输入手机号验证</li>
          <li>选择房间号</li>
          <li>拍照上传清洁照片</li>
          <li>自动完成清洁任务</li>
        </ol>
      </div>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, reactive } from 'vue';
import { message, notification } from 'ant-design-vue';
import { get, post } from '/@/utils/http/axios';

const loading = ref(false);
const rows = ref<any[]>([]);
const homestayOptions = ref<any[]>([]);

const filters = reactive({
  homestayId: null as number | null,
  status: '',
});

const callDialog = reactive({
  visible: false,
  loading: false,
  homestayId: null as number | null,
  remark: '',
});

const qrDialog = reactive({
  visible: false,
});

const cleanerUrl = window.location.origin + '/cleaner';

const columns = reactive([
  { title: 'ID', dataIndex: 'id', key: 'id', width: 70, align: 'center' },
  { title: '房源', dataIndex: 'homestayName', key: 'homestayName', minWidth: 200 },
  { title: '清洁日期', dataIndex: 'cleaningDate', key: 'cleaningDate', width: 120, align: 'center' },
  { title: '状态', dataIndex: 'status', key: 'status', width: 100, align: 'center' },
  { title: '清洁照片', dataIndex: 'imageUrl', key: 'imageUrl', width: 100, align: 'center' },
  { title: '阿姨电话', dataIndex: 'cleanerPhone', key: 'cleanerPhone', width: 130, align: 'center' },
  { title: '备注', dataIndex: 'remark', key: 'remark', minWidth: 150 },
  { title: '操作', dataIndex: 'action', key: 'action', width: 120, align: 'center' },
]);

const resolveImage = (url: string) => {
  if (!url) return '';
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return url.replace(/^http:/, 'https:');
  }
  return import.meta.env.VITE_APP_BASE_API + url;
};

const playNotificationSound = () => {
  try {
    const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    oscillator.frequency.value = 600;
    oscillator.type = 'sine';
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.5);
  } catch (e) {}
};

const speakNotification = (text: string) => {
  if ('speechSynthesis' in window) {
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'zh-CN';
    utterance.rate = 1;
    speechSynthesis.speak(utterance);
  }
};

const loadHomestays = async () => {
  try {
    const res = await get<any>({ url: '/api/homestay/landlord/list', params: { pageNum: 1, pageSize: 100 }, headers: {} });
    homestayOptions.value = res.rows || [];
  } catch (error) {
    homestayOptions.value = [];
  }
};

const loadData = async () => {
  loading.value = true;
  try {
    const params: Record<string, any> = {};
    if (filters.homestayId) params.homestayId = filters.homestayId;
    if (filters.status) params.status = filters.status;
    const res = await get<any>({ url: '/api/cleaning/list', params, data: {}, headers: {} });
    rows.value = res?.data || [];
  } catch (error: any) {
    console.error('清洁任务加载失败:', error);
    message.error(error?.msg || '加载失败，请检查网络或刷新页面');
    rows.value = [];
  } finally {
    loading.value = false;
  }
};

const handleQuery = () => loadData();
const handleReset = () => {
  filters.homestayId = null;
  filters.status = '';
  loadData();
};

const handleMarkClean = async (record: any) => {
  try {
    await post<any>({ url: '/api/cleaning/mark', params: { taskId: record.id, status: '1' }, headers: {} });
    message.success('标记成功，房源已恢复可租');
    loadData();
  } catch (error) {
    message.error('操作失败');
  }
};

const handleCallCleaning = () => {
  if (homestayOptions.value.length === 0) {
    message.warning('请先添加房源');
    return;
  }
  callDialog.homestayId = null;
  callDialog.remark = '';
  callDialog.visible = true;
};

const submitCallCleaning = async () => {
  if (!callDialog.homestayId) {
    message.warning('请选择房源');
    return;
  }
  
  callDialog.loading = true;
  const homestay = homestayOptions.value.find(h => h.id === callDialog.homestayId);
  
  try {
    await post<any>({
      url: '/api/cleaning/create',
      params: {
        homestayId: callDialog.homestayId,
        cleaningDate: new Date().toISOString().split('T')[0],
        orderNo: callDialog.remark || '房东叫清洁',
      },
      headers: {},
    });
    
    playNotificationSound();
    speakNotification(`阿姨请注意，${homestay?.title || ''}需要清洁，请尽快前往处理`);
    
    notification.success({
      message: '叫清洁通知已发送',
      description: `已通知阿姨前往${homestay?.title || ''}进行清洁，阿姨可通过扫码拍照上传完成清洁`,
      duration: 5,
    });
    
    callDialog.visible = false;
    loadData();
  } catch (error) {
    message.error('创建清洁任务失败，请检查网络');
  } finally {
    callDialog.loading = false;
  }
};

const showQrTip = () => {
  window.open(cleanerUrl, '_blank');
};

const copyCleanerUrl = () => {
  navigator.clipboard.writeText(cleanerUrl);
  message.success('地址已复制');
};

onMounted(() => {
  loadHomestays();
  loadData();
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
}

.table-operations {
  margin-bottom: 16px;
}

.text-gray {
  color: #999;
}

.image-cell {
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 12px;
}
</style>