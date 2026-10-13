<template>
  <div class="page-view">
    <a-row :gutter="24">
      <a-col :span="6">
        <a-card :bordered="false">
          <a-statistic title="本月收入" :value="stats.monthIncome" prefix="¥" :precision="2" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false">
          <a-statistic title="累计收入" :value="stats.totalIncome" prefix="¥" :precision="2" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false">
          <a-statistic title="待确认订单" :value="stats.pendingOrders" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false">
          <a-statistic title="已完成订单" :value="stats.finishedOrders" />
        </a-card>
      </a-col>
    </a-row>

    <a-card title="收入趋势" :bordered="false" style="margin-top: 24px;">
      <div ref="chartRef" style="height: 300px;"></div>
    </a-card>

    <a-card title="待办事项" :bordered="false" style="margin-top: 24px;">
      <a-table :columns="todoColumns" :data-source="todoData" :pagination="false" size="small" rowKey="id">
        <template #bodyCell="{ record, column }">
          <template v-if="column.key === 'action'">
            <a-button type="link" size="small" @click="handleTodoAction(record)">处理</a-button>
          </template>
        </template>
      </a-table>
    </a-card>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive, ref } from 'vue';
  import { message } from 'ant-design-vue';
  import * as echarts from 'echarts';
  import { get } from '/@/utils/http/axios';

  const chartRef = ref<HTMLElement | null>(null);
  let chartInstance: echarts.ECharts | null = null;

  const stats = reactive({
    monthIncome: 0,
    totalIncome: 0,
    pendingOrders: 0,
    finishedOrders: 0,
  });

  const todoColumns = reactive([
    { title: '类型', dataIndex: 'type', key: 'type', width: 120 },
    { title: '内容', dataIndex: 'content', key: 'content' },
    { title: '时间', dataIndex: 'time', key: 'time', width: 160 },
    { title: '操作', dataIndex: 'action', key: 'action', width: 100, align: 'center' },
  ]);

  const todoData = ref<any[]>([]);

  const loadStats = async () => {
    try {
      const res = await get<any>({ url: '/api/overview/landlord/income', params: { months: 6 }, headers: {} });
      if (res.data) {
        stats.monthIncome = res.data.monthIncome || 0;
        stats.totalIncome = res.data.totalIncome || 0;
      }
    } catch (e: any) {
      // 使用模拟数据
      stats.monthIncome = 12580;
      stats.totalIncome = 85600;
    }

    try {
      const res = await get<any>({ url: '/api/overview/landlord/orders', params: {}, headers: {} });
      if (res.data) {
        stats.pendingOrders = res.data.pendingOrders || 0;
        stats.finishedOrders = res.data.finishedOrders || 0;
      }
    } catch (e: any) {
      stats.pendingOrders = 3;
      stats.finishedOrders = 28;
    }
  };

  const loadChartData = () => {
    if (!chartRef.value) return;

    chartInstance = echarts.init(chartRef.value);

    const mockData = {
      months: ['8 月', '9 月', '10 月', '11 月', '12 月', '1 月'],
      income: [8500, 12300, 15800, 11200, 18600, 14500],
    };

    const option = {
      tooltip: {
        trigger: 'axis',
      },
      grid: {
        left: '3%',
        right: '4%',
        bottom: '3%',
        containLabel: true,
      },
      xAxis: {
        type: 'category',
        boundaryGap: false,
        data: mockData.months,
      },
      yAxis: {
        type: 'value',
        axisLabel: {
          formatter: '¥{value}',
        },
      },
      series: [
        {
          name: '收入',
          type: 'line',
          smooth: true,
          data: mockData.income,
          areaStyle: {
            color: 'rgba(24, 144, 255, 0.2)',
          },
          itemStyle: {
            color: '#1890ff',
          },
        },
      ],
    };

    chartInstance.setOption(option);

    window.addEventListener('resize', () => {
      chartInstance?.resize();
    });
  };

  const loadTodos = () => {
    todoData.value = [
      { id: 1, type: '订单', content: '待确认订单 #OD20260307001', time: '2026-03-07 10:30' },
      { id: 2, type: '订单', content: '待确认订单 #OD20260307002', time: '2026-03-07 11:15' },
      { id: 3, type: '清洁', content: '301 房待清洁（客人已退房）', time: '2026-03-07 12:00' },
    ];
  };

  const handleTodoAction = (record: any) => {
    if (record.type === '订单') {
      message.info('跳转到订单处理页面（模拟）');
    } else if (record.type === '清洁') {
      message.info('标记为已清洁（模拟）');
    }
  };

  onMounted(() => {
    loadStats();
    loadChartData();
    loadTodos();
  });
</script>

<style scoped lang="less">
  .page-view {
    padding: 24px;
  }
</style>
