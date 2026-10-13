<template>
  <div class="page-view">
    <div class="table-operations">
      <a-space wrap>
        <a-select v-model:value="filters.auditStatus" style="width: 140px" placeholder="审核状态" allow-clear>
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">待审核</a-select-option>
          <a-select-option value="1">已通过</a-select-option>
          <a-select-option value="2">已拒绝</a-select-option>
        </a-select>
        <a-select v-model:value="filters.publishStatus" style="width: 120px" placeholder="上架状态" allow-clear>
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">草稿</a-select-option>
          <a-select-option value="1">已上架</a-select-option>
          <a-select-option value="2">已下架</a-select-option>
        </a-select>
        <a-input v-model:value="filters.title" style="width: 200px" placeholder="房源名称" allow-clear @pressEnter="handleQuery" />
        <a-button type="primary" @click="handleQuery">查询</a-button>
        <a-button @click="handleReset">重置</a-button>
        <a-button type="primary" @click="handleCreate">新增房源</a-button>
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
        <template v-if="column.key === 'cover'">
          <img v-if="record.cover" :src="record.cover" style="width: 80px; height: 60px; object-fit: cover; border-radius: 4px;" />
          <span v-else class="text-gray">无图片</span>
        </template>

        <template v-if="column.key === 'title'">
          <div style="max-width: 200px;">
            <div style="font-weight: 500; margin-bottom: 4px;">{{ record.title }}</div>
            <div style="font-size: 12px; color: #999;">{{ record.city }}{{ record.district }}</div>
          </div>
        </template>

        <template v-if="column.key === 'price'">
          <span style="color: #f5222d; font-weight: 500;">¥{{ record.basePrice }}</span>
          <span v-if="record.weekendPrice" style="font-size: 12px; color: #999; margin-left: 4px;">/ 周末¥{{ record.weekendPrice }}</span>
        </template>

        <template v-if="column.key === 'auditStatus'">
          <a-tag :color="getAuditStatusColor(record.auditStatus)">
            {{ getAuditStatusText(record.auditStatus) }}
          </a-tag>
        </template>

        <template v-if="column.key === 'publishStatus'">
          <a-tag :color="getPublishStatusColor(record.publishStatus)">
            {{ getPublishStatusText(record.publishStatus) }}
          </a-tag>
        </template>

        <template v-if="column.key === 'action'">
          <a-space wrap>
            <a @click="handleEdit(record)">编辑</a>
            <a-divider type="vertical" />
            <a v-if="record.publishStatus === '0' || record.publishStatus === '2'" @click="handlePublish(record)">上架</a>
            <a v-else-if="record.publishStatus === '1'" @click="handleOffline(record)">下架</a>
            <a v-else @click="handleCalendar(record)">房态</a>
            <a-divider type="vertical" />
            <a v-if="record.auditStatus !== '1'" @click="handleDelete(record)" style="color: #ff4d4f;">删除</a>
          </a-space>
        </template>
      </template>
    </a-table>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive, ref } from 'vue';
  import { message, Modal } from 'ant-design-vue';
  import { useRouter } from 'vue-router';
  import { listApi, deleteApi, publishApi, offlineApi } from '/@/api/homestay';
  import { getFormatTime } from '/@/utils';

  const router = useRouter();
  const data = reactive({
    loading: false,
    rows: [] as any[],
    page: 1,
    pageSize: 10,
    total: 0,
  });

  const filters = reactive({
    auditStatus: '',
    publishStatus: '',
    title: '',
  });

  const columns = reactive([
    { title: '序号', dataIndex: 'index', key: 'index', align: 'center', width: 80 },
    { title: '封面', dataIndex: 'cover', key: 'cover', align: 'center', width: 100 },
    { title: '房源名称', dataIndex: 'title', key: 'title', minWidth: 200 },
    { title: '位置', dataIndex: 'address', key: 'address', width: 180, ellipsis: true },
    { title: '房型', dataIndex: 'roomType', key: 'roomType', width: 100 },
    { title: '价格', dataIndex: 'price', key: 'price', width: 150, align: 'right' },
    { title: '可住人数', dataIndex: 'maxGuests', key: 'maxGuests', width: 100, align: 'center' },
    { title: '审核状态', dataIndex: 'auditStatus', key: 'auditStatus', width: 100, align: 'center' },
    { title: '上架状态', dataIndex: 'publishStatus', key: 'publishStatus', width: 100, align: 'center' },
    { title: '创建时间', dataIndex: 'createTime', key: 'createTime', width: 160, align: 'center' },
    { title: '操作', dataIndex: 'action', key: 'action', width: 200, align: 'center', fixed: 'right' },
  ]);

  const getAuditStatusColor = (status: string) => {
    const map: Record<string, string> = { '0': 'orange', '1': 'green', '2': 'red' };
    return map[status] || 'default';
  };

  const getAuditStatusText = (status: string) => {
    const map: Record<string, string> = { '0': '待审核', '1': '已通过', '2': '已拒绝' };
    return map[status] || status;
  };

  const getPublishStatusColor = (status: string) => {
    const map: Record<string, string> = { '0': 'default', '1': 'blue', '2': 'gray' };
    return map[status] || 'default';
  };

  const getPublishStatusText = (status: string) => {
    const map: Record<string, string> = { '0': '草稿', '1': '已上架', '2': '已下架' };
    return map[status] || status;
  };

  const loadData = async () => {
    data.loading = true;
    try {
      const res = await listApi({
        pageNum: data.page,
        pageSize: data.pageSize,
        auditStatus: filters.auditStatus,
        publishStatus: filters.publishStatus,
        title: filters.title,
      });
      // 确保 rows 始终是数组
      data.rows = Array.isArray(res.rows) ? res.rows : [];
      data.total = res.total || 0;
      
      // 如果没有数据，提示用户
      if (data.rows.length === 0 && data.page === 1) {
        // 可以添加提示，但不强制，因为可能是正常情况
      }
    } catch (e: any) {
      message.error(e.message || '加载失败');
      data.rows = [];
      data.total = 0;
    } finally {
      data.loading = false;
    }
  };

  const handleQuery = () => {
    data.page = 1;
    loadData();
  };

  const handleReset = () => {
    filters.auditStatus = '';
    filters.publishStatus = '';
    filters.title = '';
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

  const handleCreate = () => {
    router.push('/homestay/homestay/create');
  };

  const handleEdit = (record: any) => {
    router.push(`/homestay/homestay/edit/${record.id}`);
  };

  const handleCalendar = (record: any) => {
    if (!record || !record.id) {
      message.warning('无效的房源信息');
      return;
    }
    router.push(`/homestay/homestay/calendar?homestayId=${record.id}`);
  };

  const handlePublish = async (record: any) => {
    if (record.auditStatus !== '1') {
      message.warning('请先通过审核才能上架');
      return;
    }
    try {
      await publishApi(record.id);
      message.success('上架成功');
      loadData();
    } catch (e: any) {
      message.error(e.message || '上架失败');
    }
  };

  const handleOffline = async (record: any) => {
    try {
      await offlineApi(record.id);
      message.success('下架成功');
      loadData();
    } catch (e: any) {
      message.error(e.message || '下架失败');
    }
  };

  const handleDelete = (record: any) => {
    Modal.confirm({
      title: '确认删除',
      content: `确定要删除房源"${record.title}"吗？`,
      okText: '确认',
      cancelText: '取消',
      onOk: async () => {
        try {
          await deleteApi(record.id);
          message.success('删除成功');
          loadData();
        } catch (e: any) {
          message.error(e.message || '删除失败');
        }
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

  .text-gray {
    color: #999;
  }
</style>
