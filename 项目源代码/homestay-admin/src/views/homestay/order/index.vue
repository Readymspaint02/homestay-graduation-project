<template>
  <div class="app-container">
    <el-alert type="warning" :closable="false" class="metric-alert">
      <template #title>订单监管</template>
      <div class="alert-line"><b>异常订单</b>（金额>2万或已退款）自动标红，点击「复核」查看详情 | 点击「上报」将订单数据上报至监管部门</div>
    </el-alert>

    <el-row :gutter="12" class="mb12">
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>总订单</template><div class="metric">{{ summary.total }}</div></el-card></el-col>
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>待处理</template><div class="metric warning">{{ summary.pending }}</div></el-card></el-col>
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>已确认</template><div class="metric success">{{ summary.confirmed }}</div></el-card></el-col>
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>已完成</template><div class="metric success">{{ summary.finished }}</div></el-card></el-col>
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>已取消</template><div class="metric danger">{{ summary.canceled }}</div></el-card></el-col>
      <el-col :xs="12" :sm="6" :md="4"><el-card><template #header>已拒绝</template><div class="metric danger">{{ summary.rejected }}</div></el-card></el-col>
    </el-row>

    <el-form :model="queryParams" :inline="true" class="mb12">
      <el-form-item label="角色视角">
        <el-select v-model="queryParams.roleType" style="width: 160px" clearable placeholder="全部">
          <el-option label="全部" value="" />
          <el-option label="租客" value="tenant" />
          <el-option label="房东" value="landlord" />
        </el-select>
      </el-form-item>
      <el-form-item label="订单状态">
        <el-select v-model="queryParams.orderStatus" style="width: 160px" clearable placeholder="全部">
          <el-option v-for="item in orderStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="支付状态">
        <el-select v-model="queryParams.payStatus" style="width: 160px" clearable placeholder="全部">
          <el-option v-for="item in payStatusOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
      </el-form-item>
      <el-form-item label="订单号">
        <el-input v-model="queryParams.orderNo" clearable placeholder="支持模糊搜索" style="width: 220px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="rows" v-loading="loading" :row-class-name="rowClassName">
      <el-table-column label="异常" width="60" align="center">
        <template #default="scope">
          <el-tag v-if="isAbnormal(scope.row)" type="danger" size="small">异常</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="上报状态" width="90" align="center">
        <template #default="scope">
          <el-tag v-if="reportStatusMap[scope.row.id]?.reported" type="success" size="small">已上报</el-tag>
          <el-tag v-else type="info" size="small">未上报</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="订单号" prop="orderNo" min-width="200" />
      <el-table-column label="金额" width="100" align="center">
        <template #default="scope">
          <span :class="{ 'danger-line': Number(scope.row.amountPayable) > 20000 }">{{ formatMoney(scope.row.amountPayable) }}</span>
        </template>
      </el-table-column>
      <el-table-column label="入住日期" width="110" align="center">
        <template #default="scope">{{ formatDate(scope.row.checkinDate) }}</template>
      </el-table-column>
      <el-table-column label="离店日期" width="110" align="center">
        <template #default="scope">{{ formatDate(scope.row.checkoutDate) }}</template>
      </el-table-column>
      <el-table-column label="支付状态" width="90" align="center">
        <template #default="scope">
          <el-tag :type="payTagType(scope.row.payStatus)" size="small">{{ payText(scope.row.payStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="订单状态" width="100" align="center">
        <template #default="scope">
          <el-tag :type="orderTagType(scope.row.orderStatus)" size="small">{{ orderText(scope.row.orderStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" width="150" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center" fixed="right">
        <template #default="scope">
          <template v-if="scope.row.orderStatus === '1'">
            <el-button link type="success" @click="handleConfirm(scope.row)">确认</el-button>
            <el-button link type="danger" @click="handleReject(scope.row)">拒绝</el-button>
          </template>
          <el-button 
            v-if="!reportStatusMap[scope.row.id]?.reported" 
            link 
            type="warning" 
            @click="handleReport(scope.row)"
          >上报</el-button>
          <span v-else class="reported-text">已上报</span>
          <el-button v-if="isAbnormal(scope.row)" link type="danger" @click="handleReview(scope.row)">复核</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="loadData"
    />

    <el-dialog v-model="rejectDialog.visible" title="拒绝订单" width="420px">
      <el-form>
        <el-form-item label="订单号">
          <el-tag>{{ rejectDialog.orderNo }}</el-tag>
        </el-form-item>
        <el-form-item label="拒绝原因" prop="reason">
          <el-input
            v-model="rejectDialog.reason"
            type="textarea"
            :rows="4"
            placeholder="请输入拒绝原因（必填）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rejectDialog.visible = false">取消</el-button>
        <el-button type="danger" @click="submitReject">确认拒绝</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="reviewDialog.visible" title="异常订单复核" width="600px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="订单号">{{ reviewDialog.orderNo }}</el-descriptions-item>
        <el-descriptions-item label="订单状态">
          <el-tag :type="orderTagType(reviewDialog.orderStatus)">{{ orderText(reviewDialog.orderStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="订单金额">
          <span class="danger-line">{{ formatMoney(reviewDialog.amount) }} 元</span>
        </el-descriptions-item>
        <el-descriptions-item label="支付状态">
          <el-tag :type="payTagType(reviewDialog.payStatus)">{{ payText(reviewDialog.payStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="入住日期">{{ formatDate(reviewDialog.checkinDate) }}</el-descriptions-item>
        <el-descriptions-item label="离店日期">{{ formatDate(reviewDialog.checkoutDate) }}</el-descriptions-item>
        <el-descriptions-item label="租客ID">{{ reviewDialog.tenantUserId }}</el-descriptions-item>
        <el-descriptions-item label="房东ID">{{ reviewDialog.landlordUserId }}</el-descriptions-item>
        <el-descriptions-item label="创建时间" :span="2">{{ formatDateTime(reviewDialog.createTime) }}</el-descriptions-item>
      </el-descriptions>
      <el-alert type="warning" :closable="false" class="mt12">
        <template #title>异常原因</template>
        <div v-if="Number(reviewDialog.amount) > 20000">订单金额超过20000元，属于大额订单</div>
        <div v-if="reviewDialog.payStatus === '2'">订单已退款，需关注退款原因</div>
      </el-alert>
      <el-form class="mt12">
        <el-form-item label="复核意见">
          <el-input
            v-model="reviewDialog.opinion"
            type="textarea"
            :rows="3"
            placeholder="请填写复核意见（选填）"
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="reviewDialog.visible = false">取消</el-button>
        <el-button type="success" @click="submitReview(true)">确认正常</el-button>
        <el-button type="danger" @click="submitReview(false)">标记异常</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, getCurrentInstance, onMounted, onUnmounted, reactive, ref } from 'vue'
import { ElMessage, ElNotification } from 'element-plus'
import { parseTime } from '@/utils/ruoyi'
import { confirmOrder, listOrder, rejectOrder } from '@/api/homestay/order'
import { reportSingleOrder, getOrderReportStatus } from '@/api/homestay/supervision'
import { getToken } from '@/utils/auth'

const { proxy } = getCurrentInstance()

const loading = ref(false)
const rows = ref([])
const total = ref(0)
const reportStatusMap = ref({})
const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  roleType: '',
  orderStatus: '',
  payStatus: '',
  orderNo: ''
})

const orderStatusOptions = [
  { label: '待支付', value: '0' },
  { label: '待房东处理', value: '1' },
  { label: '已确认', value: '2' },
  { label: '已完成', value: '3' },
  { label: '已取消', value: '4' },
  { label: '已拒绝', value: '5' }
]

const payStatusOptions = [
  { label: '未支付', value: '0' },
  { label: '已支付', value: '1' },
  { label: '已退款', value: '2' }
]

const rejectDialog = reactive({
  visible: false,
  orderId: null,
  orderNo: '',
  reason: ''
})

const reviewDialog = reactive({
  visible: false,
  orderId: null,
  orderNo: '',
  orderStatus: '',
  payStatus: '',
  amount: 0,
  checkinDate: '',
  checkoutDate: '',
  tenantUserId: null,
  landlordUserId: null,
  createTime: '',
  opinion: ''
})

let sseSource = null
let audioContext = null

const playNotificationSound = () => {
  try {
    if (!audioContext) {
      audioContext = new (window.AudioContext || window.webkitAudioContext)()
    }
    const oscillator = audioContext.createOscillator()
    const gainNode = audioContext.createGain()
    oscillator.connect(gainNode)
    gainNode.connect(audioContext.destination)
    oscillator.frequency.value = 800
    oscillator.type = 'sine'
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime)
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5)
    oscillator.start(audioContext.currentTime)
    oscillator.stop(audioContext.currentTime + 0.5)
  } catch (e) {
    console.log('Audio not supported')
  }
}

const summary = computed(() => {
  const result = { total: rows.value.length, pending: 0, confirmed: 0, finished: 0, canceled: 0, rejected: 0 }
  rows.value.forEach((item) => {
    if (item.orderStatus === '1') result.pending += 1
    if (item.orderStatus === '2') result.confirmed += 1
    if (item.orderStatus === '3') result.finished += 1
    if (item.orderStatus === '4') result.canceled += 1
    if (item.orderStatus === '5') result.rejected += 1
  })
  return result
})

function isAbnormal(row) {
  const amount = Number(row.amountPayable || 0)
  if (amount > 20000) return true
  if (row.payStatus === '2') return true
  return false
}

function rowClassName({ row }) {
  return isAbnormal(row) ? 'abnormal-row' : ''
}

function handleReview(row) {
  reviewDialog.orderId = row.id
  reviewDialog.orderNo = row.orderNo || ''
  reviewDialog.orderStatus = row.orderStatus
  reviewDialog.payStatus = row.payStatus
  reviewDialog.amount = row.amountPayable
  reviewDialog.checkinDate = row.checkinDate
  reviewDialog.checkoutDate = row.checkoutDate
  reviewDialog.tenantUserId = row.tenantUserId
  reviewDialog.landlordUserId = row.landlordUserId
  reviewDialog.createTime = row.createTime
  reviewDialog.opinion = ''
  reviewDialog.visible = true
}

function submitReview(isNormal) {
  reviewDialog.visible = false
  if (isNormal) {
    proxy.$modal.msgSuccess('复核完成：订单正常')
  } else {
    proxy.$modal.msgWarning('已标记为异常订单，需进一步处理')
  }
}

async function handleReport(row) {
  try {
    await reportSingleOrder(row.id)
    proxy.$modal.msgSuccess('上报成功！订单数据已发送至监管接口')
    reportStatusMap.value[row.id] = { reported: true }
  } catch (e) {
    proxy.$modal.msgError('上报失败')
  }
}

function formatDate(v) {
  if (!v) return '-'
  return parseTime(v, '{y}-{m}-{d}')
}

function formatDateTime(v) {
  if (!v) return '-'
  return parseTime(v, '{y}-{m}-{d} {h}:{i}')
}

function formatMoney(v) {
  const n = Number(v || 0)
  if (!Number.isFinite(n)) return '0.00'
  return n.toFixed(2)
}

function payText(v) {
  if (v === '1') return '已支付'
  if (v === '2') return '已退款'
  return '未支付'
}

function payTagType(v) {
  if (v === '1') return 'success'
  if (v === '2') return 'warning'
  return 'info'
}

function orderText(v) {
  if (v === '1') return '待房东处理'
  if (v === '2') return '已确认'
  if (v === '3') return '已完成'
  if (v === '4') return '已取消'
  if (v === '5') return '已拒绝'
  return '待支付'
}

function orderTagType(v) {
  if (v === '1') return 'warning'
  if (v === '2') return 'success'
  if (v === '3') return 'success'
  if (v === '4') return 'info'
  if (v === '5') return 'danger'
  return 'info'
}

function buildQueryParams() {
  const params = {
    pageNum: queryParams.pageNum,
    pageSize: queryParams.pageSize
  }
  if (queryParams.roleType) params.roleType = queryParams.roleType
  if (queryParams.orderStatus) params.orderStatus = queryParams.orderStatus
  if (queryParams.payStatus) params.payStatus = queryParams.payStatus
  if (queryParams.orderNo) params.orderNo = queryParams.orderNo.trim()
  return params
}

async function loadData() {
  loading.value = true
  try {
    const res = await listOrder(buildQueryParams())
    rows.value = res.rows || []
    total.value = Number(res.total || 0)
    await loadReportStatus()
  } finally {
    loading.value = false
  }
}

async function loadReportStatus() {
  const ids = rows.value.map(r => r.id).filter(Boolean)
  if (ids.length === 0) return
  for (const id of ids) {
    try {
      const res = await getOrderReportStatus(id)
      if (res.data?.reported) {
        reportStatusMap.value[id] = res.data
      }
    } catch (e) {}
  }
}

function handleQuery() {
  queryParams.pageNum = 1
  loadData()
}

function handleReset() {
  queryParams.pageNum = 1
  queryParams.roleType = ''
  queryParams.orderStatus = ''
  queryParams.payStatus = ''
  queryParams.orderNo = ''
  loadData()
}

function handleConfirm(row) {
  proxy.$modal.confirm('确认该订单？').then(() => {
    return confirmOrder({ orderId: row.id })
  }).then(() => {
    proxy.$modal.msgSuccess('订单已确认')
    loadData()
  }).catch(() => {})
}

function handleReject(row) {
  rejectDialog.orderId = row.id
  rejectDialog.orderNo = row.orderNo || ''
  rejectDialog.reason = ''
  rejectDialog.visible = true
}

function submitReject() {
  if (!rejectDialog.reason.trim()) {
    ElMessage.warning('请填写拒绝原因')
    return
  }
  rejectOrder({ orderId: rejectDialog.orderId, reason: rejectDialog.reason.trim() }).then(() => {
    ElMessage.success('订单已拒绝')
    rejectDialog.visible = false
    loadData()
  }).catch(() => {
    ElMessage.error('拒绝失败')
  })
}

function subscribeSse() {
  const token = getToken()
  if (!token) return
  const baseUrl = import.meta.env.VITE_APP_BASE_API || ''
  const url = `${baseUrl}/api/order/message/subscribe?token=${token}`
  sseSource = new EventSource(url)
  sseSource.onmessage = (event) => {
    try {
      const data = JSON.parse(event.data)
      if (data.type === 'new_order' || data.orderStatus === '0' || data.orderStatus === '1') {
        playNotificationSound()
        ElNotification({
          title: '新订单提醒',
          message: `收到新订单 #${data.orderNo || ''}`,
          type: 'success',
          duration: 0
        })
        loadData()
      }
    } catch (e) {}
  }
}

onMounted(() => {
  loadData()
  subscribeSse()
})

onUnmounted(() => {
  if (sseSource) {
    sseSource.close()
  }
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

.mt12 {
  margin-top: 12px;
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

.danger-line {
  color: var(--el-color-danger);
  font-weight: 600;
}

.reported-text {
  color: #67c23a;
  font-size: 12px;
}

:deep(.el-table .abnormal-row > td) {
  background: #fff1f0 !important;
}

:deep(.el-table .abnormal-row:hover > td) {
  background: #ffccc7 !important;
}
</style>
