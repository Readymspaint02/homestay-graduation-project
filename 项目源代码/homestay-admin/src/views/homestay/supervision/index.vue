<template>
  <div class="app-container">
    <el-alert type="success" :closable="false" class="metric-alert">
      <template #title>监管上报 - 两步完成数据上报</template>
      <div class="alert-line"><b>① 生成数据</b> → 从数据库提取房源/订单数据 &nbsp;&nbsp; <b>② 执行上报</b> → 发送至文旅/公安监管接口</div>
    </el-alert>

    <el-alert v-if="focus.active" type="success" :closable="false" class="mb12 locate-alert">
      <template #title>已接收订单页定位参数</template>
      <div class="alert-line">
        来源：{{ focus.from || '订单管理' }}；订单号：{{ focus.orderNo || '-' }}；订单ID：{{ focus.orderId || '-' }}；监管类型：{{ typeText(focus.reportType || '2') }}
      </div>
      <div class="alert-line" v-if="focus.matched">已自动定位并高亮目标记录。</div>
      <div class="alert-line" v-else>当前页未命中目标记录，可点击“自动生成/处理待上报”后刷新。</div>
    </el-alert>

    <el-form :model="queryParams" :inline="true" class="mb12">
      <el-form-item label="上报类型">
        <el-select v-model="queryParams.reportType" clearable style="width: 150px" placeholder="全部">
          <el-option v-for="item in reportTypeOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="上报状态">
        <el-select v-model="queryParams.reportStatus" clearable style="width: 150px" placeholder="全部">
          <el-option v-for="item in reportStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="业务ID">
        <el-input v-model="queryParams.bizIdText" clearable placeholder="如订单ID" style="width: 160px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="上报号">
        <el-input v-model="queryParams.reportNo" clearable placeholder="支持模糊搜索" style="width: 220px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="handleReset">重置</el-button>
        <el-button v-if="focus.active" type="warning" @click="clearLocate">清除定位</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="12" class="mb12">
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>总记录</template><div class="metric">{{ stats.total || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>待处理</template><div class="metric warning">{{ stats.pending || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>已成功</template><div class="metric success">{{ stats.success || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>已失败</template><div class="metric danger">{{ stats.failed || 0 }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>成功率</template><div class="metric success">{{ successRate }}</div></el-card></el-col>
      <el-col :xs="12" :sm="8" :md="4"><el-card><template #header>失败率</template><div class="metric danger">{{ failedRate }}</div></el-card></el-col>
    </el-row>

    <el-row class="mb12 action-row">
      <el-button type="primary" size="large" @click="handleGenerate" :loading="actionLoading">
        <el-icon><DocumentAdd /></el-icon> 第一步：生成待上报数据
      </el-button>
      <el-button type="success" size="large" @click="handleProcess" :loading="actionLoading">
        <el-icon><Upload /></el-icon> 第二步：执行上报
      </el-button>
      <el-button size="large" @click="loadAll">
        <el-icon><Refresh /></el-icon> 刷新
      </el-button>
    </el-row>

<el-table ref="tableRef" :data="rows" v-loading="loading" :row-class-name="rowClassName">
      <el-table-column label="上报号" prop="reportNo" min-width="200" />
      <el-table-column label="类型" width="100" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.reportType === '1' ? 'primary' : scope.row.reportType === '2' ? 'success' : 'info'" size="small">
            {{ typeText(scope.row.reportType) }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="状态" width="100" align="center">
        <template #default="scope">
          <el-tag :type="statusTagType(scope.row.reportStatus)">{{ statusText(scope.row.reportStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="业务ID" prop="bizId" width="100" align="center" />
      <el-table-column label="创建时间" width="160" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="上报时间" width="160" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.lastReportTime) }}</template>
      </el-table-column>
      <el-table-column label="上报结果" width="120" align="center">
        <template #default="scope">
          <span v-if="scope.row.reportStatus === '1'" class="success-text">上报成功</span>
          <span v-else-if="scope.row.reportStatus === '2'" class="danger-text">上报失败</span>
          <span v-else class="warning-text">待上报</span>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="loadRows"
    />
  </div>
</template>

<script setup>
import { computed, getCurrentInstance, nextTick, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { DocumentAdd, Upload, Refresh } from '@element-plus/icons-vue'
import { parseTime } from '@/utils/ruoyi'
import { generateSupervision, getSupervisionStats, listSupervision, processSupervision } from '@/api/homestay/supervision'

const { proxy } = getCurrentInstance()
const route = useRoute()
const router = useRouter()

const tableRef = ref()
const loading = ref(false)
const actionLoading = ref(false)
const rows = ref([])
const total = ref(0)
const stats = ref({})
const activeReportId = ref(undefined)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  reportType: '',
  reportStatus: '',
  bizIdText: '',
  reportNo: ''
})

const focus = reactive({
  active: false,
  from: '',
  orderNo: '',
  orderId: undefined,
  bizId: undefined,
  reportType: '',
  matched: false
})

const reportTypeOptions = [
  { label: '房源上报', value: '1' },
  { label: '入住上报', value: '2' },
  { label: '经营统计', value: '3' }
]

const reportStatusOptions = [
  { label: '待处理', value: '0' },
  { label: '成功', value: '1' },
  { label: '失败', value: '2' }
]

const successRate = computed(() => {
  const t = Number(stats.value.total || 0)
  const s = Number(stats.value.success || 0)
  return t ? `${((s / t) * 100).toFixed(2)}%` : '0.00%'
})

const failedRate = computed(() => {
  const t = Number(stats.value.total || 0)
  const f = Number(stats.value.failed || 0)
  return t ? `${((f / t) * 100).toFixed(2)}%` : '0.00%'
})

function toPositiveInt(value) {
  const n = Number(value)
  if (!Number.isFinite(n) || n <= 0) return undefined
  return Math.trunc(n)
}

function hasLocateQuery(query) {
  return String(query?.autoLocate || '') === '1' || query?.bizId || query?.orderId
}

function applyRouteLocateQuery() {
  if (!hasLocateQuery(route.query)) {
    return
  }
  const bizId = toPositiveInt(route.query.bizId)
  const orderId = toPositiveInt(route.query.orderId)

  focus.active = true
  focus.from = String(route.query.from || 'order')
  focus.orderNo = String(route.query.orderNo || '')
  focus.orderId = orderId
  focus.bizId = bizId || orderId
  focus.reportType = String(route.query.reportType || '2')
  focus.matched = false

  queryParams.pageNum = 1
  if (focus.reportType) queryParams.reportType = focus.reportType
  if (focus.bizId) queryParams.bizIdText = String(focus.bizId)
}

function clearLocate() {
  focus.active = false
  focus.from = ''
  focus.orderNo = ''
  focus.orderId = undefined
  focus.bizId = undefined
  focus.reportType = ''
  focus.matched = false
  activeReportId.value = undefined
  router.replace({ path: '/homestay/supervision', query: {} }).catch(() => {})
}

function formatDateTime(v) {
  if (!v) return '-'
  return parseTime(v, '{y}-{m}-{d} {h}:{i}')
}

function typeText(v) {
  if (v === '1') return '房源上报'
  if (v === '2') return '入住上报'
  if (v === '3') return '经营统计'
  return '未知'
}

function statusText(v) {
  if (v === '1') return '成功'
  if (v === '2') return '失败'
  return '待处理'
}

function statusTagType(v) {
  if (v === '1') return 'success'
  if (v === '2') return 'danger'
  return 'warning'
}

function shortText(v) {
  const raw = String(v || '')
  if (!raw) return '-'
  return raw.length > 100 ? `${raw.slice(0, 100)}...` : raw
}

function buildQueryParams() {
  const params = {
    pageNum: queryParams.pageNum,
    pageSize: queryParams.pageSize
  }
  if (queryParams.reportType) params.reportType = queryParams.reportType
  if (queryParams.reportStatus) params.reportStatus = queryParams.reportStatus
  const bizId = toPositiveInt(queryParams.bizIdText)
  if (bizId) params.bizId = bizId
  if (queryParams.reportNo) params.reportNo = queryParams.reportNo.trim()
  return params
}

function rowClassName({ row }) {
  if (!focus.active) return ''
  if (activeReportId.value && Number(row.id) === Number(activeReportId.value)) return 'focus-row'
  if (focus.bizId && Number(row.bizId) === Number(focus.bizId)) return 'focus-row'
  return ''
}

function locateFocusRow() {
  if (!focus.active) return
  focus.matched = false
  activeReportId.value = undefined

  const bizId = focus.bizId || toPositiveInt(queryParams.bizIdText)
  let target = null

  if (bizId) {
    target = rows.value.find((item) => Number(item.bizId) === Number(bizId))
  }
  if (!target && focus.orderNo) {
    target = rows.value.find((item) => String(item.requestJson || '').includes(focus.orderNo))
  }

  if (target) {
    focus.matched = true
    activeReportId.value = target.id
    nextTick(() => {
      const root = tableRef.value?.$el
      const rowEl = root?.querySelector('.el-table__body-wrapper tbody tr.focus-row')
      if (rowEl && typeof rowEl.scrollIntoView === 'function') {
        rowEl.scrollIntoView({ block: 'center', behavior: 'smooth' })
      }
    })
  }
}

function loadStats() {
  return getSupervisionStats().then((res) => {
    stats.value = res.data || {}
  }).catch((err) => {
    console.error('Failed to load supervision stats:', err)
    stats.value = {}
  })
}

function loadRows() {
  loading.value = true
  return listSupervision(buildQueryParams()).then((res) => {
    rows.value = res.rows || []
    total.value = Number(res.total || 0)
    locateFocusRow()
  }).catch((err) => {
    console.error('Failed to load supervision list:', err)
    rows.value = []
    total.value = 0
  }).finally(() => {
    loading.value = false
  })
}

function loadAll() {
  Promise.all([loadStats(), loadRows()]).catch((err) => {
    console.error('Failed to load supervision data:', err)
  })
}

function handleQuery() {
  queryParams.pageNum = 1
  loadRows()
}

function handleReset() {
  queryParams.pageNum = 1
  queryParams.reportType = ''
  queryParams.reportStatus = ''
  queryParams.bizIdText = ''
  queryParams.reportNo = ''
  loadRows()
}

function handleGenerate() {
  actionLoading.value = true
  generateSupervision(50).then((res) => {
    const count = res.data || 0
    if (count > 0) {
      proxy.$modal.msgSuccess(`✅ 已生成 ${count} 条待上报数据，请继续点击「执行上报」`)
    } else {
      proxy.$modal.msgWarning('暂无新数据需要上报')
    }
    loadAll()
  }).finally(() => {
    actionLoading.value = false
  })
}

function handleProcess() {
  actionLoading.value = true
  processSupervision(50).then((res) => {
    const count = res.data || 0
    if (count > 0) {
      proxy.$modal.msgSuccess(`✅ 上报成功！已将 ${count} 条数据发送至文旅/公安监管接口`)
    } else {
      proxy.$modal.msgWarning('请先点击「生成待上报数据」')
    }
    loadAll()
  }).finally(() => {
    actionLoading.value = false
  })
}

watch(
  () => route.fullPath,
  () => {
    if (hasLocateQuery(route.query)) {
      applyRouteLocateQuery()
      loadRows()
    }
  }
)

onMounted(() => {
  applyRouteLocateQuery()
  loadAll()
})
</script>

<style scoped>
.metric-alert {
  margin-bottom: 12px;
}

.alert-line {
  line-height: 1.8;
  font-size: 14px;
}

.mb12 {
  margin-bottom: 12px;
}

.action-row {
  display: flex;
  gap: 12px;
  flex-wrap: wrap;
}

.metric {
  font-size: 22px;
  font-weight: 700;
  color: var(--el-color-primary);
}

.metric.success {
  color: var(--el-color-success);
}

.metric.warning {
  color: var(--el-color-warning);
}

.metric.danger {
  color: var(--el-color-danger);
}

.locate-alert {
  border-left: 3px solid var(--el-color-success);
}

.success-text {
  color: var(--el-color-success);
  font-weight: 500;
}

.danger-text {
  color: var(--el-color-danger);
  font-weight: 500;
}

.warning-text {
  color: var(--el-color-warning);
  font-weight: 500;
}

:deep(.el-table .focus-row > td) {
  background: #fff7e6 !important;
}

:deep(.el-table .focus-row:hover > td) {
  background: #ffe7ba !important;
}
</style>
