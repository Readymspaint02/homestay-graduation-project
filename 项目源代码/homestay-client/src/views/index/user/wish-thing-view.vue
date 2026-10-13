<template>
  <div class="content-list">
    <div class="list-title">我的心愿单</div>
    <div role="tablist" class="list-tabs-view flex-view">
    </div>
    <div class="list-content">
      <div class="collect-thing-view">
        <div class="thing-list flex-view">
          <div class="thing-item item-column-3" v-for="(item,index) in wishData" :key="index">
            <div class="remove" @click="handleRemove(item)">移出</div>
            <div class="img-view" @click="handleClickItem(item)">
              <img :src="item.cover">
            </div>
            <div class="info-view">
              <h3 class="thing-name">{{item.title}}</h3>
              <p class="authors" v-if="item.city">{{item.city}} {{item.address || ''}}</p>
              <p class="translators" v-if="item.price">¥{{item.price}}</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import {message} from 'ant-design-vue';
import {userWishListApi, unWishApi} from '/@/api/thingWish'
import {useUserStore} from "/@/store";
import { BASE_URL, USER_ID } from '/@/store/constants';

const router = useRouter();
const route = useRoute();
const userStore = useUserStore();

let wishData = ref([])

const getCurrentUserId = () => {
  const id = Number(userStore.user_id || localStorage.getItem(USER_ID) || 0)
  return Number.isFinite(id) ? id : 0
}

onMounted(()=>{
  getWishThingList()
})

const handleClickItem =(record)=> {
  const thingId = record.thingId || record.id
  let text = router.resolve({name: 'detail', query: {id: thingId}})
  window.open(text.href, '_blank')
}

const handleRemove =(record)=> {
  const thingId = record.thingId || record.id
  unWishApi({id: thingId, thingId: thingId}).then(res => {
    message.success('移除成功')
    getWishThingList()
  }).catch(err => {
    console.log(err)
  })
}
const resolveCover = (cover) => {
  if (!cover) return '/images/demo.jpg'
  if (cover.startsWith('http://') || cover.startsWith('https://')) {
    return cover.replace(/^http:/, 'https:')
  }
  if (cover.startsWith('/')) {
    return cover
  }
  return BASE_URL + '/profile/' + cover
}
const getWishThingList =()=> {
  const userId = getCurrentUserId()
  userWishListApi({userId: userId}).then(res => {
    const rows = Array.isArray(res?.data) ? res.data : []
    rows.forEach(item => {
      item.cover = resolveCover(item.cover)
      if (!item.thingId) {
        item.thingId = item.id
      }
    })
    wishData.value = rows
  }).catch(err => {
    wishData.value = []
    message.error(err?.msg || '加载心愿失败')
  })
}

</script>
<style scoped lang="less">
.flex-view {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
}

.content-list {
  -webkit-box-flex: 1;
  -ms-flex: 1;
  flex: 1;

  .list-title {
    color: #152844;
    font-weight: 600;
    font-size: 18px;
    line-height: 24px;
    height: 24px;
    margin-bottom: 4px;
  }

  .list-tabs-view {
    position: relative;
    border-bottom: 1px solid #cedce4;
    height: 12px;
    line-height: 42px;
  }
}

.thing-list {
  -ms-flex-wrap: wrap;
  flex-wrap: wrap;
  -webkit-box-pack: start;
  -ms-flex-pack: start;
  justify-content: flex-start;

  .thing-item {
    position: relative;
    -webkit-box-flex: 1;
    -ms-flex: 1;
    flex: 1;
    margin-right: 20px;
    min-width: 255px;
    max-width: 255px;
    height: fit-content;
    border-radius: 4px;
    overflow: hidden;
    margin-top: 16px;
    cursor: pointer;

    .remove {
      position: absolute;
      right: 8px;
      top: 8px;
      width: 48px;
      height: 20px;
      text-align: center;
      line-height: 20px;
      color: #fff;
      background: #a1adc5;
      border-radius: 32px;
      cursor: pointer;
    }

    .img-view {
      background: #eaf1f5;
      font-size: 0;
      text-align: center;
      height: 156px;
      padding: 8px 0;

      img {
        max-width: 100%;
        height: 100%;
        display: block;
        margin: 0 auto;
        border-radius: 4px;
        -webkit-box-sizing: border-box;
        box-sizing: border-box;
      }
    }

    .info-view {
      background: #f6f9fb;
      text-align: center;
      height: 108px;
      overflow: hidden;
      padding: 0 16px;

      h3 {
        color: #1c355a;
        font-weight: 500;
        font-size: 16px;
        line-height: 20px;
        overflow: hidden;
        text-overflow: ellipsis;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        margin: 12px 0 8px;
      }

      .authors, .translators {
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
}
</style>
