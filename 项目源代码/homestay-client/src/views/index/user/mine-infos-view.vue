<template>
  <div class="mine-infos-view">
    <div class="info-box flex-view" @click="clickMenu('userInfoEditView')">
      <img :src="displayAvatar" class="avatar-img" alt="avatar" />
      <div class="name-box">
        <h2 class="nick">{{ displayName }}</h2>
        <div class="age">个人中心</div>
      </div>
    </div>

    <div class="order-box">
      <div class="title">订单管理</div>
      <div class="list">
        <div class="mine-item flex-view" @click="clickMenu('orderView')">
          <img :src="MyOrderImg" alt="order" />
          <span>我的订单</span>
        </div>
      </div>
    </div>

    <div class="order-box">
      <div class="title">消息中心</div>
      <div class="list">
        <div class="mine-item flex-view" @click="clickMenu('messageView')">
          <img :src="MessageIconImage" alt="message" />
          <span>消息管理</span>
        </div>
      </div>
    </div>

    <div class="order-box">
      <div class="title">收藏管理</div>
      <div class="list">
        <div class="mine-item flex-view" @click="clickMenu('collectThingView')">
          <img :src="CollectIconImage" alt="collect" />
          <span>我的收藏</span>
        </div>
      </div>
    </div>

    <div class="order-box">
      <div class="title">评价管理</div>
      <div class="list">
        <div class="mine-item flex-view" @click="clickMenu('commentView')">
          <img :src="CommentIconImage" alt="comment" />
          <span>我的评价</span>
        </div>
      </div>
    </div>

    <div class="order-box">
      <div class="title">AI助手</div>
      <div class="list">
        <div class="mine-item flex-view" @click="goQa">
          <img :src="AiIconImage" alt="ai" />
          <span>智能问答</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import AvatarImg from '/@/assets/images/avatar.jpg';
import MyOrderImg from '/@/assets/images/order-icon.svg';
import MessageIconImage from '/@/assets/images/setting-msg-icon.svg';
import CollectIconImage from '/@/assets/images/setting-icon.svg';
import AiIconImage from '/@/assets/images/setting-push-icon.svg';
import CommentIconImage from '/@/assets/images/setting-card-icon.svg';
import { detailApi } from '/@/api/user';
import { useUserStore } from '/@/store';
import { BASE_URL, USER_NAME } from '/@/store/constants';

const userStore = useUserStore();
const router = useRouter();

const profile = reactive({
  nickname: '',
  avatar: '',
});

const displayName = computed(() => profile.nickname || userStore.user_name || '用户');
const displayAvatar = computed(() => profile.avatar || AvatarImg);

onMounted(() => {
  loadProfile();
  window.addEventListener('profile-updated', handleProfileUpdated);
});

onUnmounted(() => {
  window.removeEventListener('profile-updated', handleProfileUpdated);
});

const resolveAvatar = (avatar: any) => {
  const raw = String(avatar || '').trim();
  if (!raw) return '';
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:');
  if (raw.startsWith('/images/')) return raw;
  if (raw.startsWith('/profile/')) return `${BASE_URL}${raw}`;
  if (raw.startsWith('/')) return raw;
  if (raw.includes('/') || raw.includes('.')) return raw;
  return `${BASE_URL}/api/staticfiles/avatar/${raw}`;
};

const loadProfile = () => {
  detailApi({})
    .then((res) => {
      const data = res?.data || {};
      profile.nickname = String(data.nickname || data.username || userStore.user_name || '').trim();
      profile.avatar = resolveAvatar(data.avatar);
      if (profile.nickname) {
        userStore.user_name = profile.nickname;
        localStorage.setItem(USER_NAME, profile.nickname);
      }
    })
    .catch(() => {});
};

const handleProfileUpdated = () => {
  loadProfile();
};

const clickMenu = (name: string) => {
  console.log('clickMenu called with:', name);
  router.push({ name }).catch((err) => {
    console.error('router push error:', err);
  });
};

const goQa = () => {
  console.log('goQa called');
  router.push({ name: 'qa' }).catch((err) => {
    console.error('router push error:', err);
  });
};
</script>

<style scoped lang="less">
.flex-view {
  display: flex;
}

.mine-infos-view {
  width: 235px;
  margin-right: 20px;
  border: 1px solid #cedce4;
  height: fit-content;
}

.info-box {
  align-items: center;
  padding: 16px 16px 0;
  cursor: pointer;
  transition: background 0.2s;
}

.info-box:hover {
  background: #f5f7fa;
}

.avatar-img {
  width: 48px;
  height: 48px;
  margin-right: 16px;
  border-radius: 50%;
}

.name-box {
  flex: 1;
  overflow: hidden;
}

.nick {
  color: #152844;
  font-weight: 600;
  font-size: 18px;
  line-height: 24px;
  margin: 0;
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

.age {
  font-size: 12px;
  color: #6f6f6f;
  margin-top: 8px;
}

.order-box {
  border-top: 1px solid #cedce4;
  padding: 16px;
}

.title {
  color: #152844;
  font-weight: 600;
  font-size: 14px;
  line-height: 18px;
  margin-bottom: 8px;
}

.list {
  padding-left: 16px;
}

.mine-item {
  border-top: 1px dashed #cedce4;
  cursor: pointer;
  height: 48px;
  align-items: center;
  transition: background 0.2s;
}

.mine-item:hover {
  background: #f0f5ff;
}

.mine-item:first-child {
  border: none;
}

.mine-item img {
  width: 24px;
  margin-right: 8px;
  height: 24px;
}

.mine-item span {
  color: #152844;
  font-size: 14px;
}
</style>
