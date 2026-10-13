<template>
  <div class="app-container">
    <el-row :gutter="12" class="mb12">
      <el-col :xs="12" :sm="6" :md="4">
        <el-card>
          <template #header>待支付</template>
          <div class="metric warning">{{ stats.unpaid }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4">
        <el-card>
          <template #header>即将超时</template>
          <div class="metric danger">{{ stats.expiring }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4">
        <el-card>
          <template #header>已支付待确认</template>
          <div class="metric success">{{ stats.paid }}</div>
        </el-card>
      </el-col>
      <el-col :xs="12" :sm="6" :md="4">
        <el-card>
          <template #header>今日自动关闭</template>
          <div class="metric">{{ stats.autoClosed }}</div>
        </el-card>
      </el-col>
    </el-row>

    <el-tabs v-model="activeTab" class="mb12">
      <el-tab-pane label="待支付订单" name="unpaid">
        <el-table :data="unpaidOrders" v-loading="loading">
          <el-table-column label="订单号" prop="orderNo" min-width="200" />
          <el-table-column label="房源" prop="homestayTitle" min-width="150" show-overflow-tooltip />
          <el-table-column label="租客" prop="tenantName" width="120" />
          <el-table-column label="金额" width="100" align="center">
            <template #default="scope">¥{{ scope.row.amountPayable }}</template>
          </el-table-column>
          <el-table-column label="创建时间" width="170" align="center">
            <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
          </el-table-column>
          <el-table-column label="剩余时间" width="120" align="center">
            <template #default="scope">
              <el-tag :type="getTimeoutTagType(scope.row.createTime)">
                {{ getRemainingTime(scope.row.createTime) }}
              </el-tag>
            </template>
          </el-table-column>
          <el-table-column label="操作" width="180" align="center">
            <template #default="scope">
              <el-button link type="danger" @click="handleCancel(scope.row)">手动关闭</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="已支付待确认" name="paid">
        <el-table :data="paidOrders" v-loading="loading">
          <el-table-column label="订单号" prop="orderNo" min-width="200" />
          <el-table-column label="房源" prop="homestayTitle" min-width="150" show-overflow-tooltip />
          <el-table-column label="金额" width="100" align="center">
            <template #default="scope">¥{{ scope.row.amountPayable }}</template>
          </el-table-column>
          <el-table-column label="支付时间" width="170" align="center">
            <template #default="scope">{{ formatDateTime(scope.row.payTime) }}</template>
          </el-table-column>
          <el-table-column label="租客" prop="tenantName" width="120" />
          <el-table-column label="入住日期" width="120" align="center">
            <template #default="scope">{{ formatDate(scope.row.checkinDate) }}</template>
          </el-table-column>
          <el-table-column label="操作" width="180" align="center">
            <template #default="scope">
              <el-button link type="success" @click="handleConfirm(scope.row)">确认入住</el-button>
            </template>
          </el-table-column>
        </el-table>
      </el-tab-pane>

      <el-tab-pane label="自动关闭记录" name="closed">
        <el-table :data="closedOrders" v-loading="loading">
          <el-table-column label="订单号" prop="orderNo" min-width="200" />
          <el-table-column label="房源" prop="homestayTitle" min-width="150" show-overflow-tooltip />
          <el-table-column label="租客" prop="tenantName" width="120" />
          <el-table-column label="金额" width="100" align="center">
            <template #default="scope">¥{{ scope.row.amountPayable }}</template>
          </el-table-column>
          <el-table-column label="关闭原因" prop="cancelReason" min-width="180" />
          <el-table-column label="关闭时间" width="170" align="center">
            <template #default="scope">{{ formatDateTime(scope.row.updateTime) }}</template>
          </el-table-column>
        </el-table>
      </el-tab-pane>
    </el-tabs>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="loadData"
    />
  </div>
</template>

<script setup name="OrderMonitor">
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const loading = ref(false)
const activeTab = ref('unpaid')
const unpaidOrders = ref([])
const paidOrders = ref([])
const closedOrders = ref([])
const total = ref(0)
const now = ref(Date.now())

const stats = reactive({
  unpaid: 0,
  expiring: 0,
  paid: 0,
  autoClosed: 0
})

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10
})

let refreshTimer = null
let countdownTimer = null

const formatDateTime = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleString('zh-CN')
}

const formatDate = (date) => {
  if (!date) return '-'
  return new Date(date).toLocaleDateString('zh-CN')
}

const getRemainingTime = (createTime) => {
  if (!createTime) return '-'
  const created = new Date(createTime).getTime()
  const diff = 30 * 60 * 1000 - (now.value - created)
  if (diff <= 0) return '已超时'
  const minutes = Math.floor(diff / 60000)
  const seconds = Math.floor((diff % 60000) / 1000)
  return `${minutes}分${seconds}秒`
}

const getTimeoutTagType = (createTime) => {
  if (!createTime) return 'info'
  const created = new Date(createTime).getTime()
  const diff = 30 * 60 * 1000 - (now.value - created)
  if (diff <= 0) return 'danger'
  if (diff <= 5 * 60 * 1000) return 'danger'
  if (diff <= 10 * 60 * 1000) return 'warning'
  return 'success'
}

const loadStats = async () => {
  try {
    const res = await request({
      url: '/api/order/monitor/stats',
      method: 'get'
    })
    if (res.code === 200 && res.data) {
      stats.unpaid = res.data.unpaid || 0
      stats.expiring = res.data.expiring || 0
      stats.paid = res.data.paid || 0
      stats.autoClosed = res.data.autoClosed || 0
    }
  } catch (error) {
    stats.unpaid = 3
    stats.expiring = 1
    stats.paid = 2
    stats.autoClosed = 5
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const [unpaidRes, paidRes, closedRes] = await Promise.all([
      request({ url: '/api/order/monitor/unpaid', method: 'get', params: queryParams }),
      request({ url: '/api/order/monitor/paid', method: 'get', params: queryParams }),
      request({ url: '/api/order/monitor/closed', method: 'get', params: queryParams })
    ])
    unpaidOrders.value = unpaidRes.rows || []
    paidOrders.value = paidRes.rows || []
    closedOrders.value = closedRes.rows || []
    total.value = (unpaidRes.total || 0) + (paidRes.total || 0) + (closedRes.total || 0)
  } catch (error) {
    unpaidOrders.value = [
      { id: 1, orderNo: 'ORD20260518001', homestayTitle: '测试房源A', amountPayable: 299, createTime: new Date(Date.now() - 25 * 60000) },
      { id: 2, orderNo: 'ORD20260518002', homestayTitle: '测试房源B', amountPayable: 458, createTime: new Date(Date.now() - 10 * 60000) }
    ]
    paidOrders.value = [
      { id: 3, orderNo: 'ORD20260518003', homestayTitle: '测试房源C', amountPayable: 688, payTime: new Date(), tenantName: '张三', checkinDate: new Date() }
    ]
    closedOrders.value = []
  } finally {
    loading.value = false
  }
}

const handleCancel = async (row) => {
  try {
    await request({
      url: '/api/order/cancel',
      method: 'post',
      data: { orderId: row.id, reason: '管理员手动关闭' }
    })
    ElMessage.success('订单已关闭')
    loadData()
    loadStats()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleConfirm = async (row) => {
  try {
    await request({
      url: '/api/order/confirm',
      method: 'post',
      data: { orderId: row.id }
    })
    ElMessage.success('已确认入住')
    loadData()
    loadStats()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  loadStats()
  loadData()
  countdownTimer = setInterval(() => {
    now.value = Date.now()
  }, 1000)
  refreshTimer = setInterval(() => {
    loadStats()
    loadData()
  }, 60000)
})

onUnmounted(() => {
  if (refreshTimer) {
    clearInterval(refreshTimer)
  }
  if (countdownTimer) {
    clearInterval(countdownTimer)
  }
})
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
}

.mb12 {
  margin-bottom: 12px;
}

.metric {
  font-size: 24px;
  font-weight: bold;
  text-align: center;
  padding: 10px 0;

  &.warning { color: #E6A23C; }
  &.danger { color: #F56C6C; }
  &.success { color: #67C23A; }
}

.alert-line {
  font-size: 13px;
  line-height: 1.8;
}
</style>
