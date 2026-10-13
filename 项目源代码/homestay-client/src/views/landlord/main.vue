<template>
  <a-layout id="landlord-layout">
    <a-layout-header style="background: #fff; padding: 0">
      <div class="header">
        <img class="header-logo" :src="logo">
        <span class="header-title">房东管理中心</span>
        <div class="empty"></div>
        <span class="greeting">{{ greeting }}，{{ displayName }}先生</span>
        <a-dropdown>
          <a class="header-user" @click.prevent>
            <a-avatar :size="32" :src="userAvatar">
              <template #icon><UserOutlined /></template>
            </a-avatar>
            <span style="margin-left: 8px;">{{ displayName }}</span>
            <DownOutlined style="margin-left: 4px;" />
          </a>
          <template #overlay>
            <a-menu>
              <a-menu-item key="profile" @click="handleProfile">
                <UserOutlined />
                <span style="margin-left: 8px;">个人中心</span>
              </a-menu-item>
              <a-menu-divider />
              <a-menu-item key="logout" @click="handleLogout">
                <LogoutOutlined />
                <span style="margin-left: 8px;">退出登录</span>
              </a-menu-item>
            </a-menu>
          </template>
        </a-dropdown>
      </div>
    </a-layout-header>
    <a-layout>
      <a-layout-sider v-model:collapsed="collapsed" collapsible>
        <a-menu style="overflow:auto; overflow-x: hidden;" v-model:selectedKeys="selectedKeys" theme="dark" mode="inline" @click="handleClick">
          <a-menu-item key="landlordOverview">
            <DashboardOutlined/>
            <span>运营看板</span>
          </a-menu-item>
          <a-menu-item key="landlordHomestay">
            <HomeOutlined />
            <span>房源管理</span>
          </a-menu-item>
          <a-menu-item key="landlordCalendar">
            <CalendarOutlined />
            <span>房态日历</span>
          </a-menu-item>
          <a-menu-item key="landlordOrder">
            <ShoppingOutlined />
            <span>订单管理</span>
          </a-menu-item>
          <a-menu-item key="landlordCleaning">
            <ClearOutlined />
            <span>清洁管理</span>
          </a-menu-item>
          <a-menu-item key="landlordAi">
            <RobotOutlined />
            <span>AI助手</span>
          </a-menu-item>
          <a-menu-item key="landlordChat">
            <MessageOutlined />
            <span>租客沟通</span>
          </a-menu-item>
        </a-menu>
      </a-layout-sider>
      <a-layout-content :style="{ margin: '16px 16px', minHeight: '200px' }">
        <router-view/>
      </a-layout-content>
    </a-layout>
  </a-layout>
</template>
<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router';
import logo from '/@/assets/images/k-logo.png';
import { DashboardOutlined, HomeOutlined, CalendarOutlined, ShoppingOutlined, MessageOutlined, ClearOutlined, RobotOutlined, UserOutlined, DownOutlined, LogoutOutlined } from '@ant-design/icons-vue';
import { ref, onMounted, computed, onUnmounted } from 'vue';
import { useUserStore } from '/@/store';
import { get } from '/@/utils/http/axios';
import { BASE_URL, USER_NAME } from '/@/store/constants';

const userStore = useUserStore();
const selectedKeys = ref<any[]>([]);
const collapsed = ref<boolean>(false);
const userProfile = ref({
  nickname: '',
  avatar: '',
});

const router = useRouter();
const route = useRoute();

const greeting = computed(() => {
  const hour = new Date().getHours();
  if (hour >= 5 && hour < 12) return '早上好';
  if (hour >= 12 && hour < 18) return '中午好';
  return '晚上好';
});

const resolveAvatar = (avatar: string) => {
  const raw = String(avatar || '').trim();
  if (!raw) return '';
  if (raw.startsWith('http://') || raw.startsWith('https://')) return raw.replace(/^http:/, 'https:');
  if (raw.startsWith('/profile/')) return `${BASE_URL}${raw}`;
  if (raw.startsWith('/')) return raw;
  if (raw.includes('/') || raw.includes('.')) return raw;
  return `${BASE_URL}/profile/${raw}`;
};

const userAvatar = computed(() => {
  return resolveAvatar(userProfile.value.avatar) || '';
});

const displayName = computed(() => {
  return userProfile.value.nickname || userStore.user_name || '房东';
});

const handleClick = ({ key }: { key: string }) => {
  router.push({ name: key });
};

const loadProfile = async () => {
  try {
    const res = await get({ url: '/api/user/detail', params: {}, headers: {} });
    if (res && res.data) {
      userProfile.value.nickname = res.data.nickname || res.data.username || '';
      userProfile.value.avatar = res.data.avatar || '';
      if (userProfile.value.nickname) {
        userStore.user_name = userProfile.value.nickname;
        localStorage.setItem(USER_NAME, userProfile.value.nickname);
      }
    }
  } catch (e) {
    userProfile.value.nickname = userStore.user_name || '';
  }
};

const handleProfileUpdated = () => {
  loadProfile();
};

onMounted(() => {
  selectedKeys.value = [route.name as string];
  userProfile.value.nickname = userStore.user_name || '';
  loadProfile();
  window.addEventListener('profile-updated', handleProfileUpdated);
});

onUnmounted(() => {
  window.removeEventListener('profile-updated', handleProfileUpdated);
});

const handleLogout = () => {
  userStore.logout().then(() => {
    router.push({ name: 'login' });
  });
};

const handleProfile = () => {
  router.push({ name: 'landlordProfile' });
};
</script>
<style scoped lang="less">
.header {
  display: flex;
  flex-direction: row;
  align-items: center;
  padding-left: 24px;
  padding-right: 24px;

  .header-logo {
    width: 32px;
    height: 32px;
    cursor: pointer;
  }

  .header-title {
    margin-left: 16px;
    font-size: 20px;
    font-weight: bold;
    text-align: center;
  }

  .empty {
    flex: 1;
  }

  .greeting {
    margin-right: 16px;
    color: #666;
  }

  .header-user {
    display: flex;
    align-items: center;
    cursor: pointer;
    color: #333;
    &:hover {
      color: #1890ff;
    }
  }
}

#landlord-layout {
  height: 100%;
}

:deep(.ant-layout-content) {
  overflow-x: hidden;
}

:deep(.ant-layout-sider) {
  padding: 16px 0;
  background-color: #f0f2f5;
}

:deep(.ant-menu) {
  padding-top: 16px;
  height: 100%;
}
</style>