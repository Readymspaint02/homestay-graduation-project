<template>
  <div>
    <Header />
    <div class="pay-content">
      <div class="title">选择支付方式</div>
      <div class="text time-margin">
        <span>请在 </span>
        <span class="time">{{ ddlTime }}</span>
        <span> 前完成支付</span>
      </div>
      <div class="text">支付金额</div>
      <div class="price">
        <span class="num">{{ amount }}</span>
        <span>元</span>
      </div>

      <div class="pay-choose-view">
        <div class="pay-choose-box flex-view">
          <div class="choose-box" :class="{ 'choose-box-active': payMethod === 'wechat' }" @click="payMethod = 'wechat'">
            <img :src="WxPayIcon" alt="wechat" />
            <span>微信支付</span>
          </div>
          <div class="choose-box" :class="{ 'choose-box-active': payMethod === 'alipay' }" @click="payMethod = 'alipay'">
            <img :src="AliPayIcon" alt="ali" />
            <span>支付宝沙箱</span>
          </div>
        </div>

        <div class="tips">
          <template v-if="payMethod === 'wechat'">
            微信模拟支付 - 点击即可完成支付（备选方案）
          </template>
          <template v-else>
            支付宝沙箱支付 - 将跳转至支付宝沙箱收银台
          </template>
        </div>
        
        <div v-if="polling" class="polling-tip">
          正在自动检测支付状态，支付成功后将自动跳转...
        </div>
        
        <div v-if="paySuccess" class="success-tip">
          支付成功！订单已更新，请前往<a @click="goToOrders">我的订单</a>查看。
        </div>

        <div class="pay-actions">
          <button v-if="payMethod === 'wechat'" class="pay-btn pay-btn-active pay-btn-wechat" :disabled="wxPaying || !orderId" @click="handlePayWechat">
            {{ wxPaying ? '支付中...' : '微信模拟支付' }}
          </button>
          <template v-else>
            <button class="pay-btn pay-btn-active" :disabled="aliPaying || !orderId" @click="handlePayAli">
              {{ aliPaying ? '正在唤起支付宝...' : '支付宝沙箱支付' }}
            </button>
            <button class="pay-btn" :disabled="checking || !orderId" @click="checkStatus">
              {{ checking ? '查询中...' : '查询支付状态' }}
            </button>
            <button v-if="!polling" class="pay-btn" :disabled="!orderId" @click="startPolling">
              开启自动检测
            </button>
            <button v-else class="pay-btn" @click="stopPolling">
              停止检测
            </button>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import Header from '/@/views/index/components/header.vue';
import { message } from 'ant-design-vue';
import AliPayIcon from '/@/assets/images/ali-pay-icon.svg';
import WxPayIcon from '/@/assets/images/wx-pay-icon.svg';
import { payStatusApi, wxMockNotifyApi, alipayCreateApi, alipayStatusApi } from '/@/api/order';
import router from '/@/router';

const route = useRoute();

const ddlTime = ref('');
const amount = ref('0.00');
const orderId = ref(0);
const payMethod = ref('wechat');
const aliPaying = ref(false);
const wxPaying = ref(false);
const checking = ref(false);
const polling = ref(false);
const paySuccess = ref(false);
const pollingCount = ref(0);
let pollingTimer = null;

onMounted(async () => {
  amount.value = Number(route.query.amount || 0).toFixed(2);
  orderId.value = Number(route.query.orderId || 0);
  if (!orderId.value) {
    message.warning('订单参数缺失，请返回订单页重试');
    return;
  }
  ddlTime.value = formatDate(new Date().getTime() + 15 * 60 * 1000, 'YY-MM-DD hh:mm:ss');
  
  if (route.query.payReturn === '1' || route.query.trade_no) {
    message.info('检测到支付返回，正在自动检测支付状态...');
    startPolling();
  } else {
    const pendingOrder = sessionStorage.getItem('alipay_pending_order');
    const pendingTime = sessionStorage.getItem('alipay_pending_time');
    if (pendingOrder && pendingTime) {
      const elapsed = Date.now() - Number(pendingTime);
      if (elapsed < 10 * 60 * 1000 && Number(pendingOrder) === orderId.value) {
        message.info('检测到待支付订单，正在自动检测支付状态...');
        startPolling();
      }
    }
  }
});

onUnmounted(() => {
  stopPolling();
});

function startPolling() {
  if (polling.value) return;
  polling.value = true;
  pollingCount.value = 0;
  
  const doPoll = async () => {
    if (pollingCount.value >= 40) {
      stopPolling();
      message.warning('检测超时，请手动点击"查询支付状态"');
      return;
    }
    pollingCount.value++;
    
    try {
      const res = await alipayStatusApi(orderId.value);
      const tradeStatus = res?.data?.tradeStatus || '';
      if (tradeStatus === 'TRADE_SUCCESS' || tradeStatus === 'TRADE_FINISHED') {
        stopPolling();
        paySuccess.value = true;
        message.success('支付成功！即将跳转到订单页面...');
        setTimeout(() => {
          goToOrders();
        }, 1500);
      }
    } catch (_err) {
      // ignore
    }
  };
  
  doPoll();
  pollingTimer = setInterval(doPoll, 2000);
}

function stopPolling() {
  if (pollingTimer) {
    clearInterval(pollingTimer);
    pollingTimer = null;
  }
  polling.value = false;
}

function goToOrders() {
  sessionStorage.removeItem('alipay_pending_order');
  sessionStorage.removeItem('alipay_pending_time');
  router.push({ name: 'orderView' });
}

const handlePayAli = async () => {
  if (!orderId.value || aliPaying.value) return;
  aliPaying.value = true;
  try {
    const res = await alipayCreateApi({ orderId: orderId.value, amount: amount.value });
    const formHtml = res?.data?.formHtml;
    if (formHtml) {
      sessionStorage.setItem('alipay_pending_order', String(orderId.value));
      sessionStorage.setItem('alipay_pending_time', String(Date.now()));
      const tempDiv = document.createElement('div');
      tempDiv.innerHTML = formHtml;
      document.body.appendChild(tempDiv);
      const form = tempDiv.querySelector('form');
      if (form) {
        form.submit();
      }
      document.body.removeChild(tempDiv);
      message.info('已跳转到支付宝，支付完成后将自动检测并跳转...');
    } else {
      await wxMockNotifyApi({ orderId: orderId.value, success: true });
      message.success('支付成功（沙箱模拟）');
      paySuccess.value = true;
      setTimeout(() => {
        goToOrders();
      }, 1500);
    }
  } catch (err) {
    message.error(err?.msg || '支付宝支付失败，请重试或使用微信模拟支付');
  } finally {
    aliPaying.value = false;
  }
};

const handlePayWechat = async () => {
  if (!orderId.value || wxPaying.value) return;
  wxPaying.value = true;
  try {
    await wxMockNotifyApi({ orderId: orderId.value, success: true });
    message.success('微信支付成功！');
    paySuccess.value = true;
    setTimeout(() => {
      goToOrders();
    }, 1500);
  } catch (err) {
    message.error(err?.msg || '微信支付失败');
  } finally {
    wxPaying.value = false;
  }
};

const checkStatus = async () => {
  if (!orderId.value || checking.value) return;
  checking.value = true;
  try {
    const res = await alipayStatusApi(orderId.value);
    const tradeStatus = res?.data?.tradeStatus || '';
    if (tradeStatus === 'TRADE_SUCCESS' || tradeStatus === 'TRADE_FINISHED') {
      message.success('支付成功！即将跳转到订单页面...');
      paySuccess.value = true;
      setTimeout(() => {
        goToOrders();
      }, 1500);
      return;
    }
    message.info('当前订单未支付，状态：' + tradeStatus);
  } catch (err) {
    message.error(err?.msg || '查询支付状态失败');
  } finally {
    checking.value = false;
  }
};

const formatDate = (time, format = 'YY-MM-DD hh:mm:ss') => {
  const date = new Date(time);
  const year = date.getFullYear();
  const month = date.getMonth() + 1;
  const day = date.getDate();
  const hour = date.getHours();
  const min = date.getMinutes();
  const sec = date.getSeconds();
  const preArr = Array.apply(null, Array(10)).map((_elem, index) => `0${index}`);

  return format
    .replace(/YY/g, String(year))
    .replace(/MM/g, preArr[month] || String(month))
    .replace(/DD/g, preArr[day] || String(day))
    .replace(/hh/g, preArr[hour] || String(hour))
    .replace(/mm/g, preArr[min] || String(min))
    .replace(/ss/g, preArr[sec] || String(sec));
};
</script>

<style scoped lang="less">
.flex-view {
  display: flex;
}

.pay-content {
  position: relative;
  margin: 120px auto 0;
  width: 520px;
  background: #fff;
  overflow: hidden;
}

.title {
  color: #152844;
  font-weight: 500;
  font-size: 24px;
  line-height: 22px;
  text-align: center;
  margin-bottom: 11px;
}

.time-margin {
  margin: 11px 0 24px;
}

.text {
  height: 22px;
  line-height: 22px;
  font-size: 14px;
  text-align: center;
  color: #152844;
}

.time {
  color: #f62a2a;
}

.price {
  color: #ff8a00;
  font-weight: 500;
  font-size: 16px;
  height: 36px;
  line-height: 36px;
  text-align: center;
}

.num {
  font-size: 28px;
}

.pay-choose-view {
  margin-top: 24px;
}

.choose-box {
  width: 180px;
  height: 126px;
  border: 1px solid #cedce4;
  border-radius: 4px;
  text-align: center;
  cursor: pointer;
  margin: 0 auto;
}

.pay-choose-box {
  justify-content: center;
}

.pay-choose-box img {
  height: 40px;
  margin: 24px auto 16px;
  display: block;
}

.tips {
  color: #6f6f6f;
  font-size: 13px;
  line-height: 22px;
  text-align: center;
  margin: 14px 0 18px;
}

.choose-box-active {
  border: 1px solid #4684e2;
}

.pay-actions {
  display: flex;
  justify-content: center;
  gap: 12px;
}

.pay-btn {
  cursor: pointer;
  background: #c3c9d5;
  border-radius: 32px;
  width: 124px;
  height: 34px;
  line-height: 34px;
  border: none;
  outline: none;
  font-size: 13px;
  color: #fff;
  text-align: center;
}

.pay-btn-active {
  background: #4684e2;
}

.pay-btn-wechat {
  background: #07c160;
}

.pay-btn-wechat:hover {
  background: #06ad56;
}

.pay-btn:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.polling-tip {
  color: #1677ff;
  font-size: 13px;
  line-height: 22px;
  text-align: center;
  margin: 10px 0;
  padding: 8px;
  background: #e6f4ff;
  border-radius: 4px;
}

.success-tip {
  color: #52c41a;
  font-size: 14px;
  line-height: 22px;
  text-align: center;
  margin: 10px 0;
  padding: 12px;
  background: #f6ffed;
  border-radius: 4px;
  border: 1px solid #b7eb8f;
}

.success-tip a {
  color: #1677ff;
  cursor: pointer;
  text-decoration: underline;
}
</style>
