<template>
  <div class="content-margin">
    <h1 class="search-name-box">{{ tData.keyword }}</h1>
    <div class="search-tab-nav clearfix">
      <div class="tab-text">
        <span>与</span>
        <span class="strong">{{ tData.keyword }}</span>
        <span>相关的内容</span>
      </div>
    </div>
    <div class="content-list">
      <div class="thing-list">

        <a-spin :spinning="tData.loading" style="min-height: 200px;">
          <div class="things flex-view">
            <div class="thing-item item-column-4" v-for="item in tData.pageData" :key="item.id" @click="handleDetail(item)">
              <div class="img-view">
                <img :src="item.cover" loading="lazy"></div>
              <div class="info-view">
                <h3 class="thing-name">{{ item.title ? item.title.substring(0, 12) : '' }}</h3>
                <div class="rating-view" v-if="item.ratingAvg">
                  <span class="star">★</span>
                  <span class="rating-text">{{ item.ratingAvg }}</span>
                </div>
                <span>
                  <span class="a-price-symbol">¥</span>
                  <span class="a-price">{{ item.price }}</span>
                  <span class="a-unit">/晚</span>
                </span>
              </div>
            </div>
          </div>
        </a-spin>
        <div class="page-view" style="">
          <a-pagination v-model:value="tData.page" size="small" @change="changePage" :hideOnSinglePage="true"
                        :defaultPageSize="tData.pageSize" :total="tData.total" :showSizeChanger="false"/>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import {listApi as listThingList} from '/@/api/thing'
import {BASE_URL} from "/@/store/constants";
import {useUserStore} from "/@/store";

const userStore = useUserStore()
const router = useRouter();
const route = useRoute();

const tData = reactive({
  loading: false,
  keyword: '',
  thingData: [],
  pageData: [],

  page: 1,
  total: 0,
  pageSize: 12,
})

let searchTimer = null;

onMounted(() => {
  search()
})

watch(() => route.query, (newPath, oldPath) => {
  if (newPath?.keyword !== oldPath?.keyword) {
    search()
  }
}, { immediate: false });

const resolveCover = (cover) => {
  if (!cover) return '/images/demo.jpg'
  if (cover.startsWith('http://') || cover.startsWith('https://')) return cover.replace(/^http:/, 'https:')
  if (cover.startsWith('//')) return 'https:' + cover
  if (cover.startsWith('/profile/')) return BASE_URL + cover
  return BASE_URL + '/api/staticfiles/image/' + cover
}

const search = () => {
  const keyword = (route.query.keyword || '').toString().trim()
  if (!keyword) return
  
  tData.keyword = keyword
  tData.page = 1
  
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    getThingList({'keyword': keyword})
  }, 100)
}

const changePage = (page) => {
  tData.page = page
  getThingList({'keyword': tData.keyword, pageNum: page})
}

const handleDetail = (item) => {
  let text = router.resolve({name: 'detail', query: {id: item.id}})
  window.open(text.href, '_blank')
}

const getThingList = (data) => {
  tData.loading = true
  listThingList(data).then(res => {
    tData.pageData = (res.rows || []).map(item => ({
      ...item,
      cover: resolveCover(item.cover)
    }))
    tData.total = res.total || tData.pageData.length
    tData.loading = false
  }).catch(err => {
    console.log(err)
    tData.loading = false
  })
}

const handleImageError = (e) => {
  e.target.src = '/images/demo.jpg'
}
</script>
<style scoped lang="less">
.content-margin {
  margin: 156px 0 100px;
}

.page-view {
  width: 100%;
  text-align: center;
  margin-top: 48px;
}

.search-name-box {
  background: #f5f9fb;
  height: 100px;
  line-height: 100px;
  font-size: 20px;
  color: #152844;
  text-align: center;
  position: fixed;
  top: 56px;
  left: 0;
  z-index: 1;
  width: calc(100% - 8px);
}

.search-tab-nav {
  position: relative;
  padding: 24px 0 16px;
  text-align: center;

  .tab-text {
    float: left;
    color: #5f77a6;
    font-size: 14px;
  }

  .strong {
    color: #152844;
    font-weight: 600;
    margin: 0 4px;
  }
}

.things {
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
}

.flex-view {
  display: flex;
}

.thing-item {
  min-width: 255px;
  max-width: 255px;
  position: relative;
  flex: 1;
  margin-right: 20px;
  height: fit-content;
  overflow: hidden;
  margin-top: 26px;
  margin-bottom: 36px;
  cursor: pointer;

  .img-view {
    //text-align: center;
    height: 200px;
    width: 255px;

    img {
      height: 200px;
      width: 255px;
      margin: 0 auto;
      background-size: contain;
    }
  }

  .info-view {
    //background: #f6f9fb;
    overflow: hidden;
    padding: 0 16px;

    .thing-name {
      line-height: 32px;
      margin-top: 12px;
      color: #0F1111 !important;
      font-size: 15px !important;
      font-weight: 400 !important;
      font-style: normal !important;
      text-transform: none !important;
      text-decoration: none !important;
    }

    .price {
      color: #ff7b31;
      font-size: 20px;
      line-height: 20px;
      margin-top: 4px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .translators {
      color: #6f6f6f;
      font-size: 12px;
      line-height: 14px;
      margin-top: 4px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }
  }
}

.rating-view {
  margin-top: 4px;
  .star {
    color: #f5a623;
    font-size: 14px;
  }
  .rating-text {
    color: #6f6f6f;
    font-size: 13px;
    margin-left: 4px;
  }
}

.a-unit {
  color: #6f6f6f;
  font-size: 12px;
}

.a-price-symbol {
  top: -0.5em;
  font-size: 12px;
}

.a-price {
  color: #0F1111;
  font-size: 21px;
}

</style>
