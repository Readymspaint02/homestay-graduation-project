<template>
    <div class="content">
      <div class="content-right" style="width: 100%;">
        <div class="top-select-view flex-view">
          <div class="order-view">
            <span class="title"></span>
            <span class="tab"
                  :class="contentData.selectTabIndex===index? 'tab-select':''"
                  v-for="(item,index) in contentData.tabData"
                  :key="index"
                  @click="selectTab(index)">
              {{ item }}
            </span>
            <span :style="{left: contentData.tabUnderLeft + 'px'}" class="tab-underline"></span>
          </div>
        </div>
        <a-spin :spinning="contentData.loading" style="min-height: 200px;">
          <div class="pc-thing-list flex-view">
            <div v-for="item in contentData.pageData" :key="item.id" @click="handleDetail(item)"
                 class="thing-item item-column-3">
              <div class="img-view">
                <img :src="item.cover || '/images/demo.jpg'" @error="handleImageError"></div>
              <div class="info-view">
                <h3 class="thing-name">{{ item.title ? item.title.substring(0, 12) : '' }}</h3>
                <div class="rating-view" v-if="item.ratingAvg">
                  <span class="star">★</span>
                  <span class="rating-text">{{ item.ratingAvg }}</span>
                </div>
                <span>
                  <span class="a-price-symbol"> </span>
                  <span class="a-price">{{ item.price }}</span>
                  <span class="a-unit">/晚</span>
                </span>
              </div>
            </div>
            <div v-if="contentData.pageData.length <= 0 && !contentData.loading" class="no-data" style="">暂无数据</div>
          </div>
        </a-spin>
        <div class="page-view" style="">
          <a-pagination v-model="contentData.page" size="small" @change="changePage" :hideOnSinglePage="true"
                        :defaultPageSize="contentData.pageSize" :total="contentData.total" :showSizeChanger="false"/>
        </div>
      </div>
    </div>
</template>

<script setup>
import {listApi as listClassificationList} from '/@/api/classification'
import {listApi as listTagList} from '/@/api/tag'
import {listApi as listThingList} from '/@/api/thing'
import {BASE_URL} from "/@/store/constants";
import {useUserStore} from "/@/store";

const userStore = useUserStore()
const router = useRouter();

const categoryLabelMap = {
  Boutique: '精品民宿',
  SeaView: '海景房',
  Apartment: '公寓整租'
}

const tagLabelMap = {
  NearMetro: '近地铁',
  Kitchen: '可做饭',
  Parking: '可停车'
}

const contentData = reactive({
  selectX: 0,
  selectTagId: -1,
  cData: [],
  selectedKeys: [],
  tagData: [],
  loading: false,

  tabData: ['最新', '最热', '推荐'],
  selectTabIndex: 0,
  tabUnderLeft: 12,

  thingData: [],
  pageData: [],

  page: 1,
  total: 0,
  pageSize: 12,
})

let loadTimer = null;

onMounted(() => {
  initSider()
  getThingList({})
})

const initSider = () => {
  contentData.cData.push({key:'-1', title:'全部'})
  listClassificationList().then(res => {
    res.data.forEach(item=>{
      item.key = item.id
      if (categoryLabelMap[item.title]) {
        item.title = categoryLabelMap[item.title]
      }
      contentData.cData.push(item)
    })
  })
  listTagList().then(res => {
    res.data.forEach(item => {
      if (tagLabelMap[item.title]) {
        item.title = tagLabelMap[item.title]
      }
    })
    contentData.tagData = res.data
  })
}

const getSelectedKey = () => {
  if (contentData.selectedKeys.length > 0) {
    return contentData.selectedKeys[0]
  } else {
    return -1
  }
}
const onSelect = (selectedKeys) => {
  contentData.selectedKeys = selectedKeys
  if (contentData.selectedKeys.length > 0) {
    getThingList({c: getSelectedKey()})
  }
  contentData.selectTagId = -1
}
const clickTag = (index) => {
  contentData.selectedKeys = []
  contentData.selectTagId = index
  getThingList({tag: contentData.selectTagId})
}

const selectTab = (index) => {
  contentData.selectTabIndex = index
  contentData.tabUnderLeft = 12 + 50 * index
  let sort = (index === 0 ? 'recent' : index === 1 ? 'hot' : 'recommend')
  const data = {sort: sort}
  if (contentData.selectTagId !== -1) {
    data['tag'] = contentData.selectTagId
  } else {
    data['c'] = getSelectedKey()
  }
  getThingList(data)
}
const handleDetail = (item) => {
  let text = router.resolve({name: 'detail', query: {id: item.id}})
  window.open(text.href, '_blank')
}
const changePage = (page) => {
  contentData.page = page
  const data = {pageNum: page}
  if (contentData.selectTagId !== -1) {
    data['tag'] = contentData.selectTagId
  } else {
    data['c'] = getSelectedKey()
  }
  getThingList(data)
}
const resolveCover = (cover) => {
  if (!cover) return '/images/demo.jpg'
  if (cover.startsWith('http://') || cover.startsWith('https://')) return cover.replace(/^http:/, 'https:')
  if (cover.startsWith('//')) return 'https:' + cover
  if (cover.startsWith('/profile/')) return BASE_URL + cover
  if (cover.startsWith('/')) return cover
  return BASE_URL + '/profile/' + cover
}

const getThingList = (data) => {
  if (loadTimer) clearTimeout(loadTimer)
  contentData.loading = true
  
  // 【性能优化】减少防抖延迟
  loadTimer = setTimeout(() => {
    const startTime = performance.now();
    listThingList(data).then(res => {
      contentData.pageData = (res.rows || []).map(item => ({
        ...item,
        cover: resolveCover(item.cover)
      }))
      contentData.total = res.total || contentData.pageData.length
      contentData.loading = false
      console.log(`[性能] 列表加载耗时: ${Math.round(performance.now() - startTime)}ms, 数量: ${contentData.pageData.length}`)
    }).catch(err => {
      console.log(err)
      contentData.loading = false
    })
  }, 20) // 减少延迟
}

const handleImageError = (e) => {
  e.target.src = '/images/demo.jpg'
}
</script>

<style scoped lang="less">
.content {
  display: flex;
  flex-direction: row;
  width: 1100px;
  margin: 80px auto;
}

.content-right {
  -webkit-box-flex: 1;
  -ms-flex: 1;
  flex: 1;
  padding-top: 12px;

  .pc-search-view {
    margin: 0 0 24px;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;

    .search-icon {
      width: 20px;
      height: 20px;
      -webkit-box-flex: 0;
      -ms-flex: 0 0 20px;
      flex: 0 0 20px;
      margin-right: 16px;
    }

    input {
      outline: none;
      border: 0px;
      -webkit-box-flex: 1;
      -ms-flex: 1;
      flex: 1;
      border-bottom: 1px solid #cedce4;
      color: #152844;
      font-size: 14px;
      height: 22px;
      line-height: 22px;
      -ms-flex-item-align: end;
      align-self: flex-end;
      padding-bottom: 8px;
    }

    .clear-search-icon {
      position: relative;
      left: -20px;
      cursor: pointer;
    }

    button {
      outline: none;
      border: none;
      font-size: 14px;
      color: #fff;
      background: #288dda;
      border-radius: 32px;
      width: 88px;
      height: 32px;
      line-height: 32px;
      margin-left: 2px;
      cursor: pointer;
    }

    .float-count {
      color: #999;
      margin-left: 24px;
    }
  }

  .flex-view {
    display: flex;
  }

  .top-select-view {
    -webkit-box-pack: justify;
    -ms-flex-pack: justify;
    justify-content: space-between;
    -webkit-box-align: center;
    -ms-flex-align: center;
    align-items: center;
    height: 40px;
    line-height: 40px;

    .type-view {
      position: relative;
      font-weight: 400;
      font-size: 18px;
      color: #5f77a6;

      .type-tab {
        margin-right: 32px;
        cursor: pointer;
      }

      .type-tab-select {
        color: #152844;
        font-weight: 600;
        font-size: 20px;
      }

      .tab-underline {
        position: absolute;
        bottom: 0;
        //left: 22px;
        width: 16px;
        height: 4px;
        background: #4684e2;
        -webkit-transition: left .3s;
        transition: left .3s;
      }
    }

    .order-view {
      position: relative;
      color: #6c6c6c;
      font-size: 14px;

      .title {
        margin-right: 8px;
      }

      .tab {
        color: #999;
        margin-right: 20px;
        cursor: pointer;
      }

      .tab-select {
        color: #152844;
      }

      .tab-underline {
        position: absolute;
        bottom: 0;
        left: 84px;
        width: 16px;
        height: 4px;
        background: #4684e2;
        -webkit-transition: left .3s;
        transition: left .3s;
      }
    }

  }

  .pc-thing-list {
    -ms-flex-wrap: wrap;
    flex-wrap: wrap;

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
          object-fit: contain;
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
      }
    }

    .no-data {
      height: 200px;
      line-height: 200px;
      text-align: center;
      width: 100%;
      font-size: 16px;
      color: #152844;
    }
  }

  .page-view {
    width: 100%;
    text-align: center;
    margin-top: 48px;
  }
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
