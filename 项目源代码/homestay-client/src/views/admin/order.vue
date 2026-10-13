<template>
  <div class="page-view">
    <div class="table-operations">
      <a-space wrap>
        <a-select v-model:value="filters.roleType" style="width: 140px" placeholder="Role">
          <a-select-option value="">All Roles</a-select-option>
          <a-select-option value="landlord">Landlord</a-select-option>
          <a-select-option value="tenant">Tenant</a-select-option>
        </a-select>
        <a-select v-model:value="filters.orderStatus" style="width: 160px" allow-clear placeholder="Order Status">
          <a-select-option v-for="item in orderStatusOptions" :key="item.value" :value="item.value">
            {{ item.label }}
          </a-select-option>
        </a-select>
        <a-select v-model:value="filters.payStatus" style="width: 140px" allow-clear placeholder="Pay Status">
          <a-select-option v-for="item in payStatusOptions" :key="item.value" :value="item.value">
            {{ item.label }}
          </a-select-option>
        </a-select>
        <a-input v-model:value="filters.orderNo" style="width: 220px" allow-clear placeholder="Search by Order No" />
        <a-button type="primary" @click="handleQuery">Query</a-button>
        <a-button @click="handleReset">Reset</a-button>
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
        showTotal: (total) => `Total ${total}`,
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

        <template v-if="column.key === 'orderTime'">
          {{ record.orderTime ? getFormatTime(record.orderTime, true) : '--' }}
        </template>

        <template v-if="column.key === 'payTime'">
          {{ record.payTime ? getFormatTime(record.payTime, true) : '--' }}
        </template>

        <template v-if="column.key === 'confirmTime'">
          {{ record.confirmTime ? getFormatTime(record.confirmTime, true) : '--' }}
        </template>

        <template v-if="column.key === 'amountPayable'">
          {{ formatMoney(record.amountPayable) }}
        </template>

        <template v-if="column.key === 'operation'">
          <span v-if="record.orderStatus === '1'">
            <a-popconfirm title="Confirm this order?" ok-text="Yes" cancel-text="No" @confirm="confirmOrder(record)">
              <a>Confirm</a>
            </a-popconfirm>
            <a-divider type="vertical" />
            <a-popconfirm title="Reject this order?" ok-text="Yes" cancel-text="No" @confirm="rejectOrder(record)">
              <a>Reject</a>
            </a-popconfirm>
          </span>
          <span v-else>-</span>
        </template>
      </template>
    </a-table>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive } from 'vue';
  import { message } from 'ant-design-vue';
  import { listApi, rejectApi, updateApi } from '/@/api/order';
  import { getFormatTime } from '/@/utils';

  const columns = reactive([
    { title: 'No', dataIndex: 'index', key: 'index', align: 'center', width: 80 },
    { title: 'Order No', dataIndex: 'orderNumber', key: 'orderNumber', align: 'center', minWidth: 220 },
    { title: 'Homestay ID', dataIndex: 'thingId', key: 'thingId', align: 'center', width: 110 },
    { title: 'Tenant ID', dataIndex: 'tenantUserId', key: 'tenantUserId', align: 'center', width: 100 },
    { title: 'Landlord ID', dataIndex: 'landlordUserId', key: 'landlordUserId', align: 'center', width: 110 },
    { title: 'Payable', dataIndex: 'amountPayable', key: 'amountPayable', align: 'center', width: 110 },
    { title: 'Pay Status', dataIndex: 'payStatus', key: 'payStatus', align: 'center', width: 110 },
    { title: 'Order Status', dataIndex: 'orderStatus', key: 'orderStatus', align: 'center', width: 120 },
    { title: 'Create Time', dataIndex: 'orderTime', key: 'orderTime', align: 'center', width: 170 },
    { title: 'Pay Time', dataIndex: 'payTime', key: 'payTime', align: 'center', width: 170 },
    { title: 'Confirm Time', dataIndex: 'confirmTime', key: 'confirmTime', align: 'center', width: 170 },
    { title: 'Operation', key: 'operation', align: 'center', width: 130, fixed: 'right' },
  ]);

  const orderStatusOptions = reactive([
    { label: 'WAIT_PAY', value: '0' },
    { label: 'WAIT_LANDLORD', value: '1' },
    { label: 'CONFIRMED', value: '2' },
    { label: 'FINISHED', value: '3' },
    { label: 'CANCELLED', value: '4' },
    { label: 'REJECTED', value: '5' },
  ]);

  const payStatusOptions = reactive([
    { label: 'UNPAID', value: '0' },
    { label: 'PAID', value: '1' },
    { label: 'REFUNDED', value: '2' },
  ]);

  const data = reactive({
    rows: [] as any[],
    loading: false,
    total: 0,
    page: 1,
    pageSize: 10,
  });

  const filters = reactive({
    roleType: 'landlord',
    orderStatus: undefined as string | undefined,
    payStatus: undefined as string | undefined,
    orderNo: '',
  });

  const buildQueryParams = () => {
    const params: Record<string, any> = {
      pageNum: data.page,
      pageSize: data.pageSize,
    };
    if (filters.roleType !== undefined) {
      params.roleType = String(filters.roleType).trim();
    }
    if (filters.orderStatus) {
      params.orderStatus = String(filters.orderStatus).trim();
    }
    if (filters.payStatus) {
      params.payStatus = String(filters.payStatus).trim();
    }
    if (filters.orderNo && filters.orderNo.trim()) {
      params.orderNo = filters.orderNo.trim();
    }
    return params;
  };

  const getDataList = () => {
    data.loading = true;
    listApi(buildQueryParams())
      .then((res) => {
        const rows = Array.isArray(res?.data) ? res.data : [];
        const start = (data.page - 1) * data.pageSize;
        rows.forEach((item: any, index: number) => {
          item.index = start + index + 1;
        });
        data.rows = rows;
        data.total = Number(res?.total || rows.length);
      })
      .catch((err) => {
        message.error(err?.msg || 'Load orders failed');
      })
      .finally(() => {
        data.loading = false;
      });
  };

  const formatMoney = (value: any) => {
    const n = Number(value || 0);
    if (!Number.isFinite(n)) return '0.00';
    return n.toFixed(2);
  };

  const getOrderStatusText = (orderStatus: string) => {
    if (orderStatus === '0') return 'WAIT_PAY';
    if (orderStatus === '1') return 'WAIT_LANDLORD';
    if (orderStatus === '2') return 'CONFIRMED';
    if (orderStatus === '3') return 'FINISHED';
    if (orderStatus === '4') return 'CANCELLED';
    if (orderStatus === '5') return 'REJECTED';
    return 'UNKNOWN';
  };

  const getOrderStatusColor = (orderStatus: string) => {
    if (orderStatus === '1') return '#faad14';
    if (orderStatus === '2') return '#52c41a';
    if (orderStatus === '3') return '#2db7f5';
    if (orderStatus === '4') return '#999999';
    if (orderStatus === '5') return '#ff4d4f';
    return '#d9d9d9';
  };

  const getPayStatusText = (payStatus: string) => {
    if (payStatus === '1') return 'PAID';
    if (payStatus === '2') return 'REFUNDED';
    return 'UNPAID';
  };

  const getPayStatusColor = (payStatus: string) => {
    if (payStatus === '1') return '#2db7f5';
    if (payStatus === '2') return '#fa8c16';
    return '#999999';
  };

  const handleQuery = () => {
    data.page = 1;
    getDataList();
  };

  const handleReset = () => {
    data.page = 1;
    data.pageSize = 10;
    filters.roleType = 'landlord';
    filters.orderStatus = undefined;
    filters.payStatus = undefined;
    filters.orderNo = '';
    getDataList();
  };

  const handlePageChange = (page: number, pageSize: number) => {
    data.page = page;
    data.pageSize = pageSize;
    getDataList();
  };

  const handlePageSizeChange = (_current: number, size: number) => {
    data.page = 1;
    data.pageSize = size;
    getDataList();
  };

  const confirmOrder = (record: any) => {
    updateApi({}, { orderId: record.id })
      .then(() => {
        message.success('Order confirmed');
        getDataList();
      })
      .catch((err) => {
        message.error(err?.msg || 'Confirm failed');
      });
  };

  const rejectOrder = (record: any) => {
    rejectApi({ orderId: record.id, reason: 'rejected-by-admin' })
      .then(() => {
        message.success('Order rejected');
        getDataList();
      })
      .catch((err) => {
        message.error(err?.msg || 'Reject failed');
      });
  };

  onMounted(() => {
    getDataList();
  });
</script>

<style scoped lang="less">
  .page-view {
    min-height: 100%;
    background: #fff;
    padding: 24px;
    display: flex;
    flex-direction: column;
  }

  .table-operations {
    margin-bottom: 16px;
  }
</style>
