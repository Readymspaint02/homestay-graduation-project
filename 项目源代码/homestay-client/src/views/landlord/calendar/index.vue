<template>
  <div class="page-view">
    <a-card :bordered="false">
      <template #title>
        <a-space>
          <span>房态日历</span>
          <a-select v-model:value="selectedHomestayId" placeholder="请选择房源" style="width: 300px" @change="loadData">
            <a-select-option v-for="item in homestayOptions" :key="item.id" :value="item.id">{{ item.title }}</a-select-option>
          </a-select>
        </a-space>
      </template>
      <template #extra>
        <a-space>
          <a-button @click="prevMonth">上个月</a-button>
          <span style="font-size: 16px; font-weight: 500;">{{ currentYear }}年{{ currentMonth }}月</span>
          <a-button @click="nextMonth">下个月</a-button>
        </a-space>
      </template>

      <div class="legend" style="margin-bottom: 16px;">
        <a-space>
          <span>图例：</span>
          <a-tag color="green">可订</a-tag>
          <a-tag color="orange">已锁单</a-tag>
          <a-tag color="red">已预订</a-tag>
          <a-tag color="gray">维护中</a-tag>
        </a-space>
      </div>

      <div class="calendar-table-wrapper">
        <a-table
          :columns="calendarColumns"
          :data-source="calendarData"
          :loading="loading"
          :pagination="false"
          bordered
          size="small"
          :scroll="{ x: 'max-content' }"
        >
        <template #bodyCell="{ record, column }">
          <template v-if="column.key.startsWith('day')">
            <div
              v-if="record[column.key]"
              class="calendar-cell"
              :class="{ 'disabled-cell': record[column.key] === '2' }"
              @click="handleCellClick(record, column.key)"
            >
              <a-tag :color="getStatusColor(record[column.key])" size="small">
                {{ getStatusText(record[column.key]) }}
              </a-tag>
              <div v-if="record[`${column.key}_order`]" style="font-size: 10px; color: #fa8c16; margin-top: 2px;">
                有订单
              </div>
            </div>
          </template>
        </template>
      </a-table>
      </div>
    </a-card>

    <a-modal v-model:open="dialogVisible" title="房态操作" width="480px">
      <div v-if="selectedCell">
        <p>日期：{{ selectedCell.date }}</p>
        <p>当前状态：
          <a-tag :color="getStatusColor(selectedCell.status)">{{ getStatusText(selectedCell.status) }}</a-tag>
        </p>
        <div v-if="selectedCell.orderNo" style="margin-top: 12px;">
          <p style="font-weight: 500; margin-bottom: 8px;">关联订单信息</p>
          <p>订单号：{{ selectedCell.orderNo }}</p>
          <p v-if="selectedCell.tenantName">租客：{{ selectedCell.tenantName }}</p>
          <p v-if="selectedCell.amount">金额：¥{{ selectedCell.amount }}</p>
        </div>
      </div>
      <template #footer>
        <a-space>
          <a-button v-if="selectedCell?.status === '0'" type="primary" danger @click="handleLock">设为维护中</a-button>
          <a-button v-if="selectedCell?.status === '4'" type="primary" @click="handleUnlock">恢复可订</a-button>
          <a-button @click="dialogVisible = false">关闭</a-button>
        </a-space>
      </template>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, computed } from 'vue';
import { message } from 'ant-design-vue';
import { useRoute } from 'vue-router';
import { get, post } from '/@/utils/http/axios';

const route = useRoute();
const loading = ref(false);
const currentYear = ref(new Date().getFullYear());
const currentMonth = ref(new Date().getMonth() + 1);
const dialogVisible = ref(false);
const selectedCell = ref<any>(null);
const selectedHomestayId = ref<any>(null);
const homestayOptions = ref<any[]>([]);

const daysInMonth = computed(() => {
  return new Date(currentYear.value, currentMonth.value, 0).getDate();
});

const calendarColumns = computed(() => {
  const cols: any[] = [{ title: '周', dataIndex: 'week', key: 'week', width: 50, fixed: 'left' }];
  for (let i = 1; i <= daysInMonth.value; i++) {
    cols.push({ title: `${i}`, key: `day${i}`, width: 50, align: 'center' });
  }
  return cols;
});

const calendarData = ref<any[]>([]);

const getStatusColor = (status: string) => {
  const map: Record<string, string> = { '0': 'green', '1': 'orange', '2': 'red', '4': 'gray' };
  return map[status] || 'default';
};

const getStatusText = (status: string) => {
  const map: Record<string, string> = { '0': '可订', '1': '已锁', '2': '已订', '4': '维护' };
  return map[status] || status;
};

const loadHomestays = async () => {
  try {
    const res = await get<any>({ url: '/api/homestay/landlord/list', params: { pageNum: 1, pageSize: 100 }, headers: {} });
    homestayOptions.value = res.rows || [];
    const queryId = route.query.homestayId;
    if (queryId) {
      selectedHomestayId.value = Number(queryId);
    } else if (homestayOptions.value.length > 0) {
      selectedHomestayId.value = homestayOptions.value[0].id;
    }
    if (selectedHomestayId.value) {
      loadData();
    }
  } catch (error) {
    message.error('加载房源列表失败');
  }
};

const loadData = async () => {
  if (!selectedHomestayId.value) return;
  loading.value = true;
  try {
    const res = await get<any>({
      url: `/api/homestay/${selectedHomestayId.value}/calendar`,
      params: { year: currentYear.value, month: currentMonth.value },
      headers: {},
    });
    if (res.data) {
      const days = daysInMonth.value;
      const data: any[] = [];
      const firstDay = new Date(currentYear.value, currentMonth.value - 1, 1).getDay();
      const weeks = Math.ceil((days + firstDay) / 7);

      for (let w = 0; w < weeks; w++) {
        const week: any = { week: `第${w + 1}周` };
        for (let d = 1; d <= 7; d++) {
          const dayNum = w * 7 + d - firstDay;
          if (dayNum >= 1 && dayNum <= days) {
            week[`day${dayNum}`] = '0';
            week[`day${dayNum}_date`] = `${currentYear.value}-${String(currentMonth.value).padStart(2, '0')}-${String(dayNum).padStart(2, '0')}`;

            const calendarItem = res.data.calendars?.find((c: any) => {
              const cDate = new Date(c.bizDate);
              return cDate.getFullYear() === currentYear.value &&
                     cDate.getMonth() + 1 === currentMonth.value &&
                     cDate.getDate() === dayNum;
            });

            if (calendarItem) {
              week[`day${dayNum}`] = calendarItem.status;
            }

            const orderItem = res.data.orders?.find((o: any) => {
              const checkin = new Date(o.checkinDate);
              const checkout = new Date(o.checkoutDate);
              const target = new Date(currentYear.value, currentMonth.value - 1, dayNum);
              return target >= checkin && target < checkout;
            });

            if (orderItem) {
              week[`day${dayNum}_order`] = true;
              week[`day${dayNum}_order_raw`] = orderItem;
            }
          }
        }
        data.push(week);
      }
      calendarData.value = data;
    }
  } catch (error) {
    message.error('加载失败');
  } finally {
    loading.value = false;
  }
};

const prevMonth = () => {
  currentMonth.value--;
  if (currentMonth.value < 1) {
    currentMonth.value = 12;
    currentYear.value--;
  }
  loadData();
};

const nextMonth = () => {
  currentMonth.value++;
  if (currentMonth.value > 12) {
    currentMonth.value = 1;
    currentYear.value++;
  }
  loadData();
};

const handleCellClick = (record: any, key: string) => {
  const dayNum = parseInt(key.replace('day', ''));
  const orderInfo = record[`${key}_order_raw`];
  selectedCell.value = {
    date: `${currentYear.value}-${String(currentMonth.value).padStart(2, '0')}-${String(dayNum).padStart(2, '0')}`,
    status: record[key],
    orderNo: orderInfo?.orderNo || '',
    tenantName: orderInfo?.tenantName || '',
    amount: orderInfo?.amountPayable || '',
  };
  dialogVisible.value = true;
};

const handleLock = async () => {
  if (!selectedCell.value || !selectedHomestayId.value) return;
  try {
    await post<any>({
      url: `/api/homestay/${selectedHomestayId.value}/calendar/lock`,
      params: { date: selectedCell.value.date },
      headers: {},
    });
    message.success('锁定成功');
    dialogVisible.value = false;
    loadData();
  } catch (error) {
    message.error('锁定失败');
  }
};

const handleUnlock = async () => {
  if (!selectedCell.value || !selectedHomestayId.value) return;
  try {
    await post<any>({
      url: `/api/homestay/${selectedHomestayId.value}/calendar/unlock`,
      params: { date: selectedCell.value.date },
      headers: {},
    });
    message.success('解锁成功');
    dialogVisible.value = false;
    loadData();
  } catch (error) {
    message.error('解锁失败');
  }
};

onMounted(() => {
  loadHomestays();
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
}

.calendar-table-wrapper {
  width: 100%;
  overflow-x: auto;
}

.calendar-cell {
  min-height: 36px;
  cursor: pointer;
  padding: 4px;
  border-radius: 4px;

  &:hover {
    background-color: #f5f5f5;
  }

  &.disabled-cell {
    background-color: #d9d9d9;
    opacity: 0.5;
    pointer-events: none;
    cursor: not-allowed;
  }
}

:deep(.ant-table-thead > tr > th) {
  padding: 8px 4px;
  font-size: 12px;
  white-space: nowrap;
}

:deep(.ant-table-tbody > tr > td) {
  padding: 4px;
}
</style>