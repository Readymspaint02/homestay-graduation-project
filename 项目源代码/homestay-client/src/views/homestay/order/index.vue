<template>
  <div class="page-view">
    <div class="table-operations">
      <a-space wrap>
        <a-select v-model:value="filters.orderStatus" style="width: 140px" placeholder="订单状态" allow-clear>
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">待确认</a-select-option>
          <a-select-option value="1">已确认</a-select-option>
          <a-select-option value="2">已完成</a-select-option>
          <a-select-option value="3">已取消</a-select-option>
        </a-select>
        <a-input v-model:value="filters.homestayName" style="width: 180px" placeholder="房源名称" allow-clear @pressEnter="handleQuery" />
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

        <template v-if="column.key === 'amountTotal'">
          <span style="color: #f5222d; font-weight: 500;">¥{{ record.amountTotal }}</span>
        </template>

        <template v-if="column.key === 'checkinDate'">
          {{ formatDate(record.checkinDate) }}
        </template>

        <template v-if="column.key === 'checkoutDate'">
          {{ formatDate(record.checkoutDate) }}
        </template>

        <template v-if="column.key === 'action'">
          <span v-if="record.orderStatus === '0'">
            <a-button type="link" size="small" @click="handleAccept(record)">接受</a-button>
            <a-button type="link" size="small" danger @click="handleReject(record)">拒绝</a-button>
          </span>
          <span v-else>-</span>
        </template>
      </template>
    </a-table>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive, ref } from 'vue';
  import { message, Modal } from 'ant-design-vue';
  import { landlordListApi, acceptApi } from '/@/api/landlordOrder';

  const data = reactive({
    loading: false,
    rows: [] as any[],
    page: 1,
    pageSize: 10,
    total: 0,
  });

  const filters = reactive({
    orderStatus: '',
    homestayName: '',
  });

  const columns = reactive([
    { title: '序号', dataIndex: 'index', key: 'index', align: 'center', width: 80 },
    { title: '订单号', dataIndex: 'orderNo', key: 'orderNo', width: 180 },
    { title: '房源', dataIndex: 'homestayName', key: 'homestayName', width: 180 },
    { title: '租客', dataIndex: 'tenantName', key: 'tenantName', width: 100 },
    { title: '入住日期', dataIndex: 'checkinDate', key: 'checkinDate', width: 120, align: 'center' },
    { title: '离店日期', dataIndex: 'checkoutDate', key: 'checkoutDate', width: 120, align: 'center' },
    { title: '夜晚数', dataIndex: 'nights', key: 'nights', width: 80, align: 'center' },
    { title: '订单金额', dataIndex: 'amountTotal', key: 'amountTotal', width: 120, align: 'right' },
    { title: '支付状态', dataIndex: 'payStatus', key: 'payStatus', width: 100, align: 'center' },
    { title: '订单状态', dataIndex: 'orderStatus', key: 'orderStatus', width: 100, align: 'center' },
    { title: '创建时间', dataIndex: 'createTime', key: 'createTime', width: 160, align: 'center' },
    { title: '操作', dataIndex: 'action', key: 'action', width: 150, align: 'center', fixed: 'right' },
  ]);

  const getOrderStatusColor = (status: string) => {
    const map: Record<string, string> = { '0': 'orange', '1': 'blue', '2': 'green', '3': 'gray' };
    return map[status] || 'default';
  };

  const getOrderStatusText = (status: string) => {
    const map: Record<string, string> = { '0': '待确认', '1': '已确认', '2': '已完成', '3': '已取消' };
    return map[status] || status;
  };

  const getPayStatusColor = (status: string) => {
    const map: Record<string, string> = { '0': 'red', '1': 'green' };
    return map[status] || 'default';
  };

  const getPayStatusText = (status: string) => {
    const map: Record<string, string> = { '0': '未支付', '1': '已支付' };
    return map[status] || status;
  };

  const formatDate = (date: any) => {
    if (!date) return '--';
    const d = new Date(date);
    return d.toLocaleDateString('zh-CN');
  };

  const loadData = async () => {
    data.loading = true;
    try {
      const res = await landlordListApi({
        pageNum: data.page,
        pageSize: data.pageSize,
        orderStatus: filters.orderStatus,
        homestayName: filters.homestayName,
      });
      data.rows = res.rows || [];
      data.total = res.total || 0;
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
    filters.homestayName = '';
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

  const handleAccept = async (record: any) => {
    Modal.confirm({
      title: '确认接受',
      content: `确定要接受订单"${record.orderNo}"吗？`,
      okText: '确认',
      cancelText: '取消',
      onOk: async () => {
        try {
          await acceptApi(record.id);
          message.success('接受成功');
          loadData();
        } catch (e: any) {
          message.error(e.message || '接受失败');
        }
      },
    });
  };

  const handleReject = (record: any) => {
    Modal.confirm({
      title: '确认拒绝',
      content: `确定要拒绝订单"${record.orderNo}"吗？`,
      okText: '确认',
      cancelText: '取消',
      onOk: async () => {
        message.success('拒绝成功（模拟）');
        loadData();
      },
    });
  };

  onMounted(() => {
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
</style>
