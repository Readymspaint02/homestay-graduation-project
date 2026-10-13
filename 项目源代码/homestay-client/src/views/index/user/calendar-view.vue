<template>
  <div class="content-list">
    <div class="list-title">房态日历管理</div>
    <div class="list-content">
      <a-form layout="inline" class="query-bar">
        <a-form-item label="房源">
          <a-select
            v-model:value="selectedHomestayId"
            :options="homestayOptions"
            :field-names="{ label: 'title', value: 'id' }"
            placeholder="请选择房源"
            style="width: 240px"
            @change="handleHomestayChange"
          />
        </a-form-item>
        <a-form-item label="日期范围">
          <a-range-picker v-model:value="queryRange" value-format="YYYY-MM-DD" />
        </a-form-item>
        <a-form-item>
          <a-button type="primary" :loading="loading" @click="loadCalendar">查询</a-button>
        </a-form-item>
      </a-form>

      <a-divider />

      <div class="batch-card">
        <div class="batch-title">批量更新</div>
        <a-form layout="inline">
          <a-form-item label="更新区间">
            <a-range-picker v-model:value="updateForm.dateRange" value-format="YYYY-MM-DD" />
          </a-form-item>
          <a-form-item label="房态">
            <a-select v-model:value="updateForm.status" placeholder="可选" style="width: 160px" allow-clear>
              <a-select-option value="0">可预订</a-select-option>
              <a-select-option value="3">停用/不可订</a-select-option>
            </a-select>
          </a-form-item>
          <a-form-item label="价格">
            <a-input-number v-model:value="updateForm.price" :min="1" :precision="2" placeholder="可选" />
          </a-form-item>
          <a-form-item>
            <a-button type="primary" :loading="submitting" @click="handleBatchUpdate">保存更新</a-button>
          </a-form-item>
        </a-form>
      </div>

      <a-table
        class="calendar-table"
        size="middle"
        row-key="id"
        :loading="loading"
        :columns="columns"
        :data-source="calendarRows"
        :pagination="{ pageSize: 20, showSizeChanger: false }"
      >
        <template #bodyCell="{ column, record }">
          <template v-if="column.key === 'status'">
            <a-tag :color="statusColor(record.status)">{{ statusText(record.status) }}</a-tag>
          </template>
        </template>
      </a-table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { listCalendarApi, updateCalendarApi } from '/@/api/calendar';
import { listApi as listHomestayApi } from '/@/api/homestay';
import { useUserStore } from '/@/store';

const userStore = useUserStore();

const loading = ref(false);
const submitting = ref(false);
const homestayOptions = ref<any[]>([]);
const selectedHomestayId = ref<number>();
const queryRange = ref<string[]>([]);
const calendarRows = ref<any[]>([]);

const updateForm = reactive({
  dateRange: [] as string[],
  status: undefined as string | undefined,
  price: undefined as number | undefined,
});

const columns = [
  { title: '日期', dataIndex: 'bizDateText', key: 'bizDate' },
  { title: '房态', dataIndex: 'status', key: 'status' },
  { title: '价格', dataIndex: 'priceText', key: 'price' },
  { title: '更新时间', dataIndex: 'updateTimeText', key: 'updateTime' },
];

onMounted(async () => {
  await loadHomestays();
  if (selectedHomestayId.value) {
    loadCalendar();
  }
});

const loadHomestays = async () => {
  try {
    const res = await listHomestayApi({
      pageNum: 1,
      pageSize: 200,
    });
    homestayOptions.value = res.rows || [];
    if (!selectedHomestayId.value && homestayOptions.value.length > 0) {
      selectedHomestayId.value = Number(homestayOptions.value[0].id);
      const [startDate, endDate] = getDefaultRange();
      queryRange.value = [startDate, endDate];
      updateForm.dateRange = [startDate, endDate];
    }
  } catch (_error) {
    message.error('获取房源列表失败');
  }
};

const loadCalendar = async () => {
  if (!selectedHomestayId.value) {
    message.warning('请先选择房源');
    return;
  }
  if (!queryRange.value || queryRange.value.length !== 2) {
    const [startDate, endDate] = getDefaultRange();
    queryRange.value = [startDate, endDate];
  }
  loading.value = true;
  try {
    const res = await listCalendarApi(selectedHomestayId.value, queryRange.value[0], queryRange.value[1]);
    calendarRows.value = (res.data || []).map((item: any) => ({
      ...item,
      bizDateText: formatDate(item.bizDate),
      updateTimeText: formatDateTime(item.updateTime),
      priceText: formatPrice(item.price),
    }));
  } catch (error: any) {
    message.error(error?.msg || '加载日历失败');
  } finally {
    loading.value = false;
  }
};

const handleHomestayChange = () => {
  calendarRows.value = [];
  loadCalendar();
};

const handleBatchUpdate = async () => {
  if (!selectedHomestayId.value) {
    message.warning('请先选择房源');
    return;
  }
  if (!updateForm.dateRange || updateForm.dateRange.length !== 2) {
    message.warning('请选择更新日期范围');
    return;
  }
  const hasStatus = !!updateForm.status;
  const hasPrice = Number(updateForm.price) > 0;
  if (!hasStatus && !hasPrice) {
    message.warning('请至少选择一个更新项（房态或价格）');
    return;
  }
  submitting.value = true;
  try {
    await updateCalendarApi({
      homestayId: selectedHomestayId.value,
      startDate: updateForm.dateRange[0],
      endDate: updateForm.dateRange[1],
      status: updateForm.status || undefined,
      price: hasPrice ? Number(updateForm.price) : undefined,
    });
    message.success('日历更新成功');
    queryRange.value = [...updateForm.dateRange];
    loadCalendar();
  } catch (error: any) {
    message.error(error?.msg || '更新失败');
  } finally {
    submitting.value = false;
  }
};

const getDefaultRange = () => {
  const start = new Date();
  const end = new Date();
  end.setDate(end.getDate() + 30);
  return [toDateString(start), toDateString(end)];
};

const toDateString = (value: Date) => {
  const year = value.getFullYear();
  const month = `${value.getMonth() + 1}`.padStart(2, '0');
  const day = `${value.getDate()}`.padStart(2, '0');
  return `${year}-${month}-${day}`;
};

const formatDate = (value: any) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  return toDateString(date);
};

const formatDateTime = (value: any) => {
  if (!value) return '-';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  const hh = `${date.getHours()}`.padStart(2, '0');
  const mm = `${date.getMinutes()}`.padStart(2, '0');
  const ss = `${date.getSeconds()}`.padStart(2, '0');
  return `${toDateString(date)} ${hh}:${mm}:${ss}`;
};

const formatPrice = (value: any) => {
  const num = Number(value || 0);
  if (!Number.isFinite(num)) return '0.00';
  return num.toFixed(2);
};

const statusText = (value: string) => {
  if (value === '0') return '可预订';
  if (value === '1') return '锁定';
  if (value === '2') return '已预订';
  if (value === '3') return '停用';
  return value || '-';
};

const statusColor = (value: string) => {
  if (value === '0') return 'green';
  if (value === '1') return 'gold';
  if (value === '2') return 'blue';
  if (value === '3') return 'red';
  return 'default';
};
</script>

<style scoped lang="less">
.content-list {
  flex: 1;
}

.list-title {
  color: #152844;
  font-weight: 600;
  font-size: 18px;
  height: 48px;
  margin-bottom: 4px;
  border-bottom: 1px solid #cedce4;
}

.list-content {
  padding-top: 12px;
}

.query-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}

.batch-card {
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 12px;
  margin-bottom: 16px;
  background: #fafcff;
}

.batch-title {
  font-size: 14px;
  color: #152844;
  font-weight: 600;
  margin-bottom: 10px;
}

.calendar-table {
  margin-top: 8px;
}
</style>
