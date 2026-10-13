<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="metric-alert">
      <template #title>指标口径说明</template>
      <div class="alert-line">房源总数/本周新增：供给规模与增长能力。</div>
      <div class="alert-line">未支付/已支付/取消拒绝：订单漏斗与履约风险。</div>
      <div class="alert-line">热门房源/城市分布：运营热点与资源投放方向。</div>
    </el-alert>

    <el-row :gutter="12" class="mb12">
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>房源总数</template><div class="metric">{{ stats.spzs || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>本周新增</template><div class="metric">{{ stats.qrxz || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>待支付</template><div class="metric">{{ stats.wfdd || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>已支付</template><div class="metric">{{ stats.yfdd || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>取消拒绝</template><div class="metric">{{ stats.qxdd || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>支付转化率</template><div class="metric">{{ paidRateText }}</div></el-card></el-col>
    </el-row>

    <el-row :gutter="12">
      <el-col :xs="24" :lg="12">
        <el-card shadow="never" class="mb12">
          <template #header>热门房源TOP</template>
          <el-table :data="popularThings" size="small" v-loading="loading">
            <el-table-column label="名称" prop="title" min-width="220" show-overflow-tooltip />
            <el-table-column label="热度" prop="count" width="100" align="center" />
          </el-table>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="12">
        <el-card shadow="never" class="mb12">
          <template #header>城市热度分布</template>
          <el-table :data="popularClassification" size="small" v-loading="loading">
            <el-table-column label="城市" prop="title" min-width="180" />
            <el-table-column label="房源数" prop="count" width="100" align="center" />
          </el-table>
        </el-card>
      </el-col>
    </el-row>

    <el-card shadow="never">
      <template #header>系统信息</template>
      <el-descriptions :column="3" border v-loading="loading">
        <el-descriptions-item label="系统名">{{ sysInfo.sysName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="版本">{{ sysInfo.versionName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="时区">{{ sysInfo.sysZone || '-' }}</el-descriptions-item>
        <el-descriptions-item label="操作系统">{{ sysInfo.osName || '-' }}</el-descriptions-item>
        <el-descriptions-item label="CPU核数">{{ sysInfo.cpuCount || '-' }}</el-descriptions-item>
        <el-descriptions-item label="CPU负载">{{ formatPercent(sysInfo.cpuLoad) }}</el-descriptions-item>
        <el-descriptions-item label="内存">{{ sysInfo.memory || '-' }} GB</el-descriptions-item>
        <el-descriptions-item label="已用内存">{{ sysInfo.usedMemory || '-' }} GB</el-descriptions-item>
        <el-descriptions-item label="内存占用">{{ formatPercent(sysInfo.percentMemory) }}</el-descriptions-item>
      </el-descriptions>
    </el-card>
  </div>
</template>

<script setup>
import { computed, onMounted, ref } from 'vue'
import { getOverviewCount, getOverviewSysInfo } from '@/api/homestay/overview'

const loading = ref(false)
const stats = ref({})
const sysInfo = ref({})

const popularThings = computed(() => stats.value.popularThings || [])
const popularClassification = computed(() => stats.value.popularClassification || [])
const paidRateText = computed(() => {
  const unpaid = Number(stats.value.wfdd || 0)
  const paid = Number(stats.value.yfdd || 0)
  const total = unpaid + paid
  if (!total) {
    return '0.00%'
  }
  return `${((paid / total) * 100).toFixed(2)}%`
})

function formatPercent(v) {
  const n = Number(v || 0)
  return `${n.toFixed(2)}%`
}

async function loadData() {
  loading.value = true
  try {
    const [countRes, sysInfoRes] = await Promise.all([getOverviewCount(), getOverviewSysInfo()])
    stats.value = countRes.data || {}
    sysInfo.value = sysInfoRes.data || {}
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})
</script>

<style scoped>
.metric-alert {
  margin-bottom: 12px;
}

.alert-line {
  line-height: 1.6;
}

.mb12 {
  margin-bottom: 12px;
}

.metric {
  font-size: 24px;
  font-weight: 700;
  color: var(--el-color-primary);
}
</style>
