<template>
  <div class="app-container">
    <el-row :gutter="20" class="mb20">
      <el-col :xs="12" :sm="6">
        <el-card shadow="hover">
          <template #header>
            <span>今日新增订单</span>
          </template>
          <div class="metric-value success">{{ stats.todayOrders }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="hover">
          <template #header>
            <span>今日新增用户</span>
          </template>
          <div class="metric-value">{{ stats.todayUsers }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="hover">
          <template #header>
            <span>今日新增房源</span>
          </template>
          <div class="metric-value">{{ stats.todayHomestays }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6">
        <el-card shadow="hover">
          <template #header>
            <span>监管成功率</span>
          </template>
          <div class="metric-value success">{{ stats.successRate }}%</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="12">
        <el-card>
          <template #header>
            <span>近 7 日订单趋势</span>
          </template>
          <div ref="orderChartRef" style="height: 300px;"></div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card>
          <template #header>
            <span>房源类型数量排行</span>
          </template>
          <div ref="typeChartRef" style="height: 300px;"></div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :xs="24" :lg="8">
        <el-card>
          <template #header>
            <span>热门房源 TOP5</span>
          </template>
          <el-table :data="popularHomestays" size="small" style="width: 100%">
            <el-table-column type="index" width="50" align="center" />
            <el-table-column prop="title" label="名称" min-width="150" show-overflow-tooltip />
            <el-table-column prop="count" label="热度" width="80" align="center" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card>
          <template #header>
            <span>城市分布</span>
          </template>
          <el-table :data="cityDistribution" size="small" style="width: 100%">
            <el-table-column type="index" width="50" align="center" />
            <el-table-column prop="city" label="城市" min-width="120" />
            <el-table-column prop="count" label="房源数" width="80" align="center" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card>
          <template #header>
            <span>系统信息</span>
          </template>
          <el-descriptions :column="1" border size="small">
            <el-descriptions-item label="系统名">{{ sysInfo.sysName || '-' }}</el-descriptions-item>
            <el-descriptions-item label="版本">{{ sysInfo.version || '-' }}</el-descriptions-item>
            <el-descriptions-item label="运行时间">{{ sysInfo.uptime || '-' }}</el-descriptions-item>
          </el-descriptions>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="AdminDashboard">
import { ref, reactive, onMounted } from 'vue'
import * as echarts from 'echarts'
import request from '@/utils/request'

const orderChartRef = ref(null)
const typeChartRef = ref(null)
let orderChartInstance = null
let typeChartInstance = null

const stats = reactive({
  todayOrders: 0,
  todayUsers: 0,
  todayHomestays: 0,
  successRate: 0
})

const popularHomestays = ref([])
const cityDistribution = ref([])
const sysInfo = reactive({
  sysName: '',
  version: '',
  uptime: ''
})

const loadStats = async () => {
  try {
    const res = await request({
      url: '/api/admin/dashboard/stats',
      method: 'get'
    })
    if (res.code === 200 && res.data) {
      stats.todayOrders = res.data.todayOrders || 0
      stats.todayUsers = res.data.todayUsers || 0
      stats.todayHomestays = res.data.todayHomestays || 0
      stats.successRate = res.data.successRate || 0
    }
  } catch (error) {
    stats.todayOrders = 5
    stats.todayUsers = 3
    stats.todayHomestays = 2
    stats.successRate = 77
  }
}

const loadPopularHomestays = async () => {
  try {
    const res = await request({
      url: '/api/overview/count',
      method: 'get'
    })
    if (res.code === 200 && res.data) {
      popularHomestays.value = (res.data.popularThings || []).slice(0, 5)
      cityDistribution.value = (res.data.popularClassification || []).slice(0, 5).map(item => ({
        city: item.title,
        count: item.count
      }))
    }
  } catch (error) {
    popularHomestays.value = [
      { title: 'Demo River View B', count: 12 },
      { title: 'Demo City Loft A', count: 10 },
      { title: '广州精选民宿 01', count: 8 },
      { title: '深圳精选民宿 02', count: 6 },
      { title: '上海精选民宿 03', count: 5 }
    ]
    cityDistribution.value = [
      { city: '广州', count: 10 },
      { city: '深圳', count: 8 },
      { city: '上海', count: 6 },
      { city: '北京', count: 5 },
      { city: '杭州', count: 3 }
    ]
  }
}

const loadSysInfo = async () => {
  try {
    const res = await request({
      url: '/api/overview/sysInfo',
      method: 'get'
    })
    if (res.code === 200 && res.data) {
      sysInfo.sysName = res.data.sysName || '民宿短租系统'
      sysInfo.version = res.data.versionName || '1.0.0'
      sysInfo.uptime = res.data.uptime || '计算中...'
    }
  } catch (error) {
    sysInfo.sysName = '民宿短租系统'
    sysInfo.version = '1.0.0'
    sysInfo.uptime = '计算中...'
  }
}

const initOrderChart = async () => {
  if (!orderChartRef.value) return
  orderChartInstance = echarts.init(orderChartRef.value)

  let chartData = []
  let xAxisData = []
  try {
    const res = await request({
      url: '/api/overview/count',
      method: 'get'
    })
    if (res.code === 200 && res.data && res.data.visitList) {
      chartData = res.data.visitList.map(item => item.pv || 0)
      xAxisData = res.data.visitList.map(item => {
        const day = item.day || ''
        return day.substring(5) || day
      })
    }
  } catch (error) {
    const today = new Date()
    for (let i = 6; i >= 0; i--) {
      const d = new Date(today)
      d.setDate(d.getDate() - i)
      xAxisData.push(`${d.getMonth() + 1}/${d.getDate()}`)
      chartData.push(0)
    }
  }

  const option = {
    tooltip: { trigger: 'axis' },
    grid: { left: '3%', right: '4%', bottom: '3%', containLabel: true },
    xAxis: {
      type: 'category',
      boundaryGap: false,
      data: xAxisData
    },
    yAxis: { type: 'value' },
    series: [{
      name: '订单数',
      type: 'line',
      smooth: true,
      data: chartData,
      itemStyle: { color: '#409EFF' },
      areaStyle: { color: 'rgba(64, 158, 255, 0.2)' }
    }]
  }
  orderChartInstance.setOption(option)
  window.addEventListener('resize', () => orderChartInstance?.resize())
}

const initTypeChart = async () => {
  if (!typeChartRef.value) return
  typeChartInstance = echarts.init(typeChartRef.value)

  let chartData = []
  try {
    const res = await request({
      url: '/api/overview/count',
      method: 'get'
    })
    if (res.code === 200 && res.data && res.data.popularClassification) {
      chartData = res.data.popularClassification.slice(0, 5).map(item => ({
        value: item.count || 0,
        name: item.title || '未知'
      }))
    }
  } catch (error) {
    chartData = [
      { value: 0, name: '暂无数据' }
    ]
  }

  if (chartData.length === 0) {
    chartData = [{ value: 0, name: '暂无数据' }]
  }

  const option = {
    tooltip: { trigger: 'item' },
    legend: { top: '5%', left: 'center' },
    series: [{
      name: '房源类型',
      type: 'pie',
      radius: ['40%', '70%'],
      avoidLabelOverlap: false,
      itemStyle: {
        borderRadius: 10,
        borderColor: '#fff',
        borderWidth: 2
      },
      label: { show: false, position: 'center' },
      emphasis: {
        label: { show: true, fontSize: 20, fontWeight: 'bold' }
      },
      data: chartData
    }]
  }
  typeChartInstance.setOption(option)
  window.addEventListener('resize', () => typeChartInstance?.resize())
}

onMounted(() => {
  loadStats()
  loadPopularHomestays()
  loadSysInfo()
  initOrderChart()
  initTypeChart()
})
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
}

.mb20 {
  margin-bottom: 20px;
}

.metric-value {
  font-size: 28px;
  font-weight: bold;
  text-align: center;
  padding: 10px 0;
  
  &.success {
    color: #67C23A;
  }
}
</style>
