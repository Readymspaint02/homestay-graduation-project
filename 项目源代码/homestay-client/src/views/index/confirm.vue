<template>
  <div>
    <Header />

    <section class="cart-page">
      <div class="left-flex">
        <div class="title-row">
          <h3>订单详情</h3>
        </div>

        <div class="cart-list-view">
          <div class="list-th">
            <span class="line-1">房源</span>
            <span class="line-2">价格</span>
            <span class="line-5">人数</span>
            <span class="line-6">操作</span>
          </div>

          <div class="list">
            <div class="items">
              <div class="book">
                <img :src="pageData.cover" alt="房源封面" />
                <h2>{{ pageData.title }}</h2>
              </div>
              <div class="pay">￥{{ formatMoney(pageData.price) }}</div>
              <a-input-number v-model:value="pageData.count" :min="1" :max="10" @change="onCountChange" />
              <img :src="DeleteIcon" class="delete" alt="删除" />
            </div>
          </div>
        </div>

        <div class="title-row mt-24">
          <h3>入住日期</h3>
        </div>

        <div class="stay-view">
          <div class="stay-item">
            <span class="k">入住</span>
            <span class="v">{{ pageData.checkinDate }}</span>
          </div>
          <div class="stay-item">
            <span class="k">离店</span>
            <span class="v">{{ pageData.checkoutDate }}</span>
          </div>
          <div class="stay-item">
            <span class="k">晚数</span>
            <span class="v">{{ pageData.nights }}</span>
          </div>
        </div>

        <div class="title-row mt-24">
          <h3>备注</h3>
        </div>

        <textarea v-model="pageData.remark" placeholder="请输入备注（最多100字）" class="remark" maxlength="100"></textarea>

        <div class="title-row mt-24">
          <h3>入住人信息</h3>
          <span class="click-txt" v-if="pageData.guestList.length < maxGuestFormRows" @click="addGuestRow">添加入住人</span>
        </div>

        <div class="guest-list">
          <div class="guest-card" v-for="(guest, index) in pageData.guestList" :key="`guest-${index}`">
            <div class="guest-head">
              <span>入住人 {{ index + 1 }}</span>
              <a v-if="pageData.guestList.length > 1" @click="removeGuestRow(index)">删除</a>
            </div>
            <div class="guest-grid">
              <a-input v-model:value="guest.guestName" placeholder="姓名" />
              <a-select v-model:value="guest.idType" style="width: 130px">
                <a-select-option value="ID_CARD">身份证</a-select-option>
                <a-select-option value="PASSPORT">护照</a-select-option>
                <a-select-option value="OTHER">其他</a-select-option>
              </a-select>
              <a-input v-model:value="guest.idNo" placeholder="证件号" />
              <a-input v-model:value="guest.mobile" placeholder="手机号（必填）" />
            </div>
          </div>
        </div>

        <div class="title-row mt-24">
          <h3>入住地址</h3>
        </div>

        <div class="address-view">
          <div class="homestay-address-card">
            <div class="line-top">
              <span class="name">{{ pageData.homestayName || pageData.title }}</span>
              <span class="click-txt" @click="copyAddress">复制地址</span>
            </div>
            <div class="line-bottom">{{ pageData.homestayAddress || '暂无详细地址' }}</div>
          </div>
        </div>
      </div>

      <div class="right-flex">
        <div class="title-row">
          <h3>结算信息</h3>
          <span class="click-txt">费用</span>
        </div>

        <div class="price-view">
          <div class="price-item">
            <div class="item-name">房费单价</div>
            <div class="price-txt">￥{{ formatMoney(pageData.price) }}</div>
          </div>
          <div class="price-item">
            <div class="item-name">入住晚数</div>
            <div class="price-txt">{{ pageData.nights }}</div>
          </div>
          <div class="price-item">
            <div class="item-name">小计</div>
            <div class="price-txt">￥{{ formatMoney(pageData.amount) }}</div>
          </div>
          <div class="price-item">
            <div class="item-name">优惠</div>
            <div class="price-txt">￥0.00</div>
          </div>

          <div class="total-price-view">
            <span>合计</span>
            <div class="price">
              <span class="font-big">￥{{ formatMoney(pageData.amount) }}</span>
            </div>
          </div>

          <div class="receiver-view" v-if="pageData.homestayAddress">
            <div class="receiver-title">入住地址</div>
            <div>{{ pageData.homestayAddress }}</div>
          </div>

          <div class="btns-view">
            <button class="btn buy" @click="handleBack">返回</button>
            <button class="btn pay" :disabled="submitting" @click="handleJiesuan">
              {{ submitting ? '提交中...' : '去结算' }}
            </button>
          </div>
        </div>
      </div>
    </section>

    <a-modal
      :visible="modal.visible"
      :title="modal.title"
      :width="560"
      :centered="true"
      :mask-closable="false"
      :destroy-on-close="true"
      ok-text="确定"
      cancel-text="取消"
      @cancel="handleCancel"
      @ok="handleOk"
    >
      <a-form ref="myform" :label-col="{ style: { width: '90px' } }" :model="modal.form" :rules="modal.rules">
        <a-form-item label="姓名" name="name">
          <a-input v-model:value="modal.form.name" placeholder="请输入联系人姓名" />
        </a-form-item>
        <a-form-item label="电话" name="mobile">
          <a-input v-model:value="modal.form.mobile" placeholder="请输入手机号" />
        </a-form-item>
        <a-form-item label="地址" name="desc">
          <a-input v-model:value="modal.form.desc" placeholder="请输入详细地址" />
        </a-form-item>
        <a-form-item label="设为默认" name="default">
          <a-switch v-model:checked="modal.form.default" />
        </a-form-item>
      </a-form>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive, ref } from 'vue';
  import { message } from 'ant-design-vue';
  import { useRoute, useRouter } from 'vue-router';
  import Header from '/@/views/index/components/header.vue';
  import DeleteIcon from '/@/assets/images/delete-icon.svg';
  import { createApi } from '/@/api/order';
  import { saveApi as saveCheckinGuestApi } from '/@/api/checkinGuest';
  import { listApi as listAddressListApi, createApi as createAddressApi } from '/@/api/address';
  import { detailApi } from '/@/api/thing';
  import { useUserStore } from '/@/store';
  import { USER_ID, BASE_URL } from '/@/store/constants';

  const router = useRouter();
  const route = useRoute();
  const userStore = useUserStore();

const loadingAddress = ref(false);
  const submitting = ref(false);
  const creatingAddress = ref(false);
  const loadingHomestay = ref(false);
  const maxGuestFormRows = 6;
  const MOBILE_REG = /^1\d{10}$/;

  const pageData = reactive({
    id: 0,
    title: '',
    cover: '/images/demo.jpg',
    price: 0,
    remark: '',
    count: 1,
    checkinDate: '',
    checkoutDate: '',
    nights: 1,
    amount: 0,
    homestayName: '',
    homestayAddress: '',
    selectedAddressId: undefined as number | undefined,
    receiverName: '',
    receiverPhone: '',
    receiverAddress: '',
    addressList: [] as any[],
    guestList: [{ guestName: '', idType: 'ID_CARD', idNo: '', mobile: '' }],
  });

  const modal = reactive({
    visible: false,
    title: '新增地址',
    form: {
      name: '',
      mobile: '',
      desc: '',
      default: false,
    },
    rules: {
      name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
      mobile: [{ required: true, message: '请输入电话', trigger: 'blur' }],
      desc: [{ required: true, message: '请输入地址', trigger: 'blur' }],
    },
  });

  const myform = ref();

  onMounted(async () => {
    pageData.id = toNumber(route.query.id);

    const queryCheckin = normalizeDateText(Array.isArray(route.query.checkinDate) ? route.query.checkinDate[0] : route.query.checkinDate);
    const queryCheckout = normalizeDateText(Array.isArray(route.query.checkoutDate) ? route.query.checkoutDate[0] : route.query.checkoutDate);
    const defaults = getDefaultStayRange();
    pageData.checkinDate = queryCheckin || defaults.checkinDate;
    pageData.checkoutDate = queryCheckout || defaults.checkoutDate;

    if (!ensureLoggedIn(false)) {
      return;
    }

    if (pageData.id > 0) {
      await loadHomestayDetail();
    }

    applyStayDates();
    syncGuestRowsByCount();
    recalcAmount();
  });

async function loadHomestayDetail() {
  loadingHomestay.value = true;
  try {
    const res = await detailApi({ id: pageData.id });
    const data = res?.data || {};
    console.log('[loadHomestayDetail] response data:', data, 'id:', data?.id);
    pageData.id = toNumber(data?.id || pageData.id);
    pageData.title = String(data.title || '民宿');
    pageData.cover = resolveCover(data.cover);
    pageData.price = toNumber(data.price || data.basePrice || 0);
    pageData.homestayName = String(data.title || '民宿');
    pageData.homestayAddress = buildFullAddress(data);
    recalcAmount();
  } catch (err: any) {
    message.error(err?.msg || '房源信息加载失败。');
  } finally {
    loadingHomestay.value = false;
  }
}

  function resolveCover(cover: any) {
    const raw = String(cover || '').trim();
    if (!raw) return '/images/demo.jpg';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:');
    if (raw.startsWith('//')) return 'https:' + raw;
    if (raw.startsWith('/')) return raw;
    return `${BASE_URL}/profile/${raw}`;
  }

  function buildFullAddress(data: any) {
    const cityMap: Record<string, string> = {
      Guangzhou: '广州',
      Shenzhen: '深圳',
      Beijing: '北京',
      Shanghai: '上海',
    };
    const city = cityMap[String(data.city || '')] || String(data.city || '');
    const address = String(data.address || '').trim();
    return [city, address].filter(Boolean).join(' ');
  }

  function applyStayDates() {
    const nights = getDateDiffNights(pageData.checkinDate, pageData.checkoutDate);
    if (nights <= 0) {
      pageData.checkoutDate = addDays(pageData.checkinDate, 1);
    }
    pageData.nights = Math.max(getDateDiffNights(pageData.checkinDate, pageData.checkoutDate), 1);
  }

  function copyAddress() {
    const address = pageData.homestayAddress;
    if (!address) {
      message.warn('暂无地址可复制');
      return;
    }
    navigator.clipboard.writeText(address).then(() => {
      message.success('地址已复制到剪贴板');
    }).catch(() => {
      message.error('复制失败，请手动复制');
    });
  }

  function toNumber(value: any) {
    const n = Number(value);
    return Number.isFinite(n) ? n : 0;
  }

  function formatMoney(value: any) {
    return toNumber(value).toFixed(2);
  }

  function formatDateYMD(date: Date) {
    const year = date.getFullYear();
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const day = String(date.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  }

  function addDays(dateText: string, offset: number) {
    const base = new Date(`${dateText}T00:00:00`);
    if (Number.isNaN(base.getTime())) return '';
    base.setDate(base.getDate() + offset);
    return formatDateYMD(base);
  }

  function getDateDiffNights(checkinDate: string, checkoutDate: string) {
    const checkin = new Date(`${checkinDate}T00:00:00`);
    const checkout = new Date(`${checkoutDate}T00:00:00`);
    if (Number.isNaN(checkin.getTime()) || Number.isNaN(checkout.getTime())) return 0;
    const diff = checkout.getTime() - checkin.getTime();
    return diff > 0 ? Math.floor(diff / (24 * 60 * 60 * 1000)) : 0;
  }

  function normalizeDateText(value: any) {
    const text = String(value || '').trim();
    if (!/^\d{4}-\d{2}-\d{2}$/.test(text)) {
      return '';
    }
    const date = new Date(`${text}T00:00:00`);
    if (Number.isNaN(date.getTime())) {
      return '';
    }
    return formatDateYMD(date);
  }

  function getDefaultStayRange() {
    const checkin = new Date();
    checkin.setHours(0, 0, 0, 0);
    checkin.setDate(checkin.getDate() + 1);

    const checkout = new Date(checkin);
    checkout.setDate(checkin.getDate() + 1);

    return {
      checkinDate: formatDateYMD(checkin),
      checkoutDate: formatDateYMD(checkout),
    };
  }

  function recalcAmount() {
    pageData.amount = pageData.price * pageData.nights;
  }

  function getCurrentUserId() {
    const fromStore = toNumber(userStore.user_id);
    if (fromStore > 0) return fromStore;

    const fromLocal = toNumber(localStorage.getItem(USER_ID));
    return fromLocal > 0 ? fromLocal : 0;
  }

  function goLogin() {
    const redirect = `${route.path}${window.location.search || ''}`;
    router.push({ name: 'login', query: { redirect } });
  }

  function ensureLoggedIn(showMessage = true) {
    const userId = getCurrentUserId();
    if (userId > 0) return true;

    if (showMessage) {
      message.warn('请先登录后再操作。');
    }

    goLogin();
    return false;
  }

  function onCountChange(value: number) {
    const count = toNumber(value);
    pageData.count = count > 0 ? count : 1;
    syncGuestRowsByCount();
  }

  function addGuestRow() {
    if (pageData.guestList.length >= maxGuestFormRows) return;
    pageData.guestList.push({ guestName: '', idType: 'ID_CARD', idNo: '', mobile: '' });
  }

  function removeGuestRow(index: number) {
    if (pageData.guestList.length <= 1) return;
    pageData.guestList.splice(index, 1);
  }

  function syncGuestRowsByCount() {
    const target = Math.max(1, Math.min(pageData.count || 1, maxGuestFormRows));
    while (pageData.guestList.length < target) {
      pageData.guestList.push({ guestName: '', idType: 'ID_CARD', idNo: '', mobile: '' });
    }
    while (pageData.guestList.length > target) {
      pageData.guestList.pop();
    }
  }

  function normalizeGuestPayload() {
    const rows = (pageData.guestList || [])
      .map((item: any) => ({
        guestName: String(item?.guestName || '').trim(),
        idType: String(item?.idType || 'ID_CARD').trim() || 'ID_CARD',
        idNo: String(item?.idNo || '').trim(),
        mobile: String(item?.mobile || '').trim(),
      }))
      .filter((item: any) => item.guestName || item.idNo || item.mobile);

    if (rows.length === 0) {
      message.warn('请至少填写一位入住人信息。');
      return null;
    }

    for (const item of rows) {
      if (!item.guestName || !item.idNo || !item.mobile) {
        message.warn('每位入住人都需要填写姓名、证件号和手机号。');
        return null;
      }
      if (!MOBILE_REG.test(item.mobile)) {
        message.warn('请输入正确的11位手机号。');
        return null;
      }
      if (item.idType === 'ID_CARD' && !isValidIdCard(item.idNo)) {
        message.warn('请输入正确的身份证号。');
        return null;
      }
    }
    return rows;
  }

  function isValidIdCard(idNo: string) {
    const value = String(idNo || '').trim().toUpperCase();
    if (/^\d{15}$/.test(value)) {
      const year = Number(`19${value.slice(6, 8)}`);
      const month = Number(value.slice(8, 10));
      const day = Number(value.slice(10, 12));
      return isRealDate(year, month, day);
    }
    if (!/^\d{17}[\dX]$/.test(value)) {
      return false;
    }

    const year = Number(value.slice(6, 10));
    const month = Number(value.slice(10, 12));
    const day = Number(value.slice(12, 14));
    if (!isRealDate(year, month, day)) {
      return false;
    }

    const weights = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
    const codes = ['1', '0', 'X', '9', '8', '7', '6', '5', '4', '3', '2'];
    let sum = 0;
    for (let i = 0; i < 17; i += 1) {
      sum += Number(value[i]) * weights[i];
    }
    return codes[sum % 11] === value[17];
  }

  function isRealDate(year: number, month: number, day: number) {
    if (!Number.isInteger(year) || !Number.isInteger(month) || !Number.isInteger(day)) return false;
    if (year < 1900 || year > 2099) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;
    const date = new Date(year, month - 1, day);
    return date.getFullYear() === year && date.getMonth() === month - 1 && date.getDate() === day;
  }

  async function listAddressData() {
    const userId = getCurrentUserId();
    if (!userId) {
      pageData.addressList = [];
      return;
    }

    loadingAddress.value = true;
    try {
      const res = await listAddressListApi({ userId });
      const rows = Array.isArray(res?.data) ? res.data : [];
      pageData.addressList = rows;

      if (rows.length > 0) {
        const defaultRow = rows.find((item) => String(item.def) === '1') || rows[0];
        selectAddress(defaultRow);
      } else {
        pageData.selectedAddressId = undefined;
        pageData.receiverName = '';
        pageData.receiverPhone = '';
        pageData.receiverAddress = '';
      }
    } catch (err: any) {
      if (Number(err?.code) === 401) {
        message.warn('登录状态已过期，请重新登录。');
        goLogin();
        return;
      }
      message.error(err?.msg || '地址列表加载失败。');
    } finally {
      loadingAddress.value = false;
    }
  }

  function selectAddress(item: any) {
    if (!item) return;

    pageData.selectedAddressId = toNumber(item.id);
    pageData.receiverName = String(item.name || '');
    pageData.receiverPhone = String(item.mobile || '');
    pageData.receiverAddress = String(item.description || '');
  }

  function handleAdd() {
    if (!ensureLoggedIn()) {
      return;
    }

    modal.visible = true;
    modal.title = '新增地址';
    modal.form.name = '';
    modal.form.mobile = '';
    modal.form.desc = '';
    modal.form.default = pageData.addressList.length === 0;
  }

  function handleCancel() {
    modal.visible = false;
  }

  async function handleOk() {
    const userId = getCurrentUserId();
    if (!userId) {
      ensureLoggedIn();
      return;
    }

    if (creatingAddress.value) return;

    try {
      await myform.value?.validate();
    } catch (_e) {
      return;
    }

    creatingAddress.value = true;
    try {
      const formData = new FormData();
      formData.append('userId', String(userId));
      formData.append('def', modal.form.default ? '1' : '0');
      formData.append('name', String(modal.form.name || '').trim());
      formData.append('mobile', String(modal.form.mobile || '').trim());
      formData.append('description', String(modal.form.desc || '').trim());
      await createAddressApi(formData);
      message.success('地址新增成功。');
      modal.visible = false;
      await listAddressData();
    } catch (err: any) {
      if (Number(err?.code) === 401) {
        message.warn('登录状态已过期，请重新登录。');
        goLogin();
        return;
      }
      message.error(err?.msg || '新增地址失败。');
    } finally {
      creatingAddress.value = false;
    }
  }

  function handleBack() {
    router.back();
  }

async function handleJiesuan() {
  const userId = getCurrentUserId();
  if (!userId) {
    ensureLoggedIn();
    return;
  }

  const homestayId = toNumber(pageData.id);
  if (!homestayId || homestayId <= 0) {
    message.warn('缺少房源数据，请返回后重试。');
    return;
  }

  const nights = getDateDiffNights(pageData.checkinDate, pageData.checkoutDate);
  if (nights <= 0) {
    message.warn('入住和离店日期不合法。');
    return;
  }
  const guests = normalizeGuestPayload();
  if (!guests) {
    return;
  }

  if (submitting.value) return;

  submitting.value = true;
  try {
    const payload = {
      homestayId,
      checkinDate: pageData.checkinDate,
      checkoutDate: pageData.checkoutDate,
      guestCount: pageData.count > 0 ? pageData.count : 1,
    };
    console.log('[handleJiesuan] payload:', payload);

    const res = await createApi(payload);
    const orderId = toNumber(res?.data?.id);
    const amount = toNumber(res?.data?.amountPayable || pageData.amount);

      if (orderId > 0) {
        try {
          await saveCheckinGuestApi({
            orderId,
            guests,
          });
        } catch (guestError: any) {
          message.warning(guestError?.msg || '订单已创建，但入住人信息保存失败。');
        }
      }

      message.success('订单创建成功，正在进入支付。');
      router.push({ name: 'pay', query: { amount, orderId } });
    } catch (err: any) {
      if (Number(err?.code) === 401) {
        message.warn('登录状态已过期，请重新登录。');
        goLogin();
        return;
      }
      message.error(err?.msg || '订单创建失败。');
    } finally {
      submitting.value = false;
    }
  }
</script>

<style scoped lang="less">
  .cart-page {
    width: 1100px;
    min-height: 50vh;
    margin: 100px auto;
    display: flex;
    gap: 20px;
  }

  .left-flex {
    flex: 17;
  }

  .right-flex {
    flex: 8;
    padding-left: 24px;
    border-left: 1px solid #cedce4;
  }

  .title-row {
    display: flex;
    justify-content: space-between;
    align-items: center;

    h3 {
      color: #152844;
      font-weight: 600;
      font-size: 18px;
      line-height: 26px;
      margin: 0;
    }
  }

  .mt-24 {
    margin-top: 24px;
  }

  .click-txt {
    color: #4684e2;
    font-size: 14px;
    cursor: pointer;
  }

  .cart-list-view {
    margin: 8px 0 24px;
  }

  .list-th {
    height: 42px;
    line-height: 42px;
    border-bottom: 1px solid #cedce4;
    color: #152844;
    font-size: 14px;
    display: flex;

    .line-1 {
      flex: 1;
      margin-right: 20px;
    }

    .line-2 {
      width: 105px;
      margin-right: 20px;
    }

    .line-5 {
      width: 90px;
      margin-right: 30px;
    }

    .line-6 {
      width: 40px;
    }
  }

  .items {
    display: flex;
    align-items: center;
    margin-top: 16px;

    .book {
      flex: 1;
      display: flex;
      align-items: center;
      margin-right: 20px;

      img {
        width: 72px;
        height: 52px;
        object-fit: cover;
        margin-right: 12px;
        border-radius: 6px;
      }

      h2 {
        flex: 1;
        margin: 0;
        font-size: 14px;
        line-height: 22px;
        color: #152844;
        font-weight: 500;
      }
    }

    .pay {
      color: #ff8a00;
      font-weight: 600;
      font-size: 16px;
      width: 105px;
      margin-right: 20px;
    }

    .delete {
      margin-left: 28px;
      width: 20px;
      opacity: 0.55;
    }
  }

  .stay-view {
    margin-top: 12px;
    border: 1px solid #dbe3ed;
    border-radius: 10px;
    padding: 12px;
    background: #f8fbff;
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 10px;
  }

  .stay-item {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .k {
    font-size: 12px;
    color: #64748b;
  }

  .v {
    color: #0f172a;
    font-weight: 600;
    font-size: 14px;
  }

  .remark {
    width: 100%;
    background: #f6f9fb;
    border: 1px solid #dbe3ed;
    border-radius: 8px;
    padding: 10px 12px;
    margin-top: 12px;
    resize: vertical;
    min-height: 80px;
    line-height: 22px;
    outline: none;
  }

  .guest-list {
    margin-top: 12px;
    display: flex;
    flex-direction: column;
    gap: 10px;
  }

  .guest-card {
    border: 1px solid #dbe3ed;
    border-radius: 10px;
    padding: 10px;
    background: #fff;
  }

  .guest-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: #334155;
    font-size: 13px;
    margin-bottom: 8px;
  }

  .guest-grid {
    display: grid;
    grid-template-columns: 1.2fr 0.8fr 1.4fr 1fr;
    gap: 8px;
  }

  .address-view {
    margin-top: 12px;
  }

  .homestay-address-card {
    border: 1px solid #dbe3ed;
    border-radius: 10px;
    padding: 12px;
    background: #f8fbff;
  }

  .info {
    color: #64748b;
    font-size: 14px;
  }

  .info-blue {
    color: #4684e2;
    cursor: pointer;
  }

  .address-list {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 10px;
  }

  .address-card {
    position: relative;
    border: 1px solid #dbe3ed;
    border-radius: 10px;
    padding: 10px;
    background: #fff;
    cursor: pointer;
  }

  .address-card.active {
    border-color: #3b82f6;
    box-shadow: 0 0 0 2px rgba(59, 130, 246, 0.12);
  }

  .line-top {
    display: flex;
    justify-content: space-between;
    align-items: center;
  }

  .name {
    color: #152844;
    font-weight: 600;
  }

  .tel {
    color: #334155;
    font-size: 13px;
  }

  .line-bottom {
    margin-top: 6px;
    color: #475569;
    font-size: 13px;
    line-height: 20px;
  }

  .tag-default {
    position: absolute;
    right: 8px;
    bottom: 8px;
    color: #2563eb;
    font-size: 12px;
  }

  .address-loading {
    margin-top: 12px;
    color: #64748b;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }

  .price-view {
    margin-top: 16px;
  }

  .price-item {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 8px;
    font-size: 14px;

    .item-name {
      color: #152844;
    }

    .price-txt {
      font-weight: 500;
      color: #ff8a00;
    }
  }

  .total-price-view {
    margin-top: 12px;
    border-top: 1px solid #cedce4;
    display: flex;
    justify-content: space-between;
    align-items: flex-start;
    padding-top: 10px;
    color: #152844;
    font-weight: 500;

    .price {
      color: #ff8a00;
      font-size: 16px;
      line-height: 36px;
    }
  }

  .receiver-view {
    margin-top: 12px;
    padding: 10px;
    background: #f8fbff;
    border: 1px solid #dbeafe;
    border-radius: 8px;
    color: #334155;
    font-size: 13px;
    line-height: 20px;
  }

  .receiver-title {
    margin-bottom: 4px;
    color: #0f172a;
    font-weight: 600;
  }

  .btns-view {
    margin-top: 24px;
    text-align: right;

    .btn {
      cursor: pointer;
      width: 96px;
      height: 36px;
      line-height: 33px;
      margin-left: 16px;
      text-align: center;
      border-radius: 32px;
      border: 1px solid #4684e2;
      font-size: 16px;
      outline: none;
    }

    .buy {
      background: #fff;
      color: #4684e2;
    }

    .pay {
      background: #4684e2;
      color: #fff;
    }

    .pay:disabled {
      background: #9db7ea;
      border-color: #9db7ea;
      cursor: not-allowed;
    }
  }

  @media (max-width: 980px) {
    .cart-page {
      width: calc(100% - 24px);
      margin-top: 80px;
      flex-direction: column;
    }

    .right-flex {
      border-left: none;
      border-top: 1px solid #cedce4;
      padding-left: 0;
      padding-top: 16px;
    }

    .address-list {
      grid-template-columns: 1fr;
    }

    .stay-view {
      grid-template-columns: 1fr;
    }

    .guest-grid {
      grid-template-columns: 1fr;
    }
  }
</style>
