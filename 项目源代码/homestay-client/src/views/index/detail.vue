<template>
  <div class="detail-page">
    <Header />

    <div class="detail-wrap">
      <section class="hero-card">
        <div class="cover-box">
          <img class="cover-img" :src="detailData.cover || '/images/demo.jpg'" alt="房源封面" />
        </div>

        <div class="hero-main">
          <h2 class="title">{{ detailData.title || '民宿详情' }}</h2>

          <div class="meta-row">
            <span class="meta-item">城市：{{ displayCity }}</span>
            <span class="meta-item">地址：{{ fullAddress || '-' }}</span>
          </div>

          <div class="price-row">
            <span class="label">价格：</span>
            <span class="price-symbol">￥</span>
            <span v-if="detailLoading" class="price loading-text">加载中...</span>
            <span v-else class="price">{{ formatPrice(detailData.price) }}</span>
            <span class="unit">/晚</span>
          </div>

          <div class="status-row">
            <span class="status-chip" :class="auditClass">{{ auditText }}</span>
            <span class="status-chip" :class="publishClass">{{ publishText }}</span>
            <span class="status-chip" :class="cleanClass">{{ cleanText }}</span>
          </div>

          <p class="desc">{{ detailData.description || '暂无房源描述。' }}</p>

          <div class="action-row">
            <button class="action-btn primary" :disabled="detailLoading" @click="handleOrder">立即预订</button>
            <button class="action-btn secondary" @click="toggleCollect">
              <span class="icon" :class="{ active: collected }">{{ collected ? '[+]' : '[ ]' }}</span>
              {{ collected ? '已收藏' : '收藏' }}
            </button>
            <button class="action-btn secondary" @click="contactLandlord">联系房东</button>
          </div>
        </div>
      </section>

      <section class="section-card booking-section">
        <div class="section-head">
          <h3>预订日历</h3>
          <span class="sub-text">请根据房态选择入住和离店日期。</span>
        </div>

        <div class="booking-picker-row">
          <a-range-picker
            v-model:value="bookingRange"
            value-format="YYYY-MM-DD"
            :allow-clear="false"
            :disabled-date="isDisabledBookingDate"
            :placeholder="['入住日期', '离店日期']"
          />
          <a-button size="small" :loading="calendarLoading" @click="loadRoomCalendar">刷新日历</a-button>
        </div>

        <div class="booking-summary">
          <span>晚数：{{ selectedNights }}</span>
          <span>预估总价：￥{{ estimatedTotalPrice }}</span>
          <span v-if="bookingRange.length === 2">日期区间：{{ bookingRange[0] }} 至 {{ bookingRange[1] }}</span>
        </div>

        <div class="calendar-legend">
          <span class="legend-item available">可订</span>
          <span class="legend-item locked">锁定</span>
          <span class="legend-item booked">已订</span>
          <span class="legend-item disabled">禁用</span>
        </div>

        <div v-if="calendarLoading" class="calendar-loading">
          <a-spin size="small" />
          <span>日历加载中...</span>
        </div>

        <div v-else-if="calendarRows.length" class="calendar-grid">
          <div class="calendar-cell" v-for="item in calendarRows" :key="item.bizDateText" :class="calendarStatusClass(item.status)">
            <div class="calendar-date">{{ item.bizDateText }}</div>
            <div class="calendar-status">{{ calendarStatusText(item.status) }}</div>
            <div class="calendar-price">￥{{ formatPrice(item.price || detailData.price) }}</div>
          </div>
        </div>

        <div v-else class="empty">暂无日历数据。</div>
      </section>

      <section class="section-card map-section">
        <div class="section-head">
          <h3>地图与导航</h3>
          <div class="map-actions">
            <a class="map-link" :href="amapUrl" target="_blank" rel="noreferrer">在高德地图中打开</a>
            <button class="expand-btn" @click="toggleMapExpand">{{ mapExpanded ? '收起地图' : '展开地图' }}</button>
          </div>
        </div>

        <div class="map-grid" :class="{ expanded: mapExpanded }">
          <div class="map-box" :class="{ expanded: mapExpanded }">
            <div ref="mapContainer" class="map-container" :class="{ expanded: mapExpanded }"></div>
            <div class="map-controls">
              <button class="control-btn" @click="zoomIn">+</button>
              <button class="control-btn" @click="zoomOut">-</button>
              <button class="control-btn" @click="resetMap">重置</button>
            </div>
            <div class="map-tip">
              <span>当前位置：{{ fullAddress || detailData.title }}</span>
              <span v-if="detailData.latitude && detailData.longitude">经纬度：{{ detailData.latitude }}°, {{ detailData.longitude }}°</span>
            </div>
          </div>

          <div class="nearby-box">
            <div class="nearby-tabs">
              <button class="tab-btn" :class="{ active: nearbyTab === 'poi' }" @click="nearbyTab = 'poi'">周边地点</button>
              <button class="tab-btn" :class="{ active: nearbyTab === 'route' }" @click="nearbyTab = 'route'">路线规划</button>
            </div>

            <div v-if="nearbyTab === 'poi'">
              <div class="nearby-title">周边配套（点击目的地查看路线）</div>
              <div class="nearby-list">
                <div class="nearby-item" v-for="(item, idx) in poiList" :key="idx" @click="showRouteTo(item)">
                  <div class="nearby-main">
                    <div class="nearby-name">{{ item.name }}</div>
                    <div class="nearby-tag">{{ item.type }}</div>
                  </div>
                  <div class="nearby-distance">{{ item.distance }}m</div>
                  <div class="nearby-nav">路线</div>
                </div>
                <div v-if="!poiList.length" class="empty-tip">点击"搜索周边"加载地点</div>
              </div>
              <div class="nearby-search">
                <input v-model="searchKeyword" placeholder="搜索周边地点（如：餐厅、地铁站）" class="search-input" @keyup.enter="searchNearby" />
                <button class="search-btn" @click="searchNearby">搜索</button>
              </div>
            </div>

            <div v-else>
              <div class="nearby-title">驾车路线规划</div>
              <div id="route-panel" class="route-panel">
                <div v-if="!routeInfo" class="empty-tip">点击下方地点选择目的地查看路线</div>
                <div v-else>
                  <div class="route-summary">
                    <span>距离：{{ routeInfo.distance }}</span>
                    <span>时间：{{ routeInfo.time }}</span>
                    <span>费用：{{ routeInfo.tolls }}</span>
                  </div>
                  <div class="route-steps">
                    <div class="route-step" v-for="(step, idx) in routeInfo.steps" :key="idx">
                      <span class="step-idx">{{ idx + 1 }}</span>
                      <span class="step-text">{{ step.instruction }}</span>
                      <span class="step-dist">{{ step.distance }}</span>
                    </div>
                  </div>
                </div>
              </div>
              <button class="clear-route-btn" @click="clearRoute">清除路线</button>
            </div>
          </div>
        </div>
      </section>

      <section class="section-card">
        <div class="section-head">
          <h3>推荐房源</h3>
          <span class="sub-text">本城市内热门且口碑较高的房源。</span>
        </div>

        <div class="recommend-grid" v-if="recommendData.length">
          <article class="recommend-card" v-for="item in recommendData" :key="item.id" @click="openDetail(item)">
            <img class="recommend-cover" :src="item.cover || '/images/demo.jpg'" alt="推荐房源封面" />
            <div class="recommend-info">
              <div class="recommend-title">{{ item.title || '未命名房源' }}</div>
              <div class="recommend-city">{{ mapCityToCn(item.city) || '-' }}</div>
              <div class="recommend-price">￥{{ formatPrice(item.price) }}/晚</div>
            </div>
          </article>
        </div>

        <div class="empty" v-else>暂无推荐房源。</div>
      </section>
    </div>

    <Footer />
    
    <!-- AI 智能对话窗口 -->
    <AiChatWindow :homestay-id="Number(route.query.id || 0)" />
  </div>
</template>

<script setup>
  import { computed, onMounted, onUnmounted, ref, nextTick } from 'vue';
  import { message } from 'ant-design-vue';
  import { useRoute, useRouter } from 'vue-router';
  import Header from '/@/views/index/components/header.vue';
  import Footer from '/@/views/index/components/footer.vue';
  import AiChatWindow from '/@/views/index/components/AiChatWindow.vue';
  import { detailApi, listApi as listThingList } from '/@/api/thing';
  import { listCalendarApi } from '/@/api/calendar';
  import { collectApi, unCollectApi, isCollectedApi } from '/@/api/thingCollect';
  import { wishApi, unWishApi } from '/@/api/thingWish';
  import { sendApi } from '/@/api/chat';
  import { useUserStore } from '/@/store';
  import { BASE_URL, USER_ID, USER_TOKEN } from '/@/store/constants';
  import AMapLoader from '@amap/amap-jsapi-loader';
  import { AMAP_CONFIG } from '/@/config';

  const BOOKABLE_STATUS = '0';

  const router = useRouter();
  const route = useRoute();
  const userStore = useUserStore();

  const thingId = ref('');
  const detailData = ref({});
  const detailLoading = ref(true);
  const recommendData = ref([]);
  const collected = ref(false);
  const wished = ref(false);
  const bookingRange = ref([]);
  const calendarRows = ref([]);
  const calendarLoading = ref(false);
  
  const mapContainer = ref(null);
  const mapInstance = ref(null);
  const mapExpanded = ref(false);
  const searchKeyword = ref('');
  const currentMarker = ref(null);
  const infoWindow = ref(null);
  const nearbyTab = ref('poi');
  const poiList = ref([]);
  const routeInfo = ref(null);
  const poiMarkers = ref([]);
  const routeLine = ref(null);
  let placeSearch = null;
  let driving = null;

  const cityMap = {
    Guangzhou: '广州',
    Shenzhen: '深圳',
    Beijing: '北京',
    Shanghai: '上海',
  };

  const displayCity = computed(() => mapCityToCn(detailData.value.city));
  const fullAddress = computed(() => {
    const city = displayCity.value || '';
    const address = String(detailData.value.address || '').trim();
    return [city, address].filter(Boolean).join(' ');
  });

  const amapUrl = computed(() => {
    const keyword = encodeURIComponent(fullAddress.value || detailData.value.title || '民宿');
    const lng = detailData.value.longitude;
    const lat = detailData.value.latitude;
    if (lng && lat) {
      return `https://ditu.amap.com/detail/?lng=${lng}&lat=${lat}&name=${keyword}`;
    }
    return `https://ditu.amap.com/search/?query=${keyword}`;
  });

  const navigationUrl = computed(() => {
    const lng = detailData.value.longitude;
    const lat = detailData.value.latitude;
    const keyword = encodeURIComponent(fullAddress.value || detailData.value.title || '民宿');
    if (lng && lat) {
      return `https://uri.amap.com/navigation?to=${lng},${lat},${keyword}&mode=car&coordinate=gaode`;
    }
    return `https://uri.amap.com/navigation?to=${keyword}&mode=car`;
  });

  const roomCalendarMap = computed(() => {
    const map = {};
    calendarRows.value.forEach((item) => {
      map[item.bizDateText] = item;
    });
    return map;
  });

  const selectedNights = computed(() => {
    if (!Array.isArray(bookingRange.value) || bookingRange.value.length !== 2) {
      return 0;
    }
    return getDateDiffNights(bookingRange.value[0], bookingRange.value[1]);
  });

  const estimatedTotalPrice = computed(() => {
    if (selectedNights.value <= 0 || bookingRange.value.length !== 2) {
      return '0.00';
    }
    let total = 0;
    for (let i = 0; i < selectedNights.value; i += 1) {
      const dateText = addDays(bookingRange.value[0], i);
      const dayPrice = Number(roomCalendarMap.value[dateText]?.price ?? detailData.value.price ?? 0);
      total += Number.isFinite(dayPrice) ? dayPrice : 0;
    }
    return total.toFixed(2);
  });

  const auditText = computed(() => {
    const status = String(detailData.value.auditStatus ?? '');
    if (status === '1') return '审核通过';
    if (status === '2') return '审核驳回';
    return '待审核';
  });

  const auditClass = computed(() => {
    const status = String(detailData.value.auditStatus ?? '');
    if (status === '1') return 'success';
    if (status === '2') return 'danger';
    return 'warning';
  });

  const publishText = computed(() => {
    const status = String(detailData.value.publishStatus ?? '');
    if (status === '1') return '已上架';
    if (status === '2') return '已下架';
    return '草稿';
  });

  const publishClass = computed(() => {
    const status = String(detailData.value.publishStatus ?? '');
    if (status === '1') return 'success';
    if (status === '2') return 'info';
    return 'warning';
  });

  const cleanText = computed(() => {
    const status = String(detailData.value.cleaningStatus ?? '');
    if (status === '2') return '可入住';
    if (status === '1') return '清扫中';
    return '待保洁';
  });

  const cleanClass = computed(() => {
    const status = String(detailData.value.cleaningStatus ?? '');
    if (status === '2') return 'success';
    if (status === '1') return 'warning';
    return 'danger';
  });

  onMounted(async () => {
    const routeId = Array.isArray(route.query.id) ? route.query.id[0] : route.query.id;
    thingId.value = String(routeId || '').trim();
    if (!thingId.value) {
      message.warn('缺少房源编号，正在返回首页。');
      router.push({ name: 'portal' });
      return;
    }

    // 【性能优化】先加载详情，其他数据并发加载
    getThingDetail(); // 不阻塞，立即开始
    
    // 延迟加载非关键数据
    setTimeout(() => {
      Promise.allSettled([getRecommendThing(), loadCollectWishState()]);
    }, 100);
    
    // 延迟加载地图（地图API较慢）
    setTimeout(() => {
      loadRoomCalendar();
      nextTick(() => initAmap());
    }, 300);
  });

  onUnmounted(() => {
    clearPoiMarkers();
    if (routeLine.value) mapInstance.value?.remove(routeLine.value);
    if (mapInstance.value) {
      mapInstance.value.destroy();
      mapInstance.value = null;
    }
  });

  function initAmap() {
    if (!mapContainer.value || mapInstance.value) return;
    const lng = Number(detailData.value.longitude);
    const lat = Number(detailData.value.latitude);
    if (!lng || !lat) return;

    window._AMapSecurityConfig = {
      securityJsCode: AMAP_CONFIG.securityJsCode,
    };
    AMapLoader.load({
      key: AMAP_CONFIG.key,
      version: AMAP_CONFIG.version,
      plugins: ['AMap.Scale', 'AMap.ToolBar', 'AMap.PlaceSearch', 'AMap.Driving'],
    }).then((AMap) => {
      mapInstance.value = new AMap.Map(mapContainer.value, {
        viewMode: '3D',
        zoom: 15,
        center: [lng, lat],
      });
      const marker = new AMap.Marker({ position: [lng, lat] });
      mapInstance.value.add(marker);
      currentMarker.value = marker;
      const title = detailData.value.title || '民宿';
      const info = new AMap.InfoWindow({
        content: `<div style="padding:4px;font-size:13px;">${title}</div>`,
        offset: new AMap.Pixel(0, -30)
      });
      info.open(mapInstance.value, [lng, lat]);
      infoWindow.value = info;

      placeSearch = new AMap.PlaceSearch({ city: displayCity.value, pageSize: 12 });
      driving = new AMap.Driving({ policy: AMap.DrivingPolicy.LEAST_TIME });

      loadNearbyPOI(AMap);
    }).catch((e) => {
      console.error('高德地图加载失败:', e);
      message.error('地图加载失败，请检查网络或Key配置');
    });
  }

  function loadNearbyPOI(AMap) {
    const lng = Number(detailData.value.longitude);
    const lat = Number(detailData.value.latitude);
    if (!lng || !lat) return;
    placeSearch.searchNearBy('', [lng, lat], 1000, (status, result) => {
      if (status === 'complete' && result.poiList) {
        poiList.value = result.poiList.pois.slice(0, 8).map(p => ({
          name: p.name,
          type: p.type || '地点',
          distance: Math.round(p.distance),
          location: p.location,
        }));
      }
    });
  }

  function searchNearby() {
    if (!searchKeyword.value.trim()) { message.warn('请输入搜索关键词'); return; }
    clearPoiMarkers();
    clearRoute();
    const lng = Number(detailData.value.longitude);
    const lat = Number(detailData.value.latitude);
    if (!lng || !lat || !placeSearch || !mapInstance.value) { message.error('地图未加载完成'); return; }

    placeSearch.searchNearBy(searchKeyword.value.trim(), [lng, lat], 3000, (status, result) => {
      if (status === 'complete' && result.poiList) {
        const AMap = window.AMap;
        poiList.value = result.poiList.pois.slice(0, 10).map(p => ({
          name: p.name, type: p.type || '地点', distance: Math.round(p.distance), location: p.location,
        }));
        const markers = result.poiList.pois.slice(0, 10).map(p => {
          const mkr = new AMap.Marker({ position: p.location, map: mapInstance.value, label: { content: p.name, direction: 'top' } });
          return mkr;
        });
        poiMarkers.value = markers;
        mapInstance.value.setFitView(null, false, [100, 100, 100, 100]);
      } else {
        message.info('未找到相关地点');
      }
    });
  }

  function showRouteTo(item) {
    if (!driving || !mapInstance.value) return;
    clearRoute();
    const from = [Number(detailData.value.longitude), Number(detailData.value.latitude)];
    const to = [item.location.lng, item.location.lat];
    driving.search(from, to, (status, result) => {
      if (status === 'complete') {
        const routes = result.routes[0];
        const path = [];
        routes.steps.forEach(s => {
          s.road && path.push(...s.path);
          s.path && path.push(...s.path);
        });
        routeLine.value = new window.AMap.Polyline({
          path, strokeWeight: 6, strokeColor: '#1677ff', strokeOpacity: 0.8, lineJoin: 'round',
          map: mapInstance.value,
        });
        const steps = routes.steps.map((s, i) => ({
          instruction: s.instruction.replace(/<[^>]+>/g, ''),
          distance: (s.distance / 1000).toFixed(1) + 'km',
        }));
        routeInfo.value = {
          distance: (routes.distance / 1000).toFixed(1) + 'km',
          time: Math.round(routes.time / 60) + '分钟',
          tolls: '¥' + (routes.tolls || 0),
          steps,
        };
        nearbyTab.value = 'route';
        mapInstance.value.setFitView(null, false, [100, 100, 100, 100]);
      } else {
        message.error('路线规划失败');
      }
    });
  }

  function clearRoute() {
    if (routeLine.value) { mapInstance.value?.remove(routeLine.value); routeLine.value = null; }
    routeInfo.value = null;
  }

  function clearPoiMarkers() {
    poiMarkers.value.forEach(m => mapInstance.value?.remove(m));
    poiMarkers.value = [];
  }

  function zoomIn() {
    if (mapInstance.value) mapInstance.value.zoomIn();
  }

  function zoomOut() {
    if (mapInstance.value) mapInstance.value.zoomOut();
  }

  function resetMap() {
    if (!mapInstance.value) return;
    const lng = Number(detailData.value.longitude);
    const lat = Number(detailData.value.latitude);
    if (lng && lat) {
      mapInstance.value.setZoomAndCenter(15, [lng, lat]);
    }
    clearRoute();
    clearPoiMarkers();
    poiList.value = [];
  }

  function toggleMapExpand() {
    mapExpanded.value = !mapExpanded.value;
    nextTick(() => {
      if (mapInstance.value) mapInstance.value.resize();
    });
  }

  function mapCityToCn(city) {
    if (!city) return '-';
    return cityMap[String(city)] || String(city);
  }

  function getCurrentUserId() {
    return Number(userStore.user_id || localStorage.getItem(USER_ID) || 0);
  }

  function formatPrice(value) {
    const num = Number(value || 0);
    if (!Number.isFinite(num)) return '0.00';
    return num.toFixed(2);
  }

  function formatDateYMD(value) {
    const date = value instanceof Date ? new Date(value) : new Date(value);
    if (Number.isNaN(date.getTime())) return '';
    const y = date.getFullYear();
    const m = `${date.getMonth() + 1}`.padStart(2, '0');
    const d = `${date.getDate()}`.padStart(2, '0');
    return `${y}-${m}-${d}`;
  }

  function addDays(startDateText, offset) {
    const base = new Date(`${startDateText}T00:00:00`);
    if (Number.isNaN(base.getTime())) return '';
    base.setDate(base.getDate() + Number(offset || 0));
    return formatDateYMD(base);
  }

  function getDateDiffNights(startDateText, endDateText) {
    const start = new Date(`${startDateText}T00:00:00`);
    const end = new Date(`${endDateText}T00:00:00`);
    if (Number.isNaN(start.getTime()) || Number.isNaN(end.getTime())) return 0;
    const diff = end.getTime() - start.getTime();
    return diff > 0 ? Math.floor(diff / (24 * 60 * 60 * 1000)) : 0;
  }

  function resolveCover(cover) {
    const raw = String(cover || '').trim();
    if (!raw) return '/images/demo.jpg';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:');
    if (raw.startsWith('//')) return 'https:' + raw;
    if (raw.startsWith('/')) return raw;
    return `${BASE_URL}/profile/${raw}`;
  }

  function normalizeThing(item) {
    if (!item) return {};
    return {
      ...item,
      price: item.basePrice ?? item.price ?? 0,
      cover: resolveCover(item.cover),
    };
  }

  function normalizeCalendarRow(item) {
    const dateText = String(item?.bizDateText || formatDateYMD(item?.bizDate) || '');
    return {
      ...item,
      bizDateText: dateText,
      status: String(item?.status ?? ''),
      price: Number(item?.price ?? detailData.value.price ?? 0),
    };
  }

  function toThingIdSet(list) {
    const result = new Set();
    (list || []).forEach((item) => {
      const id = Number(item?.thingId ?? item?.homestayId ?? item?.id);
      if (Number.isFinite(id) && id > 0) {
        result.add(id);
      }
    });
    return result;
  }

  async function getThingDetail() {
    detailLoading.value = true;
    const startTime = performance.now();
    try {
      const res = await detailApi({ id: thingId.value });
      detailData.value = normalizeThing(res.data || {});
      console.log(`[性能] 详情加载耗时: ${Math.round(performance.now() - startTime)}ms`);
    } catch (_error) {
      message.error('房源详情加载失败。');
    } finally {
      detailLoading.value = false;
    }
  }

  async function getRecommendThing() {
    try {
      const res = await listThingList({ pageNum: 1, pageSize: 8, sort: 'recommend' });
      const list = (res.data || []).map((item) => normalizeThing(item));
      recommendData.value = list.filter((item) => String(item.id) !== String(thingId.value)).slice(0, 6);
    } catch (_error) {
      recommendData.value = [];
    }
  }

  async function loadCollectWishState() {
    const userId = getCurrentUserId();
    if (!userId) {
      collected.value = false;
      wished.value = false;
      return;
    }

    try {
      const res = await isCollectedApi(userId, Number(thingId.value));
      collected.value = !!res?.data;
      wished.value = false;
    } catch (_error) {
      // ignore
    }
  }

  async function loadRoomCalendar() {
    if (!thingId.value) return;
    calendarLoading.value = true;

    try {
      const today = formatDateYMD(new Date());
      const end = addDays(today, 90);
      const res = await listCalendarApi(thingId.value, today, end);

      const rows = (res?.data || [])
        .map((item) => normalizeCalendarRow(item))
        .filter((item) => item.bizDateText)
        .sort((a, b) => String(a.bizDateText).localeCompare(String(b.bizDateText)));

      calendarRows.value = rows;
      setDefaultBookingRange();
    } catch (error) {
      calendarRows.value = [];
      message.error(error?.msg || '房态日历加载失败。');
    } finally {
      calendarLoading.value = false;
    }
  }

  function setDefaultBookingRange() {
    if (bookingRange.value.length === 2 && isDateRangeBookable(bookingRange.value[0], bookingRange.value[1])) {
      return;
    }

    for (let i = 0; i < calendarRows.value.length - 1; i += 1) {
      const curr = calendarRows.value[i];
      const next = calendarRows.value[i + 1];
      if (curr.status !== BOOKABLE_STATUS || next.status !== BOOKABLE_STATUS) {
        continue;
      }
      if (addDays(curr.bizDateText, 1) === next.bizDateText) {
        bookingRange.value = [curr.bizDateText, next.bizDateText];
        return;
      }
    }

    bookingRange.value = [];
  }

  function calendarStatusText(status) {
    if (status === '0') return '可订';
    if (status === '1') return '锁定';
    if (status === '2') return '已订';
    if (status === '3') return '禁用';
    return '未知';
  }

  function calendarStatusClass(status) {
    if (status === '0') return 'available';
    if (status === '1') return 'locked';
    if (status === '2') return 'booked';
    if (status === '3') return 'disabled';
    return 'disabled';
  }

  function toDateTextFromPicker(inputDate) {
    if (!inputDate) return '';
    if (typeof inputDate === 'string') return inputDate;
    if (typeof inputDate.format === 'function') return inputDate.format('YYYY-MM-DD');
    if (inputDate.$d) return formatDateYMD(inputDate.$d);
    return formatDateYMD(inputDate);
  }

  function isDisabledBookingDate(currentDate) {
    const dateText = toDateTextFromPicker(currentDate);
    if (!dateText) return true;

    const todayText = formatDateYMD(new Date());
    if (dateText < todayText) return true;

    const dayInfo = roomCalendarMap.value[dateText];
    if (!dayInfo) return false;

    return String(dayInfo.status) !== BOOKABLE_STATUS;
  }

  function isDateRangeBookable(checkinDate, checkoutDate) {
    const nights = getDateDiffNights(checkinDate, checkoutDate);
    if (nights <= 0) return false;

    if (calendarRows.value.length === 0) {
      return true;
    }

    for (let i = 0; i < nights; i += 1) {
      const day = addDays(checkinDate, i);
      const item = roomCalendarMap.value[day];
      if (item && String(item.status) !== BOOKABLE_STATUS) {
        return false;
      }
    }

    return true;
  }

  function toggleCollect() {
    const userId = getCurrentUserId();
    if (!userId) {
      message.warn('请先登录后再操作。');
      router.push({ name: 'login' });
      return;
    }

    const params = { thingId: thingId.value, id: thingId.value, userId };
    const request = collected.value ? unCollectApi(params) : collectApi(params);
    request
      .then(() => {
        collected.value = !collected.value;
        message.success(collected.value ? '收藏成功。' : '已取消收藏。');
      })
      .catch((err) => {
        const errMsg = err?.msg || err?.message || '';
        if (errMsg.includes('认证失败') || errMsg.includes('无法访问')) {
          message.warn('登录已过期，请重新登录。');
          router.push({ name: 'login' });
        } else {
          message.error(collected.value ? '取消收藏失败。' : '收藏失败。');
        }
      });
  }

  function toggleWish() {
    const userId = getCurrentUserId();
    if (!userId) {
      message.warn('请先登录后再操作。');
      router.push({ name: 'login' });
      return;
    }

    const params = { thingId: thingId.value, id: thingId.value, userId };
    const request = wished.value ? unWishApi(params) : wishApi(params);
    request
      .then(() => {
        wished.value = !wished.value;
        message.success(wished.value ? '已加入想住清单。' : '已移出想住清单。');
      })
      .catch(() => {
        message.error(wished.value ? '移出想住清单失败。' : '加入想住清单失败。');
      });
  }

  async function handleOrder() {
    if (!detailData.value.id) {
      message.warn('房源信息尚未就绪。');
      return;
    }

    if (!Array.isArray(bookingRange.value) || bookingRange.value.length !== 2) {
      message.warn('请选择入住和离店日期。');
      return;
    }

    const [checkinDate, checkoutDate] = bookingRange.value;
    
    await loadRoomCalendar();
    
    if (!isDateRangeBookable(checkinDate, checkoutDate)) {
      message.warn('当前日期区间已被预订或不可订，请重新选择日期。');
      return;
    }

    router.push({
      name: 'confirm',
      query: {
        id: detailData.value.id,
        checkinDate,
        checkoutDate,
      },
    });
  }

  function openDetail(item) {
    const target = router.resolve({ name: 'detail', query: { id: item.id } });
    window.open(target.href, '_blank');
  }

  function contactLandlord() {
    const token = localStorage.getItem(USER_TOKEN);
    if (!token) {
      message.warn('请先登录后再联系房东。');
      router.push({ name: 'login', query: { redirect: route.fullPath } });
      return;
    }

    const landlordUserId = Number(detailData.value.landlordUserId || detailData.value.userId || detailData.value.ownerId || 0);
    if (!landlordUserId) {
      message.warn('暂无房东信息，请稍后再试。');
      return;
    }

    router.push({ name: 'messageView', query: { tab: 'chat', peerId: landlordUserId } });
  }
</script>

<style scoped lang="less">
  .detail-wrap {
    width: 1100px;
    margin: 90px auto 32px;
    display: flex;
    flex-direction: column;
    gap: 16px;
  }

  .hero-card,
  .section-card {
    background: #fff;
    border: 1px solid #eef1f6;
    border-radius: 12px;
    padding: 18px;
  }

  .hero-card {
    display: grid;
    grid-template-columns: 320px 1fr;
    gap: 18px;
  }

  .cover-box {
    border-radius: 10px;
    overflow: hidden;
  }

  .cover-img {
    width: 100%;
    height: 240px;
    object-fit: cover;
    display: block;
  }

  .title {
    margin: 0;
    font-size: 26px;
    color: #152844;
  }

  .meta-row {
    margin-top: 10px;
    display: flex;
    flex-wrap: wrap;
    gap: 12px;
    color: #4b5563;
    font-size: 14px;
  }

  .price-row {
    margin-top: 12px;
    display: flex;
    align-items: baseline;
    gap: 3px;
  }

  .label {
    color: #334155;
    font-size: 14px;
  }

  .price-symbol {
    color: #ef4444;
    font-weight: 700;
  }

  .price {
    color: #ef4444;
    font-weight: 700;
    font-size: 30px;
  }

  .price.loading-text {
    color: #6b7280;
    font-size: 18px;
    font-weight: 400;
  }

  .unit {
    color: #6b7280;
    font-size: 13px;
  }

  .status-row {
    margin-top: 10px;
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  .status-chip {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    border-radius: 999px;
    padding: 2px 10px;
    font-size: 12px;
    border: 1px solid transparent;
  }

  .status-chip.success {
    color: #0f766e;
    border-color: #5eead4;
    background: #ccfbf1;
  }

  .status-chip.warning {
    color: #92400e;
    border-color: #fcd34d;
    background: #fef3c7;
  }

  .status-chip.danger {
    color: #b91c1c;
    border-color: #fca5a5;
    background: #fee2e2;
  }

  .status-chip.info {
    color: #334155;
    border-color: #cbd5e1;
    background: #f1f5f9;
  }

  .desc {
    margin-top: 12px;
    color: #374151;
    line-height: 1.75;
  }

  .action-row {
    margin-top: 14px;
    display: flex;
    flex-wrap: wrap;
    gap: 10px;
  }

  .action-btn {
    border: 1px solid #dbe1ea;
    background: #fff;
    color: #0f172a;
    border-radius: 8px;
    padding: 8px 14px;
    cursor: pointer;
    transition: all 0.2s;
    display: inline-flex;
    align-items: center;
    gap: 4px;
  }

  .action-btn:hover {
    border-color: #5f8ff7;
    color: #1552d6;
  }

  .action-btn.primary {
    background: #1552d6;
    border-color: #1552d6;
    color: #fff;
  }

  .action-btn.primary:hover {
    background: #0f45b6;
    border-color: #0f45b6;
    color: #fff;
  }

  .action-btn.primary:disabled {
    background: #94a3b8;
    border-color: #94a3b8;
    cursor: not-allowed;
  }

  .icon {
    font-size: 16px;
    color: #64748b;
  }

  .icon.active {
    color: #eab308;
  }

  .icon.heart.active {
    color: #ef4444;
  }

  .section-head {
    display: flex;
    justify-content: space-between;
    align-items: center;
    gap: 8px;
    flex-wrap: wrap;
    margin-bottom: 12px;
  }

  .section-head h3 {
    margin: 0;
    color: #152844;
    font-size: 18px;
  }

  .sub-text {
    color: #6b7280;
    font-size: 13px;
  }

  .booking-picker-row {
    display: flex;
    align-items: center;
    gap: 10px;
    flex-wrap: wrap;
  }

  .booking-summary {
    margin-top: 10px;
    color: #334155;
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
    font-size: 13px;
  }

  .calendar-legend {
    margin-top: 10px;
    display: flex;
    gap: 8px;
    flex-wrap: wrap;
  }

  .legend-item {
    padding: 3px 9px;
    border-radius: 999px;
    border: 1px solid transparent;
    font-size: 12px;
  }

  .legend-item.available {
    color: #166534;
    border-color: #86efac;
    background: #dcfce7;
  }

  .legend-item.locked {
    color: #92400e;
    border-color: #fcd34d;
    background: #fef3c7;
  }

  .legend-item.booked {
    color: #1d4ed8;
    border-color: #93c5fd;
    background: #dbeafe;
  }

  .legend-item.disabled {
    color: #b91c1c;
    border-color: #fca5a5;
    background: #fee2e2;
  }

  .calendar-loading {
    margin-top: 10px;
    color: #64748b;
    display: inline-flex;
    align-items: center;
    gap: 8px;
  }

  .calendar-grid {
    margin-top: 12px;
    display: grid;
    grid-template-columns: repeat(7, minmax(0, 1fr));
    gap: 8px;
  }

  .calendar-cell {
    border: 1px solid #e5e7eb;
    border-radius: 8px;
    padding: 8px;
    font-size: 12px;
    background: #fff;
  }

  .calendar-cell.available {
    border-color: #86efac;
    background: #f0fdf4;
  }

  .calendar-cell.locked {
    border-color: #fcd34d;
    background: #fffbeb;
  }

  .calendar-cell.booked {
    border-color: #93c5fd;
    background: #eff6ff;
  }

  .calendar-cell.disabled {
    border-color: #fecaca;
    background: #fef2f2;
  }

  .calendar-date {
    color: #0f172a;
    font-weight: 600;
  }

  .calendar-status {
    margin-top: 4px;
    color: #334155;
  }

  .calendar-price {
    margin-top: 4px;
    color: #0f766e;
    font-weight: 600;
  }

  .map-section {
    border-color: #d0e1fd;
    background: linear-gradient(135deg, #f8fcff 0%, #fff 100%);
  }

  .map-actions {
    display: flex;
    gap: 8px;
    align-items: center;
    flex-wrap: wrap;
  }

  .map-link {
    color: #1552d6;
    font-size: 13px;
  }

  .expand-btn {
    border: 1px solid #1677ff;
    background: #1677ff;
    color: #fff;
    border-radius: 6px;
    padding: 4px 12px;
    font-size: 12px;
    cursor: pointer;
    transition: 0.2s;
  }

  .expand-btn:hover {
    background: #0958d9;
    border-color: #0958d9;
  }

  .expand-btn {
    background: #fff;
    color: #1677ff;
  }

  .expand-btn:hover {
    background: #f0f5ff;
  }

  .map-grid {
    display: grid;
    grid-template-columns: 1.4fr 1fr;
    gap: 12px;
  }

  .map-grid.expanded {
    grid-template-columns: 1fr;
  }

  .map-box {
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
    position: relative;
  }

  .map-container {
    width: 100%;
    height: 320px;
    min-height: 320px;
  }

  .map-container.expanded {
    height: 520px;
    min-height: 520px;
  }

  .map-controls {
    position: absolute;
    top: 10px;
    right: 10px;
    display: flex;
    flex-direction: column;
    gap: 4px;
    z-index: 10;
  }

  .control-btn {
    width: 32px;
    height: 32px;
    border: 1px solid #d9d9d9;
    background: #fff;
    border-radius: 6px;
    cursor: pointer;
    font-size: 16px;
    font-weight: 700;
    color: #333;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
  }

  .control-btn:hover {
    background: #f0f5ff;
    border-color: #1677ff;
  }

  .map-tip {
    padding: 8px 12px;
    font-size: 12px;
    color: #64748b;
    background: #f8fafc;
    border-top: 1px solid #e5e7eb;
    display: flex;
    justify-content: space-between;
    flex-wrap: wrap;
    gap: 4px;
  }

  .nearby-box {
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    padding: 12px;
    display: flex;
    flex-direction: column;
    gap: 8px;
    max-height: 420px;
    overflow-y: auto;
  }

  .nearby-tabs {
    display: flex;
    gap: 4px;
    border-bottom: 1px solid #e5e7eb;
    padding-bottom: 6px;
  }

  .tab-btn {
    flex: 1;
    border: none;
    background: none;
    padding: 6px 0;
    font-size: 13px;
    color: #64748b;
    cursor: pointer;
    border-radius: 4px 4px 0 0;
  }

  .tab-btn.active {
    color: #1677ff;
    font-weight: 600;
    border-bottom: 2px solid #1677ff;
  }

  .nearby-title {
    font-size: 15px;
    font-weight: 600;
    color: #1f2937;
  }

  .nearby-list {
    display: flex;
    flex-direction: column;
    gap: 6px;
  }

  .nearby-item {
    border: 1px solid #e2e8f0;
    border-radius: 8px;
    padding: 8px 10px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    cursor: pointer;
    transition: 0.2s;
  }

  .nearby-item:hover {
    border-color: #1677ff;
    background: #f0f5ff;
  }

  .nearby-main {
    display: flex;
    flex-direction: column;
    gap: 2px;
  }

  .nearby-name {
    font-size: 14px;
    color: #0f172a;
  }

  .nearby-tag {
    font-size: 12px;
    color: #0369a1;
  }

  .nearby-distance {
    color: #334155;
    font-size: 13px;
  }

  .nearby-nav {
    color: #1677ff;
    font-size: 12px;
    font-weight: 600;
    padding: 2px 8px;
    border: 1px solid #1677ff;
    border-radius: 4px;
  }

  .nearby-nav:hover {
    background: #1677ff;
    color: #fff;
  }

  .nearby-search {
    display: flex;
    gap: 6px;
  }

  .search-input {
    flex: 1;
    border: 1px solid #d9d9d9;
    border-radius: 6px;
    padding: 6px 10px;
    font-size: 13px;
    outline: none;
  }

  .search-input:focus {
    border-color: #1677ff;
    box-shadow: 0 0 0 2px rgba(22,119,255,0.1);
  }

  .search-btn {
    border: 1px solid #1677ff;
    background: #1677ff;
    color: #fff;
    border-radius: 6px;
    padding: 4px 12px;
    cursor: pointer;
    font-size: 12px;
  }

  .search-btn:hover {
    background: #0958d9;
  }

  .empty-tip {
    color: #94a3b8;
    font-size: 13px;
    text-align: center;
    padding: 20px 0;
  }

  .route-panel {
    max-height: 280px;
    overflow-y: auto;
  }

  .route-summary {
    display: flex;
    gap: 12px;
    padding: 8px 10px;
    background: #f0f5ff;
    border-radius: 6px;
    font-size: 13px;
    color: #1f2937;
    flex-wrap: wrap;
  }

  .route-steps {
    margin-top: 8px;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .route-step {
    display: flex;
    align-items: flex-start;
    gap: 8px;
    padding: 6px 8px;
    border: 1px solid #e5e7eb;
    border-radius: 6px;
    font-size: 12px;
  }

  .step-idx {
    width: 18px;
    height: 18px;
    border-radius: 50%;
    background: #1677ff;
    color: #fff;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 11px;
    flex-shrink: 0;
  }

  .step-text {
    flex: 1;
    color: #334155;
    line-height: 1.4;
  }

  .step-dist {
    color: #94a3b8;
    font-size: 11px;
    flex-shrink: 0;
  }

  .clear-route-btn {
    border: 1px solid #ef4444;
    color: #ef4444;
    background: #fff;
    border-radius: 6px;
    padding: 4px 12px;
    font-size: 12px;
    cursor: pointer;
  }

  .clear-route-btn:hover {
    background: #fef2f2;
  }

  .recommend-grid {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 12px;
  }

  .recommend-card {
    border: 1px solid #e5e7eb;
    border-radius: 10px;
    overflow: hidden;
    cursor: pointer;
    transition: all 0.2s;
    background: #fff;
  }

  .recommend-card:hover {
    border-color: #5f8ff7;
    box-shadow: 0 8px 20px rgba(15, 23, 42, 0.08);
    transform: translateY(-2px);
  }

  .recommend-cover {
    width: 100%;
    height: 140px;
    object-fit: cover;
  }

  .recommend-info {
    padding: 10px 12px;
    display: flex;
    flex-direction: column;
    gap: 4px;
  }

  .recommend-title {
    font-size: 14px;
    color: #0f172a;
    line-height: 1.4;
    min-height: 38px;
  }

  .recommend-city {
    color: #64748b;
    font-size: 12px;
  }

  .recommend-price {
    color: #ef4444;
    font-weight: 700;
  }

  .empty {
    color: #64748b;
    font-size: 14px;
  }

  @media (max-width: 1180px) {
    .detail-wrap {
      width: calc(100% - 28px);
    }
  }

  @media (max-width: 960px) {
    .hero-card {
      grid-template-columns: 1fr;
    }

    .cover-img {
      height: 220px;
    }

    .map-grid {
      grid-template-columns: 1fr;
    }

    .recommend-grid {
      grid-template-columns: 1fr 1fr;
    }

    .calendar-grid {
      grid-template-columns: repeat(4, minmax(0, 1fr));
    }
  }

  @media (max-width: 640px) {
    .recommend-grid {
      grid-template-columns: 1fr;
    }

    .calendar-grid {
      grid-template-columns: repeat(2, minmax(0, 1fr));
    }
  }
</style>
