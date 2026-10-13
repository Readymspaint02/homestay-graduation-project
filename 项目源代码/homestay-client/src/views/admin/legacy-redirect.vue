<template>
  <div class="redirect-wrap">
    <div class="tip">后台已迁移，正在跳转到统一管理后台...</div>
    <a class="link" :href="targetUrl">若未自动跳转，请点击这里</a>
  </div>
</template>

<script setup lang="ts">
  import { computed, onMounted } from 'vue';
  import { useRoute } from 'vue-router';

  const route = useRoute();

  const targetMap: Record<string, string> = {
    overview: '/admin/homestay-overview',
    order: '/admin/homestay/order',
    thing: '/admin/homestay/homestayList',
    notice: '/admin/homestay/notice',
    ad: '/admin/homestay/ad',
    supervision: '/admin/homestay/supervision',
    homestayList: '/admin/homestay/homestayList',
    homestayCalendar: '/admin/homestay/homestayCalendar',
  };

  const targetUrl = computed(() => {
    const key = String(route.name || '').trim();
    const path = targetMap[key] || '/admin/homestay/overview';
    return `http://localhost:81${path}`;
  });

  onMounted(() => {
    window.location.replace(targetUrl.value);
  });
</script>

<style scoped lang="less">
  .redirect-wrap {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    gap: 10px;
    background: #f7f8fa;
  }

  .tip {
    color: #333;
    font-size: 15px;
  }

  .link {
    color: #1677ff;
    text-decoration: none;
    font-size: 14px;
  }
</style>

