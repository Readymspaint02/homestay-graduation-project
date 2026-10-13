<template>
  <div class="page-view">
    <a-card :title="`房态日历 - ${currentHomestay?.title || ''}`" :bordered="false">
      <div class="calendar-header" style="margin-bottom: 16px;">
        <a-space>
          <a-button @click="prevMonth">上个月</a-button>
          <span style="font-size: 16px; font-weight: 500;">
            {{ currentYear }}年{{ currentMonth }}月
          </span>
          <a-button @click="nextMonth">下个月</a-button>
        </a-space>
      </div>

      <div class="legend" style="margin-bottom: 16px;">
        <a-space>
          <span>图例：</span>
          <a-tag color="green">可订</a-tag>
          <a-tag color="red">已预订</a-tag>
          <a-tag color="orange">已锁单</a-tag>
          <a-tag color="gray">维护中</a-tag>
        </a-space>
      </div>

      <div class="calendar-wrapper">
        <div class="calendar-weekdays">
          <div class="weekday-item" v-for="day in weekDays" :key="day">{{ day }}</div>
        </div>
        <a-spin :spinning="loading">
          <div class="calendar-grid">
            <div
              v-for="(cell, index) in calendarCells"
              :key="index"
              class="calendar-cell"
              :class="{
                'empty': !cell.day,
                'today': cell.isToday,
                [getStatusClass(cell.status)]: cell.day
              }"
              @click="handleCellClick(cell)"
            >
              <div v-if="cell.day" class="cell-content">
                <div class="cell-day">{{ cell.day }}</div>
                <div class="cell-status">
                  <a-tag :color="getStatusColor(cell.status)" size="small">
                    {{ getStatusText(cell.status) }}
                  </a-tag>
                </div>
                <div v-if="cell.hasOrder" class="cell-order">有订单</div>
              </div>
            </div>
          </div>
        </a-spin>
      </div>

      <a-modal v-model:open="actionModalVisible" title="房态操作" :footer="null">
        <div v-if="selectedCell">
          <p>日期：{{ selectedCell.date }}</p>
          <p>当前状态：{{ getStatusText(selectedCell.status) }}</p>
          <a-space>
            <a-button v-if="selectedCell.status === '0'" type="primary" @click="handleLock">设为维护中</a-button>
            <a-button v-if="selectedCell.status === '4'" danger @click="handleUnlock">恢复可订</a-button>
          </a-space>
        </div>
      </a-modal>
    </a-card>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, ref, computed } from 'vue';
  import { useRoute } from 'vue-router';
  import { message } from 'ant-design-vue';
  import { getCalendarDataApi, lockApi, unlockApi } from '/@/api/cleaning';

  const route = useRoute();
  const loading = ref(false);
  const currentYear = ref(new Date().getFullYear());
  const currentMonth = ref(new Date().getMonth() + 1);
  const actionModalVisible = ref(false);
  const selectedCell = ref<any>(null);
  const currentHomestay = ref<any>(null);
  const calendarData = ref<any[]>([]);
  const orderData = ref<any[]>([]);

  const weekDays = ['日', '一', '二', '三', '四', '五', '六'];

  const calendarCells = computed(() => {
    const daysInMonth = new Date(currentYear.value, currentMonth.value, 0).getDate();
    const firstDayOfWeek = new Date(currentYear.value, currentMonth.value - 1, 1).getDay();
    const today = new Date();
    const cells: any[] = [];

    for (let i = 0; i < firstDayOfWeek; i++) {
      cells.push({ day: null });
    }

    for (let day = 1; day <= daysInMonth; day++) {
      const dateStr = `${currentYear.value}-${String(currentMonth.value).padStart(2, '0')}-${String(day).padStart(2, '0')}`;
      const isToday = today.getFullYear() === currentYear.value &&
                      today.getMonth() + 1 === currentMonth.value &&
                      today.getDate() === day;

      const calendarItem = calendarData.value.find((c: any) => {
        const cDate = new Date(c.bizDate);
        return cDate.getFullYear() === currentYear.value &&
               cDate.getMonth() + 1 === currentMonth.value &&
               cDate.getDate() === day;
      });

      const hasOrder = orderData.value.some((o: any) => {
        const checkin = new Date(o.checkinDate);
        const checkout = new Date(o.checkoutDate);
        const target = new Date(currentYear.value, currentMonth.value - 1, day);
        return target >= checkin && target < checkout;
      });

      cells.push({
        day,
        date: dateStr,
        status: calendarItem?.status || '0',
        isToday,
        hasOrder,
      });
    }

    return cells;
  });

  const getStatusColor = (status: string) => {
    const map: Record<string, string> = { '0': 'green', '1': 'orange', '2': 'red', '4': 'gray' };
    return map[status] || 'default';
  };

  const getStatusText = (status: string) => {
    const map: Record<string, string> = { '0': '可订', '1': '已锁', '2': '已订', '4': '维护' };
    return map[status] || status;
  };

  const getStatusClass = (status: string) => {
    const map: Record<string, string> = {
      '0': 'status-available',
      '1': 'status-locked',
      '2': 'status-booked',
      '4': 'status-maintenance'
    };
    return map[status] || '';
  };

  const loadData = async () => {
    loading.value = true;
    try {
      const homestayId = Number(route.query.homestayId);
      if (!homestayId || isNaN(homestayId)) {
        message.warning('请先选择房源');
        loading.value = false;
        return;
      }
      const res = await getCalendarDataApi(homestayId, String(currentYear.value), String(currentMonth.value));
      currentHomestay.value = res.data?.homestay;
      calendarData.value = Array.isArray(res.data?.calendars) ? res.data.calendars : [];
      orderData.value = Array.isArray(res.data?.orders) ? res.data.orders : [];
    } catch (e: any) {
      message.error(e.message || '加载失败');
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

  const handleCellClick = (cell: any) => {
    if (!cell.day) return;
    selectedCell.value = {
      date: cell.date,
      status: cell.status,
    };
    actionModalVisible.value = true;
  };

  const handleLock = async () => {
    if (!selectedCell.value) return;
    try {
      const homestayId = Number(route.query.homestayId);
      await lockApi(homestayId, selectedCell.value.date);
      message.success('锁定成功');
      actionModalVisible.value = false;
      loadData();
    } catch (e: any) {
      message.error(e.message || '锁定失败');
    }
  };

  const handleUnlock = async () => {
    if (!selectedCell.value) return;
    try {
      const homestayId = Number(route.query.homestayId);
      await unlockApi(homestayId, selectedCell.value.date);
      message.success('解锁成功');
      actionModalVisible.value = false;
      loadData();
    } catch (e: any) {
      message.error(e.message || '解锁失败');
    }
  };

  onMounted(() => {
    loadData();
  });
</script>

<style scoped lang="less">
  .page-view {
    padding: 24px;
  }

  .calendar-wrapper {
    border: 1px solid #e8e8e8;
    border-radius: 8px;
    overflow: hidden;
    background: #fff;
  }

  .calendar-weekdays {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    background: #fafafa;
    border-bottom: 1px solid #e8e8e8;
  }

  .weekday-item {
    padding: 12px 8px;
    text-align: center;
    font-weight: 600;
    color: #333;
    font-size: 14px;
  }

  .calendar-grid {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    gap: 1px;
    background: #f0f0f0;
  }

  .calendar-cell {
    min-height: 80px;
    background: #fff;
    padding: 8px;
    cursor: pointer;
    transition: all 0.2s;

    &:hover:not(.empty) {
      background: #f5f5f5;
    }

    &.empty {
      background: #fafafa;
      cursor: default;
    }

    &.today {
      background: #e6f7ff;
    }

    &.status-available {
      background: #f6ffed;
    }

    &.status-booked {
      background: #fff1f0;
    }

    &.status-locked {
      background: #fff7e6;
    }

    &.status-maintenance {
      background: #f5f5f5;
    }
  }

  .cell-content {
    display: flex;
    flex-direction: column;
    height: 100%;
  }

  .cell-day {
    font-size: 16px;
    font-weight: 600;
    color: #333;
    margin-bottom: 4px;
  }

  .cell-status {
    margin-top: auto;
  }

  .cell-order {
    font-size: 11px;
    color: #999;
    margin-top: 2px;
  }
</style>
