<template>
  <div class="content-list">
    <div class="list-title">我的订单</div>

    <div class="summary-grid">
      <div class="summary-card">
        <div class="summary-label">订单总数</div>
        <div class="summary-value">{{ summary.all }}</div>
      </div>
      <div class="summary-card">
        <div class="summary-label">待支付</div>
        <div class="summary-value warning">{{ summary.waitPay }}</div>
      </div>
      <div class="summary-card">
        <div class="summary-label">待房东处理</div>
        <div class="summary-value processing">{{ summary.waitLandlord }}</div>
      </div>
      <div class="summary-card">
        <div class="summary-label">已确认/入住中</div>
        <div class="summary-value success">{{ summary.finished }}</div>
      </div>
      <div class="summary-card">
        <div class="summary-label">取消/拒绝</div>
        <div class="summary-value danger">{{ summary.closed }}</div>
      </div>
    </div>

    <a-tabs v-model:activeKey="activeTab" class="order-tabs">
      <a-tab-pane key="all" tab="全部" />
      <a-tab-pane key="waitPay" tab="待支付" />
      <a-tab-pane key="waitLandlord" tab="待房东处理" />
      <a-tab-pane key="confirmed" tab="已确认/入住中" />
      <a-tab-pane key="closed" tab="已关闭" />
    </a-tabs>

    <a-spin :spinning="loading" style="width: 100%;">
      <div v-if="displayOrders.length === 0" class="empty-view">暂无订单，去门户页看看心仪房源吧。</div>

      <div class="order-item-view" v-for="item in displayOrders" :key="item.id">
        <div class="header">
          <div class="left">
            <span class="text">订单号</span>
            <span class="num">#{{ item.orderNumber }}</span>
            <span class="time">{{ formatOrderTime(item.orderTime) }}</span>
          </div>
          <div class="right">
            <a-tag :color="statusColor(item.orderStatus)">{{ statusText(item.orderStatus) }}</a-tag>
            <a-tag :color="payColor(item.payStatus)">{{ payText(item.payStatus) }}</a-tag>
            <a-tag v-if="isAbnormal(item)" color="#fa541c">异常</a-tag>
          </div>
        </div>

        <div class="step-line">
          <div
            v-for="step in getSteps(item)"
            :key="step.key"
            class="step-item"
            :class="`state-${step.state}`"
          >
            <span class="dot"></span>
            <span class="label">{{ step.label }}</span>
          </div>
        </div>

        <div class="content">
          <div class="left-list">
            <div class="list-item">
              <img :src="item.cover" class="thing-img" alt="cover" />
              <div class="detail">
                <div class="name-row">
                  <h2 class="name">{{ item.title }}</h2>
                  <span class="count">x{{ item.count }}</span>
                </div>
                <div class="price-row">
                  <span class="city">{{ item.cityCn || '城市待补充' }}</span>
                  <span class="price">¥{{ formatMoney(item.price) }}/晚</span>
                </div>
              </div>
            </div>
          </div>
          <div class="right-info">
            <p class="title">订单说明</p>
            <p class="text">{{ item.remark || '无备注' }}</p>
            <p class="text" v-if="item.checkinDate || item.checkoutDate">
              入住：{{ item.checkinDate || '-' }}，离店：{{ item.checkoutDate || '-' }}
            </p>
            <p class="danger-text" v-if="isAbnormal(item)">
              异常原因：{{ item.abnormalReason || '系统识别到异常订单，请联系平台客服' }}
            </p>
          </div>
        </div>

        <div class="bottom">
          <div class="left">
            <span class="text">共{{ item.count || 1 }}晚</span>
            <a-button type="link" size="small" @click="handleDetail(item.thingId)">房源详情</a-button>
          </div>
          <div class="right">
            <span class="pay-text">实付金额 ¥{{ formatMoney(getAmount(item)) }}</span>
            <a-button v-if="canPay(item)" type="primary" @click="handlePay(item)">去支付</a-button>
            <a-popconfirm
              v-if="canCheckin(item)"
              title="确认已入住该订单吗？"
              ok-text="确认入住"
              cancel-text="取消"
              @confirm="handleCheckin(item)"
            >
              <a-button type="primary">确认入住</a-button>
            </a-popconfirm>
            <a-popconfirm
              v-if="canCheckout(item)"
              title="确认已退房离店吗？"
              ok-text="确认退房"
              cancel-text="取消"
              @confirm="handleCheckout(item)"
            >
              <a-button type="primary">确认退房</a-button>
            </a-popconfirm>
            <a-button v-if="canReview(item)" @click="openReview(item)">去评价</a-button>
            <a-button v-if="isReviewed(item)" disabled>已评价</a-button>
            <a-popconfirm
              v-if="canCancel(item)"
              title="确定取消这笔订单吗？"
              ok-text="确定"
              cancel-text="取消"
              @confirm="handleCancel(item)"
            >
              <a-button danger>取消订单</a-button>
            </a-popconfirm>
          </div>
        </div>
      </div>
    </a-spin>

    <a-modal
      v-model:visible="reviewModal.visible"
      title="提交评价"
      ok-text="提交"
      cancel-text="取消"
      :confirm-loading="reviewModal.submitting"
      @ok="submitReview"
      @cancel="closeReviewModal"
    >
      <a-form layout="vertical">
        <a-form-item label="评分">
          <a-rate v-model:value="reviewModal.rating" />
        </a-form-item>
        <a-form-item label="评价内容">
          <a-textarea
            v-model:value="reviewModal.content"
            :rows="4"
            :maxlength="300"
            show-count
            placeholder="说说这次入住体验"
          />
        </a-form-item>
        <a-form-item>
          <a-checkbox v-model:checked="reviewModal.isAnonymous">匿名评价</a-checkbox>
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { message } from 'ant-design-vue'
import { getFormatTime } from '/@/utils/'
import { BASE_URL, USER_ID, USER_TOKEN } from '/@/store/constants'
import { cancelUserOrderApi, checkinApi, checkoutApi, userOrderListApi, payStatusApi } from '/@/api/order'
import { createApi as createReviewApi, listMyApi as listMyReviewApi } from '/@/api/comment'

const router = useRouter()
const route = useRoute()

const loading = ref(false)
const activeTab = ref('all')
const orderData = ref([])
const reviewedOrderIds = ref(new Set())

const reviewModal = reactive({
  visible: false,
  submitting: false,
  orderId: 0,
  rating: 5,
  content: '',
  isAnonymous: false
})

function checkLogin() {
  const token = localStorage.getItem(USER_TOKEN)
  const userId = localStorage.getItem(USER_ID)
  if (!token || !userId) {
    return false
  }
  return true
}

onMounted(() => {
  const payReturn = route.query.payReturn
  const orderId = route.query.orderId
  
  if (payReturn === '1' && orderId) {
    pollPayStatus(Number(orderId))
  }
  
  if (!checkLogin()) {
    message.warn('请先登录后再查看订单。')
    router.push({ name: 'login' })
    return
  }
  Promise.all([getOrderList(), loadMyReviews()])
})

async function pollPayStatus(orderId: number) {
  const maxAttempts = 10
  const interval = 2000
  let attempts = 0
  
  const poll = async () => {
    if (attempts >= maxAttempts) {
      message.info('支付状态查询超时，请手动刷新订单列表')
      return
    }
    attempts++
    
    try {
      const res = await payStatusApi({ orderId })
      const paid = String(res?.data?.payStatus || '') === '1'
      if (paid) {
        message.success('支付成功！')
        if (checkLogin()) {
          getOrderList()
        }
        return
      }
      setTimeout(poll, interval)
    } catch (_err) {
      setTimeout(poll, interval)
    }
  }
  
  poll()
}

const summary = computed(() => {
  const rows = orderData.value || []
  return {
    all: rows.length,
    waitPay: rows.filter((it) => String(it.orderStatus) === '0').length,
    waitLandlord: rows.filter((it) => String(it.orderStatus) === '1').length,
    finished: rows.filter((it) => ['2', '3', '6'].includes(String(it.orderStatus))).length,
    closed: rows.filter((it) => ['4', '5'].includes(String(it.orderStatus))).length
  }
})

const displayOrders = computed(() => {
  let rows = [...(orderData.value || [])]
  if (activeTab.value === 'waitPay') {
    rows = rows.filter((it) => String(it.orderStatus) === '0')
  }
  if (activeTab.value === 'waitLandlord') {
    rows = rows.filter((it) => String(it.orderStatus) === '1')
  }
  if (activeTab.value === 'confirmed') {
    rows = rows.filter((it) => ['2', '3', '6'].includes(String(it.orderStatus)))
  }
  if (activeTab.value === 'closed') {
    rows = rows.filter((it) => ['4', '5'].includes(String(it.orderStatus)))
  }
  rows.sort((a, b) => {
    const ta = new Date(a.orderTime || 0).getTime()
    const tb = new Date(b.orderTime || 0).getTime()
    return tb - ta
  })
  return rows
})

function toNumber(value) {
  const n = Number(value)
  return Number.isFinite(n) ? n : 0
}

function resolveCover(cover) {
  const raw = String(cover || '').trim()
  if (!raw) return '/images/demo.jpg'
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:')
  if (raw.startsWith('/')) return raw
  return `${BASE_URL}/api/staticfiles/image/${raw}`
}

function formatMoney(value) {
  return toNumber(value).toFixed(2)
}

function formatOrderTime(value) {
  if (!value) return '--'
  const date = new Date(value)
  if (isNaN(date.getTime())) return '--'
  const year = date.getFullYear()
  const month = String(date.getMonth() + 1).padStart(2, '0')
  const day = String(date.getDate()).padStart(2, '0')
  const hour = String(date.getHours()).padStart(2, '0')
  const min = String(date.getMinutes()).padStart(2, '0')
  const sec = String(date.getSeconds()).padStart(2, '0')
  return `${year}-${month}-${day} ${hour}:${min}:${sec}`
}

function getAmount(item) {
  const amount = toNumber(item.amountPayable || item.amountTotal)
  if (amount > 0) return amount
  return toNumber(item.price) * toNumber(item.count || 1)
}

function statusText(orderStatus) {
  const status = String(orderStatus || '')
  if (status === '0') return '待支付'
  if (status === '1') return '待房东处理'
  if (status === '2') return '已确认'
  if (status === '3') return '已完成'
  if (status === '4') return '已取消'
  if (status === '5') return '已拒绝'
  if (status === '6') return '已入住'
  return '未知状态'
}

function statusColor(orderStatus) {
  const status = String(orderStatus || '')
  if (status === '0') return '#faad14'
  if (status === '1') return '#1677ff'
  if (status === '2') return '#52c41a'
  if (status === '3') return '#237804'
  if (status === '4' || status === '5') return '#ff4d4f'
  if (status === '6') return '#722ed1'
  return '#8c8c8c'
}

function payText(payStatus) {
  const status = String(payStatus || '')
  if (status === '1') return '已支付'
  if (status === '2') return '已退款'
  return '未支付'
}

function payColor(payStatus) {
  const status = String(payStatus || '')
  if (status === '1') return '#2db7f5'
  if (status === '2') return '#fa8c16'
  return '#8c8c8c'
}

function isAbnormal(item) {
  return String(item?.abnormalFlag || '0') === '1' || Boolean(item?.abnormalReason)
}

function canPay(item) {
  return String(item?.orderStatus || '') === '0'
}

function canCancel(item) {
  return ['0', '1', '2'].includes(String(item?.orderStatus || ''))
}

function canCheckin(item) {
  const status = String(item?.orderStatus || '')
  const paid = String(item?.payStatus || '') === '1'
  return status === '2' && paid
}

function canReview(item) {
  const status = String(item?.orderStatus || '')
  if (!['3', '6'].includes(status)) return false
  return !reviewedOrderIds.value.has(Number(item?.id || 0))
}

function canCheckout(item) {
  return String(item?.orderStatus || '') === '6'
}

function isReviewed(item) {
  const status = String(item?.orderStatus || '')
  if (!['3', '6'].includes(status)) return false
  return reviewedOrderIds.value.has(Number(item?.id || 0))
}

function getSteps(item) {
  const status = String(item?.orderStatus || '')
  const paid = String(item?.payStatus || '') === '1' || ['1', '2', '3', '6'].includes(status)
  const landlordDone = ['2', '3', '6'].includes(status)
  const checkedIn = ['6'].includes(status)
  const finished = ['3'].includes(status)
  const closed = ['4', '5'].includes(status)

  return [
    { key: 'create', label: '创建', state: 'done' },
    { key: 'pay', label: paid ? '已支付' : '待支付', state: paid ? 'done' : status === '0' ? 'active' : 'todo' },
    {
      key: 'landlord',
      label: landlordDone ? '房东已处理' : '待房东处理',
      state: landlordDone ? 'done' : status === '1' ? 'active' : 'todo'
    },
    {
      key: 'stay',
      label: checkedIn ? '已入住' : finished ? '已离店' : '待入住',
      state: checkedIn || finished ? 'done' : status === '2' ? 'active' : 'todo'
    },
    {
      key: 'archive',
      label: closed ? statusText(status) : finished ? '已完成' : '待归档',
      state: closed || finished ? 'done' : status === '6' ? 'active' : 'todo'
    }
  ]
}

async function getOrderList() {
  loading.value = true
  try {
    const res = await userOrderListApi({})
    const rows = Array.isArray(res?.data) ? res.data : []
    orderData.value = rows.map((item) => ({
      ...item,
      count: toNumber(item.count || 1),
      price: toNumber(item.price || 0),
      cover: resolveCover(item.cover)
    }))
  } catch (err) {
    console.error(err)
    const errMsg = err?.msg || err?.message || '加载订单失败'
    if (errMsg.includes('认证失败') || errMsg.includes('无法访问')) {
      message.warn('登录已过期，请重新登录。')
      router.push({ name: 'login' })
    } else {
      message.error(errMsg)
    }
  } finally {
    loading.value = false
  }
}

async function loadMyReviews() {
  try {
    const res = await listMyReviewApi()
    const ids = new Set()
    const rows = Array.isArray(res?.data) ? res.data : []
    rows.forEach((item) => {
      const orderId = Number(item?.orderId || 0)
      if (orderId > 0) ids.add(orderId)
    })
    reviewedOrderIds.value = ids
  } catch (_error) {
    reviewedOrderIds.value = new Set()
  }
}

function handleDetail(thingId) {
  const target = router.resolve({ name: 'detail', query: { id: thingId } })
  window.open(target.href, '_blank')
}

function handlePay(item) {
  const orderId = Number(item?.id || 0)
  if (!orderId) {
    message.warning('订单号缺失，请刷新后重试')
    return
  }
  router.push({
    name: 'pay',
    query: {
      orderId,
      amount: getAmount(item)
    }
  })
}

function handleCancel(item) {
  cancelUserOrderApi({ id: item.id })
    .then(() => {
      message.success('订单已取消')
      getOrderList()
    })
    .catch((err) => {
      message.error(err?.msg || '取消失败')
    })
}

function handleCheckin(item) {
  checkinApi({ id: item?.id, reason: 'checkin-by-tenant' })
    .then(() => {
      message.success('确认入住成功')
      getOrderList()
    })
    .catch((err) => {
      message.error(err?.msg || '确认入住失败')
    })
}

function handleCheckout(item) {
  checkoutApi({ id: item?.id, reason: 'checkout-by-tenant' })
    .then(() => {
      message.success('退房成功')
      getOrderList()
    })
    .catch((err) => {
      message.error(err?.msg || '退房失败')
    })
}

function openReview(item) {
  reviewModal.visible = true
  reviewModal.orderId = Number(item?.id || 0)
  reviewModal.rating = 5
  reviewModal.content = ''
  reviewModal.isAnonymous = false
}

function closeReviewModal() {
  reviewModal.visible = false
}

async function submitReview() {
  if (!reviewModal.orderId) {
    message.warning('订单ID缺失，请刷新后重试')
    return
  }
  reviewModal.submitting = true
  try {
    await createReviewApi({
      orderId: reviewModal.orderId,
      rating: reviewModal.rating,
      content: reviewModal.content,
      isAnonymous: reviewModal.isAnonymous ? '1' : '0'
    })
    message.success('评价提交成功')
    closeReviewModal()
    await Promise.all([getOrderList(), loadMyReviews()])
  } catch (err) {
    message.error(err?.msg || '评价提交失败')
  } finally {
    reviewModal.submitting = false
  }
}
</script>

<style scoped lang="less">
.content-list {
  flex: 1;
}

.list-title {
  color: #152844;
  font-weight: 600;
  font-size: 18px;
  line-height: 24px;
  margin-bottom: 8px;
}

.summary-grid {
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 10px;
  margin-bottom: 12px;
}

.summary-card {
  border: 1px solid #e6edf8;
  border-radius: 10px;
  padding: 10px 12px;
  background: #fff;
}

.summary-label {
  color: #64748b;
  font-size: 12px;
}

.summary-value {
  margin-top: 6px;
  color: #1d4ed8;
  font-size: 22px;
  font-weight: 700;
}

.summary-value.warning {
  color: #d48806;
}

.summary-value.processing {
  color: #1677ff;
}

.summary-value.success {
  color: #389e0d;
}

.summary-value.danger {
  color: #cf1322;
}

.order-tabs {
  margin-bottom: 8px;
}

.empty-view {
  margin-top: 16px;
  background: #f8fafc;
  border: 1px dashed #cbd5e1;
  border-radius: 10px;
  padding: 22px;
  text-align: center;
  color: #64748b;
}

.order-item-view {
  background: #f7f9fb;
  border: 1px solid #e5ecf8;
  border-radius: 10px;
  padding: 14px;
  margin-top: 12px;
}

.header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding-bottom: 10px;
  border-bottom: 1px solid #cedce4;
}

.header .left {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
}

.header .text {
  color: #64748b;
}

.header .num {
  color: #0f172a;
  font-weight: 600;
}

.header .time {
  color: #94a3b8;
}

.header .right {
  display: flex;
  align-items: center;
  gap: 8px;
}

.step-line {
  margin-top: 12px;
  display: grid;
  grid-template-columns: repeat(5, minmax(0, 1fr));
  gap: 6px;
}

.step-item {
  position: relative;
  display: flex;
  align-items: center;
  gap: 8px;
  color: #94a3b8;
  font-size: 12px;
  line-height: 1;
}

.step-item::after {
  content: '';
  position: absolute;
  left: calc(50% + 10px);
  top: 5px;
  width: calc(100% - 20px);
  border-top: 1px dashed #d0dbe8;
}

.step-item:last-child::after {
  display: none;
}

.step-item .dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  background: #d0dbe8;
  z-index: 1;
}

.step-item.state-done {
  color: #389e0d;
}

.step-item.state-done .dot {
  background: #52c41a;
}

.step-item.state-active {
  color: #1677ff;
}

.step-item.state-active .dot {
  background: #1677ff;
}

.content {
  margin-top: 12px;
  display: flex;
  gap: 12px;
}

.left-list {
  flex: 2;
}

.list-item {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.thing-img {
  width: 118px;
  height: 88px;
  border-radius: 8px;
  object-fit: cover;
  border: 1px solid #e2e8f0;
}

.detail {
  flex: 1;
}

.name-row {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 8px;
}

.name {
  margin: 0;
  color: #0f172a;
  font-size: 15px;
  line-height: 22px;
}

.count {
  color: #64748b;
  font-size: 13px;
}

.price-row {
  margin-top: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.city {
  color: #64748b;
  font-size: 13px;
}

.price {
  color: #ff7b31;
  font-size: 14px;
  font-weight: 600;
}

.right-info {
  flex: 1;
  border-left: 1px solid #cedce4;
  padding-left: 12px;
}

.right-info .title {
  margin: 0;
  color: #334155;
  font-size: 13px;
  font-weight: 600;
}

.right-info .text {
  margin: 6px 0 0;
  color: #475569;
  font-size: 13px;
  line-height: 20px;
}

.right-info .danger-text {
  margin: 6px 0 0;
  color: #cf1322;
  font-size: 13px;
  line-height: 20px;
}

.bottom {
  margin-top: 12px;
  padding-top: 10px;
  border-top: 1px solid #cedce4;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.bottom .left {
  display: flex;
  align-items: center;
  gap: 6px;
}

.bottom .left .text {
  color: #64748b;
  font-size: 13px;
}

.bottom .right {
  display: flex;
  align-items: center;
  gap: 10px;
}

.pay-text {
  color: #111827;
  font-size: 14px;
  font-weight: 600;
}

@media (max-width: 1200px) {
  .summary-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .step-line {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    row-gap: 10px;
  }

  .step-item::after {
    display: none;
  }

  .content {
    flex-direction: column;
  }

  .right-info {
    border-left: none;
    border-top: 1px solid #cedce4;
    padding-left: 0;
    padding-top: 10px;
  }

  .bottom {
    flex-direction: column;
    align-items: flex-start;
    gap: 10px;
  }
}
</style>
