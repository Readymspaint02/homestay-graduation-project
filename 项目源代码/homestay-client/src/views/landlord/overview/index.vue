<template>
  <div class="page-view">
    <a-row :gutter="[16, 16]">
      <a-col :span="6">
        <a-card :bordered="false" class="stat-card stat-card-income">
          <div class="stat-icon">
            <span class="icon-coin">💰</span>
          </div>
          <a-statistic title="本月收入" :value="stats.monthIncome" prefix="¥" :precision="2" :value-style="{ color: '#52c41a', fontWeight: 600 }" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false" class="stat-card stat-card-total">
          <div class="stat-icon">
            <span class="icon-chart">📊</span>
          </div>
          <a-statistic title="累计收入" :value="stats.totalIncome" prefix="¥" :precision="2" :value-style="{ color: '#1890ff', fontWeight: 600 }" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false" class="stat-card stat-card-pending">
          <div class="stat-icon">
            <span class="icon-clock">⏰</span>
          </div>
          <a-statistic title="待确认订单" :value="stats.pendingOrders" :value-style="{ color: '#faad14', fontWeight: 600 }" />
        </a-card>
      </a-col>
      <a-col :span="6">
        <a-card :bordered="false" class="stat-card stat-card-done">
          <div class="stat-icon">
            <span class="icon-check">✅</span>
          </div>
          <a-statistic title="已完成订单" :value="stats.finishedOrders" :value-style="{ color: '#722ed1', fontWeight: 600 }" />
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="[16, 16]" style="margin-top: 8px;">
      <a-col :span="16">
        <a-card title="近6个月收入趋势" :bordered="false" class="chart-card">
          <template #extra>
            <a-button type="primary" size="small" @click="exportCsv">
              <template #icon><DownloadOutlined /></template>
              导出CSV
            </a-button>
          </template>
          <div ref="chartRef" style="height: 320px;"></div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card title="待办事项" :bordered="false" class="chart-card">
          <div v-if="todoData.length === 0" class="empty-todo">
            <span>🎉 暂无待办事项</span>
          </div>
          <a-list v-else :data-source="todoData" size="small">
            <template #renderItem="{ item }">
              <a-list-item>
                <a-list-item-meta :title="item.content">
                  <template #avatar>
                    <a-avatar :style="{ backgroundColor: item.type === '订单' ? '#e6f7ff' : '#f6ffed', color: item.type === '订单' ? '#1890ff' : '#52c41a' }">
                      {{ item.type === '订单' ? '订' : '洁' }}
                    </a-avatar>
                  </template>
                </a-list-item-meta>
                <template #actions>
                  <a-button type="link" size="small" @click="handleTodoAction(item)">处理</a-button>
                </template>
              </a-list-item>
            </template>
          </a-list>
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="[16, 16]" style="margin-top: 8px;">
      <a-col :span="12">
        <a-card title="近30日收入分布" :bordered="false" class="chart-card">
          <div ref="pieChartRef" style="height: 300px;"></div>
        </a-card>
      </a-col>
      <a-col :span="12">
        <a-card title="近30日收入明细" :bordered="false" class="chart-card">
          <template #extra>
            <span class="total-label">合计: <span class="total-amount">¥{{ total30Days }}</span></span>
          </template>
          <a-table :columns="incomeColumns" :data-source="dailyIncomeList" :pagination="false" size="small" rowKey="date" :scroll="{ y: 260 }">
            <template #bodyCell="{ record, column }">
              <template v-if="column.key === 'amount'">
                <span class="income-amount">¥{{ record.amount }}</span>
              </template>
              <template v-if="column.key === 'orderCount'">
                <a-tag :color="record.orderCount > 0 ? 'blue' : 'default'">{{ record.orderCount }}单</a-tag>
              </template>
            </template>
          </a-table>
        </a-card>
      </a-col>
    </a-row>
  </div>
</template>

<script setup lang="ts">
import { onMounted, reactive, ref, computed } from 'vue';
import { message } from 'ant-design-vue';
import { useRouter } from 'vue-router';
import * as echarts from 'echarts';
import { get } from '/@/utils/http/axios';
import { DownloadOutlined } from '@ant-design/icons-vue';

const router = useRouter();
const chartRef = ref<HTMLElement | null>(null);
const pieChartRef = ref<HTMLElement | null>(null);
let chartInstance: echarts.ECharts | null = null;
let pieChartInstance: echarts.ECharts | null = null;

const stats = reactive({
  monthIncome: 0,
  totalIncome: 0,
  pendingOrders: 0,
  finishedOrders: 0,
});

const incomeColumns = reactive([
  { title: '日期', dataIndex: 'date', key: 'date', width: 100 },
  { title: '收入', dataIndex: 'amount', key: 'amount', width: 100, align: 'right' },
  { title: '订单数', dataIndex: 'orderCount', key: 'orderCount', width: 80, align: 'center' },
]);

const todoData = ref<any[]>([]);
const dailyIncomeList = ref<any[]>([]);
const trendData = ref<{ month: string; income: number }[]>([]);

const total30Days = computed(() => {
  return dailyIncomeList.value.reduce((s, d) => s + parseFloat(d.amount || '0'), 0).toFixed(2);
});

const loadStats = async () => {
  try {
    const res = await get<any>({ url: '/api/overview/landlord/income', params: { months: 6 }, headers: {} });
    if (res.data) {
      stats.monthIncome = res.data.thisMonthIncome || 0;
      stats.totalIncome = res.data.totalIncome || 0;
      trendData.value = res.data.trend || [];
    }
  } catch (e: any) {
    console.error('Failed to load income stats:', e);
  }

  try {
    const res = await get<any>({ url: '/api/overview/landlord/orders', params: {}, headers: {} });
    if (res.data) {
      const statusBreakdown = res.data.statusBreakdown || {};
      stats.pendingOrders = statusBreakdown['待确认'] || 0;
      stats.finishedOrders = (statusBreakdown['入住中/已完成'] || 0) + (statusBreakdown['已确认'] || 0);
    }
  } catch (e: any) {
    console.error('Failed to load order stats:', e);
  }

  try {
    const res = await get<any>({ url: '/api/overview/landlord/daily-income', params: {}, headers: {} });
    if (res.data && res.data.dailyIncome) {
      dailyIncomeList.value = res.data.dailyIncome.map((item: any) => {
        const dateParts = item.date ? item.date.split('-') : ['', '', ''];
        return {
          date: dateParts[1] && dateParts[2] ? `${parseInt(dateParts[1])}/${parseInt(dateParts[2])}` : item.date,
          fullDate: item.date,
          amount: item.amount || '0.00',
          orderCount: item.orderCount || 0,
        };
      });
    }
  } catch (e: any) {
    console.error('Failed to load daily income:', e);
  }
};

const loadChartData = () => {
  if (!chartRef.value) return;

  chartInstance = echarts.init(chartRef.value);

  const months = trendData.value.length > 0 
    ? trendData.value.map(t => t.month.substring(5) + '月')
    : ['1月', '2月', '3月', '4月', '5月', '6月'];
  const income = trendData.value.length > 0
    ? trendData.value.map(t => t.income)
    : [0, 0, 0, 0, 0, 0];

  const option = {
    tooltip: {
      trigger: 'axis',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e8e8e8',
      borderWidth: 1,
      textStyle: { color: '#333' },
      formatter: (params: any) => {
        const data = params[0];
        return `<div style="padding: 4px 8px;"><strong>${data.name}</strong><br/>收入: <span style="color:#52c41a;font-weight:600;">¥${data.value.toLocaleString()}</span></div>`;
      },
    },
    grid: { left: '3%', right: '4%', bottom: '3%', top: '8%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: months,
      axisLine: { lineStyle: { color: '#e8e8e8' } },
      axisLabel: { color: '#666' },
    },
    yAxis: {
      type: 'value',
      axisLabel: { formatter: '¥{value}', color: '#666' },
      splitLine: { lineStyle: { color: '#f0f0f0', type: 'dashed' } },
    },
    series: [{
      name: '收入',
      type: 'line',
      smooth: true,
      symbol: 'circle',
      symbolSize: 8,
      data: income,
      areaStyle: {
        color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
          { offset: 0, color: 'rgba(82, 196, 26, 0.3)' },
          { offset: 1, color: 'rgba(82, 196, 26, 0.05)' },
        ]),
      },
      lineStyle: { color: '#52c41a', width: 3 },
      itemStyle: { color: '#52c41a', borderColor: '#fff', borderWidth: 2 },
    }],
  };

  chartInstance.setOption(option);
  window.addEventListener('resize', () => chartInstance?.resize());
};

const loadPieChart = () => {
  if (!pieChartRef.value || dailyIncomeList.value.length === 0) return;
  pieChartInstance = echarts.init(pieChartRef.value);

  const dataWithIncome = dailyIncomeList.value.filter(d => parseFloat(d.amount || '0') > 0);
  const top5 = dataWithIncome.slice(0).sort((a, b) => parseFloat(b.amount || '0') - parseFloat(a.amount || '0')).slice(0, 5);
  const totalIncome = dataWithIncome.reduce((s, d) => s + parseFloat(d.amount || '0'), 0);
  const otherIncome = totalIncome - top5.reduce((s, d) => s + parseFloat(d.amount || '0'), 0);
  
  const colors = ['#5470c6', '#91cc75', '#fac858', '#ee6666', '#73c0de', '#3ba272'];
  const pieData = top5.map((d, i) => ({ 
    name: d.date, 
    value: parseFloat(d.amount || '0'),
    itemStyle: { color: colors[i % colors.length] }
  }));
  
  if (otherIncome > 0) {
    pieData.push({ name: '其他', value: otherIncome, itemStyle: { color: colors[5] } });
  }

  if (pieData.length === 0) {
    pieData.push({ name: '暂无数据', value: 1, itemStyle: { color: '#d9d9d9' } });
  }

  pieChartInstance.setOption({
    tooltip: {
      trigger: 'item',
      backgroundColor: 'rgba(255, 255, 255, 0.95)',
      borderColor: '#e8e8e8',
      formatter: '{b}: ¥{c} ({d}%)',
    },
    legend: {
      orient: 'vertical',
      right: '5%',
      top: 'center',
      itemWidth: 10,
      itemHeight: 10,
      textStyle: { color: '#666' },
    },
    series: [{
      type: 'pie',
      radius: ['45%', '75%'],
      center: ['40%', '50%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 6,
        borderColor: '#fff',
        borderWidth: 2,
      },
      label: { show: false },
      emphasis: {
        label: { show: true, fontSize: 14, fontWeight: 'bold' },
        itemStyle: { shadowBlur: 10, shadowOffsetX: 0, shadowColor: 'rgba(0, 0, 0, 0.2)' },
      },
      labelLine: { show: false },
      data: pieData,
    }],
  });
  window.addEventListener('resize', () => pieChartInstance?.resize());
};

const loadTodos = async () => {
  try {
    const res = await get<any>({ url: '/api/overview/landlord/orders', params: {}, headers: {} });
    if (res.data) {
      const statusBreakdown = res.data.statusBreakdown || {};
      const pendingCount = statusBreakdown['待确认'] || 0;
      const todos: any[] = [];
      
      if (pendingCount > 0) {
        todos.push({ id: 1, type: '订单', content: `有 ${pendingCount} 个待确认订单` });
      }
      
      todoData.value = todos;
    }
  } catch (e: any) {
    console.error('Failed to load todos:', e);
  }
};

const handleTodoAction = (record: any) => {
  if (record.type === '订单') {
    router.push({ name: 'landlordOrder' });
  } else if (record.type === '清洁') {
    router.push({ name: 'landlordCleaning' });
  }
};

const exportCsv = () => {
  if (dailyIncomeList.value.length === 0) {
    message.warning('暂无数据可导出');
    return;
  }
  let csv = '\uFEFF日期,收入,订单数\n';
  dailyIncomeList.value.forEach(d => {
    csv += `${d.fullDate || d.date},${d.amount},${d.orderCount}\n`;
  });
  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  link.href = URL.createObjectURL(blob);
  link.download = `收入明细_${new Date().toLocaleDateString('zh-CN')}.csv`;
  link.click();
  URL.revokeObjectURL(link.href);
  message.success('CSV导出成功');
};

onMounted(async () => {
  await loadStats();
  loadChartData();
  loadPieChart();
  loadTodos();
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
  background: #f5f7fa;
  min-height: 100vh;
}

.stat-card {
  position: relative;
  overflow: hidden;
  border-radius: 12px;
  transition: all 0.3s ease;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
  }
  
  .stat-icon {
    position: absolute;
    right: 16px;
    top: 50%;
    transform: translateY(-50%);
    font-size: 48px;
    opacity: 0.15;
  }
}

.stat-card-income {
  background: linear-gradient(135deg, #f6ffed 0%, #ffffff 100%);
  border-left: 4px solid #52c41a;
}

.stat-card-total {
  background: linear-gradient(135deg, #e6f7ff 0%, #ffffff 100%);
  border-left: 4px solid #1890ff;
}

.stat-card-pending {
  background: linear-gradient(135deg, #fffbe6 0%, #ffffff 100%);
  border-left: 4px solid #faad14;
}

.stat-card-done {
  background: linear-gradient(135deg, #f9f0ff 0%, #ffffff 100%);
  border-left: 4px solid #722ed1;
}

.chart-card {
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.06);
  
  :deep(.ant-card-head) {
    border-bottom: 1px solid #f0f0f0;
    padding: 16px 24px;
    
    .ant-card-head-title {
      font-weight: 600;
      color: #333;
    }
  }
  
  :deep(.ant-card-body) {
    padding: 20px 24px;
  }
}

.empty-todo {
  text-align: center;
  padding: 40px 0;
  color: #999;
  font-size: 14px;
}

.total-label {
  font-size: 13px;
  color: #666;
  
  .total-amount {
    color: #52c41a;
    font-weight: 600;
    font-size: 15px;
  }
}

.income-amount {
  color: #f5222d;
  font-weight: 500;
}

:deep(.ant-list-item) {
  padding: 12px 0;
  border-bottom: 1px solid #f5f5f5;
  
  &:last-child {
    border-bottom: none;
  }
}

:deep(.ant-avatar) {
  font-size: 12px;
  font-weight: 600;
}

:deep(.ant-table-tbody > tr > td) {
  padding: 10px 16px;
}

:deep(.ant-tag) {
  border-radius: 4px;
}
</style>