<template>
  <div class="page-view">
    <a-row :gutter="16" style="margin-bottom: 16px;">
      <a-col :span="4"><a-card size="small"><a-statistic title="总订单" :value="summary.total" /></a-card></a-col>
      <a-col :span="4"><a-card size="small"><a-statistic title="待处理" :value="summary.pending" :value-style="{ color: '#fa8c16' }" /></a-card></a-col>
      <a-col :span="4"><a-card size="small"><a-statistic title="已确认" :value="summary.confirmed" :value-style="{ color: '#52c41a' }" /></a-card></a-col>
      <a-col :span="4"><a-card size="small"><a-statistic title="已完成" :value="summary.finished" :value-style="{ color: '#52c41a' }" /></a-card></a-col>
      <a-col :span="4"><a-card size="small"><a-statistic title="已取消" :value="summary.canceled" :value-style="{ color: '#ff4d4f' }" /></a-card></a-col>
      <a-col :span="4"><a-card size="small"><a-statistic title="已拒绝" :value="summary.rejected" :value-style="{ color: '#ff4d4f' }" /></a-card></a-col>
    </a-row>

    <div class="table-operations">
      <a-space wrap>
        <a-select v-model:value="filters.orderStatus" style="width: 140px" placeholder="订单状态" allow-clear>
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">待支付</a-select-option>
          <a-select-option value="1">待房东处理</a-select-option>
          <a-select-option value="2">已确认</a-select-option>
          <a-select-option value="3">已完成</a-select-option>
          <a-select-option value="4">已取消</a-select-option>
          <a-select-option value="5">已拒绝</a-select-option>
        </a-select>
        <a-input v-model:value="filters.orderNo" style="width: 200px" placeholder="订单号" allow-clear @pressEnter="handleQuery" />
        <a-button type="primary" @click="handleQuery">查询</a-button>
        <a-button @click="handleReset">重置</a-button>
      </a-space>
    </div>

    <a-table
      size="middle"
      rowKey="id"
      :loading="data.loading"
      :columns="columns"
      :data-source="data.rows"
      :scroll="{ x: 'max-content' }"
      :pagination="{
        size: 'default',
        current: data.page,
        pageSize: data.pageSize,
        total: data.total,
        showSizeChanger: true,
        showTotal: (total) => `共 ${total} 条`,
        onChange: handlePageChange,
        onShowSizeChange: handlePageSizeChange,
      }"
    >
      <template #bodyCell="{ record, column }">
        <template v-if="column.key === 'orderStatus'">
          <a-tag :color="getOrderStatusColor(record.orderStatus)">
            {{ getOrderStatusText(record.orderStatus) }}
          </a-tag>
        </template>

        <template v-if="column.key === 'payStatus'">
          <a-tag :color="getPayStatusColor(record.payStatus)">
            {{ getPayStatusText(record.payStatus) }}
          </a-tag>
        </template>

        <template v-if="column.key === 'amountPayable'">
          <span style="color: #f5222d; font-weight: 500;">¥{{ record.amountPayable }}</span>
        </template>

        <template v-if="column.key === 'checkinDate'">
          {{ formatDate(record.checkinDate) }}
        </template>

        <template v-if="column.key === 'checkoutDate'">
          {{ formatDate(record.checkoutDate) }}
        </template>

<template v-if="column.key === 'createTime'">
           {{ formatCreateTime(record.createTime) }}
         </template>

         <template v-if="column.key === 'action'">
           <a-space>
             <a-button type="primary" size="small" @click="handleDetail(record)">详情</a-button>
             <a-button v-if="record.orderStatus === '1'" type="primary" size="small" @click="handleAccept(record)">接受</a-button>
             <a-button v-if="record.orderStatus === '1'" danger size="small" @click="handleReject(record)">拒绝</a-button>
           </a-space>
         </template>
      </template>
    </a-table>

    <a-modal v-model:open="rejectDialog.visible" title="拒绝订单" width="420px" @ok="submitReject">
      <a-form layout="vertical">
        <a-form-item label="订单号">
          <a-tag>{{ rejectDialog.orderNo }}</a-tag>
        </a-form-item>
        <a-form-item label="拒绝原因" required>
          <a-textarea v-model:value="rejectDialog.reason" :rows="4" placeholder="请输入拒绝原因（必填）" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, reactive, ref, computed } from 'vue';
import { message, Modal, notification } from 'ant-design-vue';
import { get, post } from '/@/utils/http/axios';

const data = reactive({
  loading: false,
  rows: [] as any[],
  page: 1,
  pageSize: 10,
  total: 0,
});

const filters = reactive({
  orderStatus: '',
  orderNo: '',
});

const rejectDialog = reactive({
  visible: false,
  orderId: null as number | null,
  orderNo: '',
  reason: '',
});

let sseSource: EventSource | null = null;

const summary = computed(() => {
  const result = { total: data.rows.length, pending: 0, confirmed: 0, finished: 0, canceled: 0, rejected: 0 };
  data.rows.forEach((item) => {
    if (item.orderStatus === '1') result.pending += 1;
    if (item.orderStatus === '2') result.confirmed += 1;
    if (item.orderStatus === '3') result.finished += 1;
    if (item.orderStatus === '4') result.canceled += 1;
    if (item.orderStatus === '5') result.rejected += 1;
  });
  return result;
});

const columns = reactive([
  { title: '订单号', dataIndex: 'orderNo', key: 'orderNo', width: 200 },
  { title: '房源', dataIndex: 'homestayName', key: 'homestayName', width: 150 },
  { title: '入住日期', dataIndex: 'checkinDate', key: 'checkinDate', width: 120, align: 'center' },
  { title: '离店日期', dataIndex: 'checkoutDate', key: 'checkoutDate', width: 120, align: 'center' },
  { title: '金额', dataIndex: 'amountPayable', key: 'amountPayable', width: 100, align: 'right' },
  { title: '支付状态', dataIndex: 'payStatus', key: 'payStatus', width: 100, align: 'center' },
  { title: '订单状态', dataIndex: 'orderStatus', key: 'orderStatus', width: 120, align: 'center' },
  { title: '创建时间', dataIndex: 'createTime', key: 'createTime', width: 160, align: 'center' },
  { title: '操作', dataIndex: 'action', key: 'action', width: 150, align: 'center', fixed: 'right' },
]);

const getOrderStatusColor = (status: string) => {
  const map: Record<string, string> = { '0': 'default', '1': 'orange', '2': 'blue', '3': 'green', '4': 'gray', '5': 'red' };
  return map[status] || 'default';
};

const getOrderStatusText = (status: string) => {
  const map: Record<string, string> = { '0': '待支付', '1': '待房东处理', '2': '已确认', '3': '已完成', '4': '已取消', '5': '已拒绝' };
  return map[status] || status;
};

const getPayStatusColor = (status: string) => {
  const map: Record<string, string> = { '0': 'red', '1': 'green', '2': 'orange' };
  return map[status] || 'default';
};

const getPayStatusText = (status: string) => {
  const map: Record<string, string> = { '0': '未支付', '1': '已支付', '2': '已退款' };
  return map[status] || status;
};

const formatDate = (date: any) => {
  if (!date) return '--';
  return new Date(date).toLocaleDateString('zh-CN');
};

const formatCreateTime = (date: any) => {
  if (!date) return '--';
  const d = new Date(date);
  const year = d.getFullYear();
  const month = String(d.getMonth() + 1).padStart(2, '0');
  const day = String(d.getDate()).padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const handleDetail = (record: any) => {
  Modal.info({
    title: '订单详情',
    width: 600,
    content: `
      <div style="line-height: 2;">
        <p><b>订单号：</b>${record.orderNo || '--'}</p>
        <p><b>房源：</b>${record.homestayName || '--'}</p>
        <p><b>入住日期：</b>${formatDate(record.checkinDate)}</p>
        <p><b>离店日期：</b>${formatDate(record.checkoutDate)}</p>
        <p><b>金额：</b>¥${record.amountPayable || '0'}</p>
        <p><b>支付状态：</b>${getPayStatusText(record.payStatus)}</p>
        <p><b>订单状态：</b>${getOrderStatusText(record.orderStatus)}</p>
        <p><b>创建时间：</b>${formatCreateTime(record.createTime)}</p>
        ${record.cancelReason ? `<p><b>备注：</b>${record.cancelReason}</p>` : ''}
      </div>
    `,
  });
};

const playNotificationSound = () => {
  try {
    const audioContext = new (window.AudioContext || (window as any).webkitAudioContext)();
    const oscillator = audioContext.createOscillator();
    const gainNode = audioContext.createGain();
    oscillator.connect(gainNode);
    gainNode.connect(audioContext.destination);
    oscillator.frequency.value = 800;
    oscillator.type = 'sine';
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime);
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5);
    oscillator.start(audioContext.currentTime);
    oscillator.stop(audioContext.currentTime + 0.5);
  } catch (e) {
    console.log('Audio not supported');
  }
};

const speakNotification = (text: string) => {
  if ('speechSynthesis' in window) {
    const utterance = new SpeechSynthesisUtterance(text);
    utterance.lang = 'zh-CN';
    utterance.rate = 1;
    utterance.volume = 1;
    speechSynthesis.speak(utterance);
  }
};

const loadData = async () => {
  data.loading = true;
  const startTime = performance.now();
  try {
    const res = await get<any>({
      url: '/api/order/landlord/list',
      params: {
        pageNum: data.page,
        pageSize: data.pageSize,
        orderStatus: filters.orderStatus,
        homestayName: filters.orderNo,
      },
      headers: {},
    });
    data.rows = res.rows || [];
    data.total = res.total || 0;
    console.log(`[性能] 订单列表加载耗时: ${Math.round(performance.now() - startTime)}ms`);
  } catch (e: any) {
    message.error(e.message || '加载失败');
  } finally {
    data.loading = false;
  }
};

const handleQuery = () => {
  data.page = 1;
  loadData();
};

const handleReset = () => {
  filters.orderStatus = '';
  filters.orderNo = '';
  handleQuery();
};

const handlePageChange = (page: number) => {
  data.page = page;
  loadData();
};

const handlePageSizeChange = (page: number, pageSize: number) => {
  data.page = page;
  data.pageSize = pageSize;
  loadData();
};

const handleAccept = (record: any) => {
  Modal.confirm({
    title: '确认接受',
    content: `确定要接受订单"${record.orderNo}"吗？`,
    okText: '确认',
    cancelText: '取消',
    onOk: async () => {
      try {
        await post<any>({ url: '/api/order/confirm', data: { orderId: record.id }, headers: {} });
        message.success('接受成功');
        loadData();
      } catch (e: any) {
        message.error(e.message || '接受失败');
      }
    },
  });
};

const handleReject = (record: any) => {
  rejectDialog.orderId = record.id;
  rejectDialog.orderNo = record.orderNo || '';
  rejectDialog.reason = '';
  rejectDialog.visible = true;
};

const submitReject = async () => {
  if (!rejectDialog.reason.trim()) {
    message.warning('请填写拒绝原因');
    return;
  }
  try {
    await post<any>({
      url: '/api/order/reject',
      data: { orderId: rejectDialog.orderId, reason: rejectDialog.reason.trim() },
      headers: {},
    });
    message.success('拒绝成功');
    rejectDialog.visible = false;
    loadData();
  } catch (e: any) {
    message.error(e.message || '拒绝失败');
  }
};

const subscribeSse = () => {
  const token = localStorage.getItem('user_token');
  if (!token) return;
  const baseUrl = (window as any).BASE_URL || '';
  const url = `${baseUrl}/api/order/message/subscribe?token=${token}`;
  sseSource = new EventSource(url);
  sseSource.addEventListener('new_order', (event) => {
    try {
      const res = JSON.parse(event.data);
      playNotificationSound();
      speakNotification(`收到新订单，订单号${res.orderNo || ''}，请及时处理`);
      notification.success({
        message: '新订单提醒',
        description: `收到新订单 #${res.orderNo || ''}，请及时处理`,
        duration: 0,
      });
      loadData();
    } catch (e) {}
  });
  sseSource.onmessage = (event) => {
    try {
      const res = JSON.parse(event.data);
      if (res.type === 'new_order' || res.orderStatus === '0' || res.orderStatus === '1') {
        playNotificationSound();
        speakNotification(`收到新订单，订单号${res.orderNo || ''}，请及时处理`);
        notification.success({
          message: '新订单提醒',
          description: `收到新订单 #${res.orderNo || ''}，请及时处理`,
          duration: 0,
        });
        loadData();
      }
    } catch (e) {}
  };
};

onMounted(() => {
  loadData();
  subscribeSse();
});

onUnmounted(() => {
  if (sseSource) {
    sseSource.close();
  }
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
}

.table-operations {
  margin-bottom: 16px;
}
</style>