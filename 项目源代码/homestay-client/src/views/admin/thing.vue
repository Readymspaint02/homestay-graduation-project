<template>
  <div class="page-view">
    <div class="table-operations">
      <a-space wrap>
        <a-button type="primary" @click="handleAdd">新增房源</a-button>
        <a-button :loading="data.loading" @click="getDataList">刷新</a-button>
        <a-select v-model:value="data.auditStatus" style="width: 130px" placeholder="审核状态" allow-clear @change="onSearch">
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">待审核</a-select-option>
          <a-select-option value="1">已通过</a-select-option>
          <a-select-option value="2">已拒绝</a-select-option>
        </a-select>
        <a-select v-model:value="data.publishStatus" style="width: 130px" placeholder="上架状态" allow-clear @change="onSearch">
          <a-select-option value="">全部</a-select-option>
          <a-select-option value="0">草稿</a-select-option>
          <a-select-option value="1">已上架</a-select-option>
          <a-select-option value="2">已下架</a-select-option>
        </a-select>
        <a-input-search
          v-model:value="data.keyword"
          addon-before="标题"
          enter-button
          placeholder="输入标题关键词"
          @search="onSearch"
          style="width: 320px"
        />
      </a-space>
    </div>

    <a-table
      size="middle"
      row-key="id"
      :loading="data.loading"
      :columns="columns"
      :data-source="data.dataList"
      :scroll="{ x: 'max-content' }"
      :pagination="{
        size: 'default',
        current: data.page,
        pageSize: data.pageSize,
        total: data.total,
        onChange: onPageChange,
        showSizeChanger: false,
        showTotal: (total) => `共${total}条`,
      }"
    >
      <template #bodyCell="{ column, record }">
        <template v-if="column.key === 'auditStatus'">
          <a-tag :color="auditColor(record.auditStatus)">{{ auditText(record.auditStatus) }}</a-tag>
        </template>
        <template v-else-if="column.key === 'publishStatus'">
          <a-tag :color="publishColor(record.publishStatus)">{{ publishText(record.publishStatus) }}</a-tag>
        </template>
        <template v-else-if="column.key === 'cleaningStatus'">
          <a-tag :color="cleanColor(record.cleaningStatus)">{{ cleanText(record.cleaningStatus) }}</a-tag>
        </template>
        <template v-else-if="column.key === 'createTime'">
          {{ formatDateTime(record.createTime) }}
        </template>
        <template v-else-if="column.key === 'operation'">
          <a-space>
            <a @click="handleEdit(record)">编辑</a>
            <a @click="handleAuditPass(record)" v-if="record.auditStatus !== '1'">通过</a>
            <a @click="handleAuditReject(record)" v-if="record.auditStatus !== '2'">驳回</a>
            <a @click="handlePublishOn(record)" v-if="record.auditStatus === '1' && record.publishStatus !== '1'">上架</a>
            <a @click="handlePublishOff(record)" v-if="record.publishStatus !== '2'">下架</a>
          </a-space>
        </template>
      </template>
    </a-table>

    <a-modal
      :visible="modal.visible"
      :force-render="true"
      :title="modal.title"
      width="920px"
      ok-text="确认"
      cancel-text="取消"
      :confirm-loading="modal.submitting"
      @cancel="handleCancel"
      @ok="handleOk"
    >
      <a-form ref="myform" :label-col="{ style: { width: '90px' } }" :model="modal.form" :rules="modal.rules">
        <a-row :gutter="16">
          <a-col :span="12">
            <a-form-item label="标题" name="title">
              <a-input v-model:value="modal.form.title" placeholder="请输入房源标题" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="城市" name="city">
              <a-input v-model:value="modal.form.city" placeholder="例如：Guangzhou" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="省份">
              <a-input v-model:value="modal.form.province" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="区县">
              <a-input v-model:value="modal.form.district" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="地址">
              <a-input v-model:value="modal.form.address" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="基础价格" name="basePrice">
              <a-input-number v-model:value="modal.form.basePrice" :min="1" :precision="2" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="可住人数" name="maxGuests">
              <a-input-number v-model:value="modal.form.maxGuests" :min="1" :precision="0" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="清洁状态" name="cleaningStatus">
              <a-select v-model:value="modal.form.cleaningStatus">
                <a-select-option value="0">待保洁</a-select-option>
                <a-select-option value="1">清洁中</a-select-option>
                <a-select-option value="2">可入住</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="经度">
              <a-input-number v-model:value="modal.form.longitude" :precision="6" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="纬度">
              <a-input-number v-model:value="modal.form.latitude" :precision="6" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="描述">
              <a-textarea v-model:value="modal.form.description" :rows="3" />
            </a-form-item>
          </a-col>
          <a-col :span="24">
            <a-form-item label="备注">
              <a-textarea v-model:value="modal.form.remark" :rows="2" />
            </a-form-item>
          </a-col>
        </a-row>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { FormInstance, message, Modal } from 'ant-design-vue';
import { auditApi, createApi, adminListApi, publishApi, updateApi } from '/@/api/thing';

const columns = [
  { title: 'ID', dataIndex: 'id', key: 'id', width: 90 },
  { title: '标题', dataIndex: 'title', key: 'title', width: 220 },
  { title: '城市', dataIndex: 'city', key: 'city', width: 120 },
  { title: '价格/晚', dataIndex: 'price', key: 'price', width: 120 },
  { title: '审核状态', dataIndex: 'auditStatus', key: 'auditStatus', width: 120 },
  { title: '发布状态', dataIndex: 'publishStatus', key: 'publishStatus', width: 120 },
  { title: '清洁状态', dataIndex: 'cleaningStatus', key: 'cleaningStatus', width: 120 },
  { title: '创建时间', dataIndex: 'createTime', key: 'createTime', width: 170 },
  { title: '操作', dataIndex: 'action', key: 'operation', fixed: 'right', width: 320 },
];

const data = reactive({
  dataList: [] as any[],
  loading: false,
  keyword: '',
  auditStatus: undefined as string | undefined,
  publishStatus: undefined as string | undefined,
  page: 1,
  pageSize: 10,
  total: 0,
});

const defaultForm = () => ({
  id: undefined as number | undefined,
  title: '',
  province: '',
  city: '',
  district: '',
  address: '',
  longitude: undefined as number | undefined,
  latitude: undefined as number | undefined,
  basePrice: 199,
  maxGuests: 2,
  cleaningStatus: '0',
  description: '',
  remark: '',
});

const modal = reactive({
  visible: false,
  editFlag: false,
  submitting: false,
  title: '新增房源',
  form: defaultForm(),
  rules: {
    title: [{ required: true, message: '请输入标题', trigger: 'change' }],
    city: [{ required: true, message: '请输入城市', trigger: 'change' }],
    basePrice: [{ required: true, message: '请输入基础价格', trigger: 'change' }],
    maxGuests: [{ required: true, message: '请输入可住人数', trigger: 'change' }],
    cleaningStatus: [{ required: true, message: '请选择清洁状态', trigger: 'change' }],
  },
});

const myform = ref<FormInstance>();

onMounted(() => {
  getDataList();
});

const getDataList = () => {
  data.loading = true;
  adminListApi({
    keyword: data.keyword,
    auditStatus: data.auditStatus,
    publishStatus: data.publishStatus,
    pageNum: data.page,
    pageSize: data.pageSize,
  })
    .then((res) => {
      data.dataList = (res.data || []).map((item: any) => ({
        ...item,
        price: Number(item.basePrice ?? item.price ?? 0).toFixed(2),
      }));
      data.total = Number(res.total || data.dataList.length);
    })
    .catch((err) => {
      message.error(err?.msg || '加载房源列表失败');
    })
    .finally(() => {
      data.loading = false;
    });
};

const onSearch = () => {
  data.page = 1;
  getDataList();
};

const onPageChange = (page: number) => {
  data.page = page;
  getDataList();
};

const resetModal = () => {
  myform.value?.resetFields();
  modal.form = defaultForm();
};

const handleAdd = () => {
  resetModal();
  modal.editFlag = false;
  modal.title = '新增房源';
  modal.visible = true;
};

const handleEdit = (record: any) => {
  resetModal();
  modal.editFlag = true;
  modal.title = `编辑房源 #${record.id}`;
  modal.form = {
    id: Number(record.id),
    title: String(record.title || ''),
    province: String(record.province || ''),
    city: String(record.city || ''),
    district: String(record.district || ''),
    address: String(record.address || ''),
    longitude: record.longitude === null || record.longitude === undefined ? undefined : Number(record.longitude),
    latitude: record.latitude === null || record.latitude === undefined ? undefined : Number(record.latitude),
    basePrice: Number(record.basePrice ?? record.price ?? 199),
    maxGuests: Number(record.maxGuests || 2),
    cleaningStatus: String(record.cleaningStatus || '0'),
    description: String(record.description || ''),
    remark: String(record.remark || ''),
  };
  modal.visible = true;
};

const handleOk = () => {
  myform.value
    ?.validate()
    .then(async () => {
      modal.submitting = true;
      try {
        if (modal.editFlag) {
          await updateApi(modal.form);
          message.success('房源更新成功');
        } else {
          await createApi(modal.form);
          message.success('房源创建成功');
        }
        modal.visible = false;
        getDataList();
      } catch (err: any) {
        message.error(err?.msg || '操作失败');
      } finally {
        modal.submitting = false;
      }
    })
    .catch(() => {});
};

const handleCancel = () => {
  modal.visible = false;
};

const handleAuditPass = async (record: any) => {
  try {
    await auditApi({ id: record.id, auditStatus: '1', publishStatus: record.publishStatus === '0' ? '1' : undefined });
    message.success('审核已通过');
    getDataList();
  } catch (err: any) {
    message.error(err?.msg || '操作失败');
  }
};

const handleAuditReject = (record: any) => {
  let rejectReason = '';
  Modal.confirm({
    title: '驳回房源',
    content: () => (
      <div>
        <p style="margin-bottom: 8px;">请输入驳回理由（必填）：</p>
        <a-textarea
          placeholder="例如：房源信息不完整、图片不符合要求等"
          rows={4}
          maxlength={200}
          show-count
          onInput={(e: any) => { rejectReason = e.target.value; }}
        />
      </div>
    ),
    okText: '确认驳回',
    okType: 'danger',
    cancelText: '取消',
    onOk: async () => {
      if (!rejectReason.trim()) {
        message.warning('请输入驳回理由');
        return Promise.reject();
      }
      try {
        await auditApi({ id: record.id, auditStatus: '2', publishStatus: '2', remark: rejectReason });
        message.success('已驳回');
        getDataList();
      } catch (err: any) {
        message.error(err?.msg || '操作失败');
        return Promise.reject();
      }
    },
  });
};

const handlePublishOn = async (record: any) => {
  try {
    await publishApi({ id: record.id, publishStatus: '1' });
    message.success('已上架');
    getDataList();
  } catch (err: any) {
    message.error(err?.msg || '操作失败');
  }
};

const handlePublishOff = async (record: any) => {
  try {
    await publishApi({ id: record.id, publishStatus: '2' });
    message.success('已下架');
    getDataList();
  } catch (err: any) {
    message.error(err?.msg || '操作失败');
  }
};

const auditText = (value: string) => {
  if (value === '1') return '通过';
  if (value === '2') return '驳回';
  return '待审';
};

const auditColor = (value: string) => {
  if (value === '1') return 'green';
  if (value === '2') return 'red';
  return 'gold';
};

const publishText = (value: string) => {
  if (value === '1') return '已上架';
  if (value === '2') return '已下架';
  return '草稿';
};

const publishColor = (value: string) => {
  if (value === '1') return 'green';
  if (value === '2') return 'default';
  return 'blue';
};

const cleanText = (value: string) => {
  if (value === '2') return '可入住';
  if (value === '1') return '清洁中';
  return '待保洁';
};

const cleanColor = (value: string) => {
  if (value === '2') return 'green';
  if (value === '1') return 'gold';
  return 'red';
};

const formatDateTime = (value: any) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  const year = date.getFullYear();
  const month = `${date.getMonth() + 1}`.padStart(2, '0');
  const day = `${date.getDate()}`.padStart(2, '0');
  const hh = `${date.getHours()}`.padStart(2, '0');
  const mm = `${date.getMinutes()}`.padStart(2, '0');
  const ss = `${date.getSeconds()}`.padStart(2, '0');
  return `${year}-${month}-${day} ${hh}:${mm}:${ss}`;
};
</script>

<style scoped lang="less">
.page-view {
  min-height: 100%;
  background: #fff;
  padding: 20px;
  display: flex;
  flex-direction: column;
}

.table-operations {
  margin-bottom: 14px;
  display: flex;
  justify-content: flex-end;
}
</style>
