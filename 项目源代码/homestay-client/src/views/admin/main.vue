<template>
  <a-layout id="components-layout-demo-custom-trigger">
    <a-layout-header style="background: #fff; padding: 0">
      <div class="header">
        <img class="header-logo" :src="logo">
        <span class="header-title">民宿短租管理系统</span>
        <div class="empty"></div>
        <a-button style="margin-right: 24px;" @click="handlePreview">前台预览</a-button>
        <span>管理员[{{ userStore.admin_user_name }}]</span>
        <a class="header-quit" @click="handleLogout">退出</a>
      </div>
    </a-layout-header>
    <a-layout>
      <a-layout-sider v-model="collapsed" collapsible>
        <a-menu style="overflow:auto; overflow-x: hidden;" v-model:selectedKeys="selectedKeys" theme="dark" mode="inline" @click="handleClick">
          <a-menu-item key="order">
            <DatabaseOutlined/>
            <span>订单管理</span>
          </a-menu-item>
          <a-menu-item key="thing">
            <DatabaseOutlined/>
            <span>房源管理</span>
          </a-menu-item>
          <a-menu-item key="notice">
            <DatabaseOutlined/>
            <span>公告管理</span>
          </a-menu-item>
          <a-menu-item key="ad">
            <DatabaseOutlined/>
            <span>轮播管理</span>
          </a-menu-item>
          <a-menu-item key="supervision">
            <DatabaseOutlined/>
            <span>监管上报</span>
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
import { DatabaseOutlined } from '@ant-design/icons-vue';
import { ref, onMounted } from 'vue';
import { useUserStore } from '/@/store';

const userStore = useUserStore();
const selectedKeys = ref<any[]>([]);
const collapsed = ref<boolean>(false);

const router = useRouter();
const route = useRoute();

const handleClick = ({ key }: { key: string }) => {
  router.push({ name: key });
};

const handlePreview = () => {
  const text = router.resolve({ name: 'index' });
  window.open(text.href, '_blank');
};

onMounted(() => {
  selectedKeys.value = [route.name];
});

const handleLogout = () => {
  userStore.adminLogout().then(() => {
    router.push({ name: 'adminLogin' });
  });
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

  .header-quit {
    margin-left: 12px;
  }
}

#components-layout-demo-custom-trigger {
  height: 100%;
}

#components-layout-demo-custom-trigger .trigger {
  font-size: 18px;
  line-height: 64px;
  padding: 0 24px;
  cursor: pointer;
  transition: color 0.3s;
}

#components-layout-demo-custom-trigger .trigger:hover {
  color: #1890ff;
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
