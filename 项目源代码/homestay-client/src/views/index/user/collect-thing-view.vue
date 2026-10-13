<template>
  <div class="collect-page">
    <div class="page-header">
      <div class="header-left">
        <h1 class="page-title">我的收藏</h1>
        <span class="collect-count">共 {{ pageData.collectData.length }} 个房源</span>
      </div>
      <div class="header-right">
        <a-input-search
          v-model:value="searchKeyword"
          placeholder="搜索收藏房源"
          style="width: 240px"
          allow-clear
        />
      </div>
    </div>

    <div class="collect-content">
      <a-spin :spinning="pageData.loading">
        <div v-if="filteredData.length > 0" class="collect-grid">
          <div class="collect-card" v-for="(item, index) in filteredData" :key="index">
            <div class="card-cover" @click="handleClickItem(item)">
              <img :src="item.cover" alt="房源封面" />
              <div class="cover-overlay">
                <span class="view-detail">查看详情</span>
              </div>
              <div class="card-badge" v-if="item.ratingAvg">
                <span class="star-icon">★</span>
                <span class="rating-value">{{ item.ratingAvg }}</span>
              </div>
            </div>
            <div class="card-body">
              <h3 class="card-title">{{ item.title }}</h3>
              <div class="card-location" v-if="item.city || item.address">
                <span class="location-icon">📍</span>
                <span class="location-text">{{ displayLocation(item) }}</span>
              </div>
              <div class="card-price-row">
                <span class="price-label">价格</span>
                <span class="price-symbol">¥</span>
                <span class="price-value">{{ formatPrice(item.price) }}</span>
                <span class="price-unit">/晚</span>
              </div>
              <div class="card-actions">
                <a-button type="primary" class="order-btn" @click.stop="handleOrderNow(item)">
                  <span class="btn-icon">📅</span>
                  立即预订
                </a-button>
                <a-button class="remove-btn" @click.stop="handleRemove(item)">
                  <span class="btn-icon">🗑️</span>
                  移除
                </a-button>
              </div>
            </div>
          </div>
        </div>

        <div v-else-if="!pageData.loading" class="empty-state">
          <div class="empty-icon">💝</div>
          <div class="empty-title">暂无收藏房源</div>
          <div class="empty-desc">快去浏览心仪的民宿，点击收藏吧！</div>
          <a-button type="primary" @click="goExplore">探索房源</a-button>
        </div>
      </a-spin>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { message, Modal } from 'ant-design-vue';
import { userCollectListApi, unCollectApi } from '/@/api/thingCollect'
import { useUserStore } from "/@/store";
import { BASE_URL, USER_ID } from '/@/store/constants';

const router = useRouter();
const userStore = useUserStore();

const searchKeyword = ref('');

const pageData = reactive({
  collectData: [],
  loading: false
});

const filteredData = computed(() => {
  if (!searchKeyword.value.trim()) {
    return pageData.collectData;
  }
  const keyword = searchKeyword.value.toLowerCase();
  return pageData.collectData.filter((item: any) => {
    const title = (item.title || '').toLowerCase();
    const city = (item.city || '').toLowerCase();
    const address = (item.address || '').toLowerCase();
    return title.includes(keyword) || city.includes(keyword) || address.includes(keyword);
  });
});

const displayLocation = (item: any) => {
  const city = item.city || '';
  const address = item.address || '';
  if (city && address) {
    return `${city} · ${address}`;
  }
  return city || address || '未知位置';
};

const formatPrice = (price: any) => {
  const num = Number(price || 0);
  return Number.isFinite(num) ? num.toFixed(2) : '0.00';
};

const handleOrderNow = (record: any) => {
  const thingId = record.thingId || record.id
  const defaultCheckin = new Date()
  defaultCheckin.setDate(defaultCheckin.getDate() + 1)
  const defaultCheckout = new Date()
  defaultCheckout.setDate(defaultCheckout.getDate() + 2)
  const fmt = (d: Date) => `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
  router.push({
    name: 'confirm',
    query: {
      id: thingId,
      title: record.title,
      cover: record.cover,
      price: record.price,
      checkinDate: fmt(defaultCheckin),
      checkoutDate: fmt(defaultCheckout),
    },
  })
};

const getCurrentUserId = () => {
  const id = Number(userStore.user_id || localStorage.getItem(USER_ID) || 0)
  return Number.isFinite(id) ? id : 0
};

const goExplore = () => {
  router.push({ name: 'portal' });
};

onMounted(() => {
  getCollectThingList()
});

const handleClickItem = (record: any) => {
  const thingId = record.thingId || record.id
  let text = router.resolve({ name: 'detail', query: { id: thingId } })
  window.open(text.href, '_blank')
};

const handleRemove = (record: any) => {
  Modal.confirm({
    title: '确认移除',
    content: '确定要将该房源从收藏列表中移除吗？',
    okText: '确认移除',
    cancelText: '取消',
    okType: 'danger',
    onOk() {
      const thingId = record.thingId || record.id
      return unCollectApi({ id: thingId, thingId: thingId }).then(res => {
        message.success('移除成功');
        getCollectThingList();
      }).catch(err => {
        console.log(err);
        message.error('移除失败，请重试');
      });
    }
  });
};

const resolveCover = (cover: string | undefined) => {
  if (!cover) return '/images/demo.jpg'
  if (cover.startsWith('http://') || cover.startsWith('https://')) {
    return cover.replace(/^http:/, 'https:')
  }
  if (cover.startsWith('/')) {
    return cover
  }
  return BASE_URL + '/profile/' + cover
};

const getCollectThingList = () => {
  const userId = getCurrentUserId()
  if (!userId) {
    message.warn('请先登录后再查看收藏。')
    router.push({ name: 'login' })
    return
  }
  pageData.loading = true;
  userCollectListApi({ userId: userId }).then(res => {
    const rows = Array.isArray(res?.data) ? res.data : []
    rows.forEach((item: any) => {
      item.cover = resolveCover(item.cover)
      if (!item.thingId) {
        item.thingId = item.id
      }
    })
    pageData.collectData = rows
  }).catch(err => {
    pageData.collectData = []
    const errMsg = err?.msg || err?.message || '加载收藏失败'
    if (errMsg.includes('认证失败') || errMsg.includes('无法访问')) {
      message.warn('登录已过期，请重新登录。')
      router.push({ name: 'login' })
    } else {
      message.error(errMsg)
    }
  }).finally(() => {
    pageData.loading = false;
  });
};
</script>
<style scoped lang="less">
.collect-page {
  min-height: calc(100vh - 180px);
  background: linear-gradient(135deg, #f8fafc 0%, #e8f4f8 100%);
  padding: 24px;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 20px 24px;
  background: #fff;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
}

.header-left {
  display: flex;
  align-items: baseline;
  gap: 12px;
}

.page-title {
  margin: 0;
  font-size: 24px;
  font-weight: 700;
  color: #0f172a;
}

.collect-count {
  color: #64748b;
  font-size: 14px;
}

.header-right {
  display: flex;
  align-items: center;
  gap: 12px;
}

.collect-content {
  background: #fff;
  border-radius: 12px;
  padding: 24px;
  box-shadow: 0 2px 8px rgba(15, 23, 42, 0.06);
}

.collect-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
}

.collect-card {
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  overflow: hidden;
  background: #fff;
  transition: all 0.3s ease;
  cursor: pointer;
}

.collect-card:hover {
  border-color: #5f8ff7;
  box-shadow: 0 8px 24px rgba(15, 23, 42, 0.12);
  transform: translateY(-4px);
}

.card-cover {
  position: relative;
  height: 180px;
  overflow: hidden;
}

.card-cover img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.4s ease;
}

.collect-card:hover .card-cover img {
  transform: scale(1.08);
}

.cover-overlay {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background: rgba(15, 23, 42, 0.4);
  display: flex;
  align-items: center;
  justify-content: center;
  opacity: 0;
  transition: opacity 0.3s ease;
}

.collect-card:hover .cover-overlay {
  opacity: 1;
}

.view-detail {
  color: #fff;
  font-size: 14px;
  font-weight: 600;
  padding: 8px 20px;
  border: 2px solid #fff;
  border-radius: 24px;
  background: rgba(255, 255, 255, 0.1);
}

.card-badge {
  position: absolute;
  top: 12px;
  right: 12px;
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 4px 10px;
  background: rgba(255, 255, 255, 0.95);
  border-radius: 20px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
}

.star-icon {
  color: #f5a623;
  font-size: 14px;
}

.rating-value {
  color: #0f172a;
  font-size: 13px;
  font-weight: 600;
}

.card-body {
  padding: 16px;
}

.card-title {
  margin: 0 0 10px 0;
  font-size: 16px;
  font-weight: 600;
  color: #0f172a;
  line-height: 1.4;
  overflow: hidden;
  text-overflow: ellipsis;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
}

.card-location {
  display: flex;
  align-items: center;
  gap: 6px;
  margin-bottom: 12px;
  color: #64748b;
  font-size: 13px;
}

.location-icon {
  font-size: 14px;
}

.location-text {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.card-price-row {
  display: flex;
  align-items: baseline;
  gap: 2px;
  margin-bottom: 16px;
}

.price-label {
  color: #64748b;
  font-size: 13px;
  margin-right: 8px;
}

.price-symbol {
  color: #ef4444;
  font-size: 14px;
  font-weight: 600;
}

.price-value {
  color: #ef4444;
  font-size: 22px;
  font-weight: 700;
}

.price-unit {
  color: #64748b;
  font-size: 13px;
  margin-left: 2px;
}

.card-actions {
  display: flex;
  gap: 10px;
}

.order-btn,
.remove-btn {
  flex: 1;
  height: 36px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
}

.order-btn {
  background: #1552d6;
  border-color: #1552d6;
  color: #fff;
}

.order-btn:hover {
  background: #0f45b6;
  border-color: #0f45b6;
}

.remove-btn {
  background: #fff;
  border: 1px solid #e5e7eb;
  color: #64748b;
}

.remove-btn:hover {
  border-color: #ef4444;
  color: #ef4444;
  background: #fef2f2;
}

.btn-icon {
  font-size: 14px;
}

.empty-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
}

.empty-icon {
  font-size: 64px;
  margin-bottom: 16px;
}

.empty-title {
  font-size: 18px;
  font-weight: 600;
  color: #0f172a;
  margin-bottom: 8px;
}

.empty-desc {
  font-size: 14px;
  color: #64748b;
  margin-bottom: 24px;
}

@media (max-width: 1024px) {
  .collect-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 768px) {
  .collect-page {
    padding: 16px;
  }

  .page-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 16px;
    padding: 16px;
  }

  .header-right {
    width: 100%;
  }

  .collect-grid {
    grid-template-columns: 1fr;
  }

  .card-cover {
    height: 200px;
  }
}
</style>
