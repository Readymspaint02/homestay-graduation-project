<template>
  <div class="page-view">
    <a-row :gutter="[16, 16]" class="stats-row">
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Total">{{ stats.total || 0 }}</a-card>
      </a-col>
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Pending">{{ stats.pending || 0 }}</a-card>
      </a-col>
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Success">{{ stats.success || 0 }}</a-card>
      </a-col>
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Failed">{{ stats.failed || 0 }}</a-card>
      </a-col>
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Check-in Type">{{ stats.checkinType || 0 }}</a-card>
      </a-col>
      <a-col :sm="12" :md="8" :lg="4">
        <a-card size="small" title="Mode">{{ (stats.mode || 'mock').toUpperCase() }}</a-card>
      </a-col>
    </a-row>

    <div class="table-operations">
      <a-space>
        <a-button type="primary" :loading="actionLoading" @click="handleGenerate">Generate</a-button>
        <a-button :loading="actionLoading" @click="handleProcess">Process Pending</a-button>
        <a-button :disabled="selectedRowKeys.length === 0" :loading="actionLoading" @click="handleRetryBatch">Retry Selected</a-button>
        <a-button danger :loading="actionLoading" @click="handleMockFail">Insert Failed Sample</a-button>
        <a-button @click="refreshAll">Refresh</a-button>
      </a-space>
    </div>

    <a-table
      size="middle"
      rowKey="id"
      :loading="loading"
      :columns="columns"
      :data-source="rows"
      :row-selection="rowSelection"
      :scroll="{ x: 'max-content' }"
      :pagination="{
        size: 'default',
        current: pageNum,
        pageSize,
        total,
        onChange: handlePageChange,
        showSizeChanger: false,
        showTotal: (t) => `Total ${t}`,
      }"
    >
      <template #bodyCell="{ record, column }">
        <template v-if="column.key === 'reportType'">
          <a-tag>{{ typeText(record.reportType) }}</a-tag>
        </template>

        <template v-if="column.key === 'reportStatus'">
          <a-tag :color="statusColor(record.reportStatus)">{{ statusText(record.reportStatus) }}</a-tag>
        </template>

        <template v-if="column.key === 'requestJson' || column.key === 'responseJson'">
          <div class="json-cell">{{ toShortText(record[column.key]) }}</div>
        </template>

        <template v-if="column.key === 'operation'">
          <a-button type="link" size="small" @click="retryOne(record)">Retry</a-button>
        </template>
      </template>
    </a-table>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { generateApi, listApi, processApi, pushApi, retryApi, retryBatchApi, statsApi } from '/@/api/supervision';
import { getFormatTime } from '/@/utils';

const loading = ref(false);
const actionLoading = ref(false);
const rows = ref<any[]>([]);
const pageNum = ref(1);
const pageSize = ref(10);
const total = ref(0);
const selectedRowKeys = ref<number[]>([]);

const stats = reactive<any>({
  total: 0,
  pending: 0,
  success: 0,
  failed: 0,
  checkinType: 0,
  orderStatType: 0,
  mode: 'mock',
});

const rowSelection = computed(() => ({
  selectedRowKeys: selectedRowKeys.value,
  onChange: (keys: number[]) => {
    selectedRowKeys.value = keys;
  },
}));

const columns = reactive([
  { title: 'No', dataIndex: 'index', key: 'index', align: 'center', width: 80 },
  { title: 'Report No', dataIndex: 'reportNo', key: 'reportNo', align: 'center', width: 220 },
  { title: 'Type', dataIndex: 'reportType', key: 'reportType', align: 'center', width: 120 },
  { title: 'Biz ID', dataIndex: 'bizId', key: 'bizId', align: 'center', width: 120 },
  { title: 'Status', dataIndex: 'reportStatus', key: 'reportStatus', align: 'center', width: 120 },
  { title: 'Platform', dataIndex: 'targetPlatform', key: 'targetPlatform', align: 'center', width: 140 },
  { title: 'HTTP', dataIndex: 'httpStatus', key: 'httpStatus', align: 'center', width: 100 },
  { title: 'ErrorCode', dataIndex: 'errorCode', key: 'errorCode', align: 'center', width: 140 },
  { title: 'Retry', dataIndex: 'retryCount', key: 'retryCount', align: 'center', width: 80 },
  {
    title: 'CreateTime',
    dataIndex: 'createTime',
    key: 'createTime',
    align: 'center',
    width: 180,
    customRender: ({ text }) => getFormatTime(text, true),
  },
  {
    title: 'ReportTime',
    dataIndex: 'lastReportTime',
    key: 'lastReportTime',
    align: 'center',
    width: 180,
    customRender: ({ text }) => (text ? getFormatTime(text, true) : '--'),
  },
  { title: 'Request', dataIndex: 'requestJson', key: 'requestJson', align: 'left', width: 240 },
  { title: 'Response', dataIndex: 'responseJson', key: 'responseJson', align: 'left', width: 240 },
  { title: 'Operation', key: 'operation', align: 'center', width: 100 },
]);

onMounted(() => {
  refreshAll();
});

const handlePageChange = (page: number) => {
  pageNum.value = page;
  fetchList();
};

const refreshAll = () => {
  selectedRowKeys.value = [];
  fetchStats();
  fetchList();
};

const fetchList = () => {
  loading.value = true;
  listApi({ pageNum: pageNum.value, pageSize: pageSize.value })
    .then((res) => {
      rows.value = res?.rows || [];
      total.value = Number(res?.total || 0);
    })
    .catch((err) => {
      message.error(err?.msg || 'Failed to load supervision reports');
    })
    .finally(() => {
      loading.value = false;
    });
};

const fetchStats = () => {
  statsApi()
    .then((res) => {
      Object.assign(stats, res?.data || {});
    })
    .catch((err) => {
      message.error(err?.msg || 'Failed to load supervision stats');
    });
};

const handleGenerate = () => {
  actionLoading.value = true;
  generateApi(50)
    .then((res) => {
      message.success(`Generated ${res?.data || 0} reports`);
      refreshAll();
    })
    .catch((err) => {
      message.error(err?.msg || 'Generate failed');
    })
    .finally(() => {
      actionLoading.value = false;
    });
};

const handleProcess = () => {
  actionLoading.value = true;
  processApi(50)
    .then((res) => {
      message.success(`Processed ${res?.data || 0} reports`);
      refreshAll();
    })
    .catch((err) => {
      message.error(err?.msg || 'Process failed');
    })
    .finally(() => {
      actionLoading.value = false;
    });
};

const retryOne = (record: any) => {
  actionLoading.value = true;
  retryApi(Number(record?.id || 0))
    .then(() => {
      message.success('Retry submitted');
      refreshAll();
    })
    .catch((err) => {
      message.error(err?.msg || 'Retry failed');
    })
    .finally(() => {
      actionLoading.value = false;
    });
};

const handleRetryBatch = () => {
  actionLoading.value = true;
  retryBatchApi(selectedRowKeys.value)
    .then((res) => {
      message.success(`Batch retried ${res?.data || 0} reports`);
      refreshAll();
    })
    .catch((err) => {
      message.error(err?.msg || 'Batch retry failed');
    })
    .finally(() => {
      actionLoading.value = false;
    });
};

const handleMockFail = () => {
  actionLoading.value = true;
  pushApi({
    reportType: '3',
    bizId: Date.now(),
    requestJson: '{"scene":"ui-demo-fail","forceFail":true}',
  })
    .then(() => processApi(20))
    .then(() => {
      message.success('Inserted failed sample');
      refreshAll();
    })
    .catch((err) => {
      message.error(err?.msg || 'Insert failed sample failed');
    })
    .finally(() => {
      actionLoading.value = false;
    });
};

const typeText = (type: string) => {
  if (type === '1') return 'Homestay';
  if (type === '2') return 'Check-in';
  if (type === '3') return 'Order-Status';
  return 'Unknown';
};

const statusText = (status: string) => {
  if (status === '0') return 'Pending';
  if (status === '1') return 'Success';
  if (status === '2') return 'Failed';
  return 'Unknown';
};

const statusColor = (status: string) => {
  if (status === '0') return '#999';
  if (status === '1') return '#52c41a';
  if (status === '2') return '#ff4d4f';
  return '#999';
};

const toShortText = (text: string) => {
  const raw = String(text || '');
  if (!raw) return '--';
  return raw.length > 120 ? `${raw.slice(0, 120)}...` : raw;
};
</script>

<style scoped lang="less">
.page-view {
  min-height: 100%;
  background: #fff;
  padding: 24px;
  display: flex;
  flex-direction: column;
}

.stats-row {
  margin-bottom: 16px;
}

.table-operations {
  margin-bottom: 16px;
  text-align: right;
}

.json-cell {
  white-space: pre-wrap;
  word-break: break-all;
  font-family: Consolas, Menlo, Monaco, monospace;
  font-size: 12px;
  line-height: 1.4;
}
</style>
