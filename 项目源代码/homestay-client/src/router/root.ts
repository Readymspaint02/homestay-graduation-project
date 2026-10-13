// 路由表
const constantRouterMap = [
  // ************* 前台路由 **************
  {
    path: '/',
    redirect: '/index'
  },
  {
    path: '/index',
    name: 'index',
    redirect: '/index/portal',
    component: () => import('/@/views/index/index.vue'),
    children: [
      {
        path: 'login',
        name: 'login',
        component: () => import('/@/views/index/login.vue')
      },
      {
        path: 'register',
        name: 'register',
        component: () => import('/@/views/index/register.vue')
      },
      {
        path: 'portal',
        name: 'portal',
        component: () => import('/@/views/index/portal.vue')
      },
      {
        path: 'qa',
        name: 'qa',
        component: () => import('/@/views/index/qa.vue')
      },
      {
        path: 'ai',
        name: 'ai',
        component: () => import('/@/views/index/ai.vue')
      },
      {
        path: 'chat',
        name: 'chat',
        component: () => import('/@/views/index/chat.vue')
      },
      {
        path: 'detail',
        name: 'detail',
        component: () => import('/@/views/index/detail.vue')
      },
      {
        path: 'confirm',
        name: 'confirm',
        component: () => import('/@/views/index/confirm.vue')
      },
      {
        path: 'pay',
        name: 'pay',
        component: () => import('/@/views/index/pay.vue')
      },
      {
        path: 'search',
        name: 'search',
        component: () => import('/@/views/index/search.vue')
      },
      {
        path: 'usercenter',
        name: 'usercenter',
        redirect: '/index/usercenter/collectThingView',
        component: () => import('/@/views/index/usercenter.vue'),
        children: [
          {
            path: 'addressView',
            name: 'addressView',
            component: () => import('/@/views/index/user/address-view.vue')
          },
          {
            path: 'wishThingView',
            name: 'wishThingView',
            component: () => import('/@/views/index/user/wish-thing-view.vue')
          },
          {
            path: 'collectThingView',
            name: 'collectThingView',
            component: () => import('/@/views/index/user/collect-thing-view.vue')
          },
          {
            path: 'orderView',
            name: 'orderView',
            component: () => import('/@/views/index/user/order-view.vue')
          },
          {
            path: 'calendarView',
            name: 'calendarView',
            component: () => import('/@/views/index/user/calendar-view.vue')
          },
          {
            path: 'userInfoEditView',
            name: 'userInfoEditView',
            component: () => import('/@/views/index/user/userinfo-edit-view.vue')
          },
          {
            path: 'followView',
            name: 'followView',
            component: () => import('/@/views/index/user/follow-view.vue')
          },
          {
            path: 'fansView',
            name: 'fansView',
            component: () => import('/@/views/index/user/fans-view.vue')
          },
          {
            path: 'scoreView',
            name: 'scoreView',
            component: () => import('/@/views/index/user/score-view.vue')
          },
          {
            path: 'commentView',
            name: 'commentView',
            component: () => import('/@/views/index/user/comment-view.vue')
          },
          {
            path: 'securityView',
            name: 'securityView',
            component: () => import('/@/views/index/user/security-view.vue')
          },
          {
            path: 'pushView',
            name: 'pushView',
            component: () => import('/@/views/index/user/push-view.vue')
          },
          {
            path: 'messageView',
            name: 'messageView',
            component: () => import('/@/views/index/user/message-view.vue')
          },
        ]
      }
    ]
  },
  {
    path: '/adminLogin',
    name: 'adminLogin',
    component: () => import('/@/views/admin/admin-login.vue'),
  },
  {
    path: '/admin',
    name: 'admin',
    redirect: '/admin/order',
    component: () => import('/@/views/admin/main.vue'),
    children: [
      { path: 'overview', name: 'overview', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'order', name: 'order', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'thing', name: 'thing', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'comment', name: 'comment', component: () => import('/@/views/admin/comment.vue') },
      { path: 'user', name: 'user', component: () => import('/@/views/admin/user.vue') },
      { path: 'classification', name: 'classification', component: () => import('/@/views/admin/classification.vue') },
      { path: 'tag', name: 'tag', component: () => import('/@/views/admin/tag.vue') },
      { path: 'ad', name: 'ad', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'notice', name: 'notice', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'loginLog', name: 'loginLog', component: () => import('/@/views/admin/login-log.vue') },
      { path: 'opLog', name: 'opLog', component: () => import('/@/views/admin/op-log.vue') },
      { path: 'errorLog', name: 'errorLog', component: () => import('/@/views/admin/error-log.vue') },
      { path: 'supervision', name: 'supervision', component: () => import('/@/views/admin/legacy-redirect.vue') },
      { path: 'sysInfo', name: 'sysInfo', component: () => import('/@/views/admin/sys-info.vue') },
      // 房东端路由
      { path: 'homestay-overview', name: 'homestayOverview', component: () => import('/@/views/homestay/overview/index.vue') },
      { path: 'homestay/homestay/list', name: 'homestayList', component: () => import('/@/views/homestay/homestay/index.vue') },
      { path: 'homestay/homestay/create', name: 'homestayCreate', component: () => import('/@/views/homestay/homestay/edit.vue') },
      { path: 'homestay/homestay/edit/:id', name: 'homestayEdit', component: () => import('/@/views/homestay/homestay/edit.vue') },
      { path: 'homestay/homestay/calendar', name: 'homestayCalendar', component: () => import('/@/views/homestay/homestay/calendar.vue') },
      { path: 'homestay/order/list', name: 'homestayOrder', component: () => import('/@/views/homestay/order/index.vue') },
    ]
  },
  {
    path: '/cleaner',
    name: 'cleaner',
    component: () => import('/@/views/cleaner/index.vue'),
  },
  {
    path: '/landlord',
    name: 'landlord',
    redirect: '/landlord/overview',
    component: () => import('/@/views/landlord/main.vue'),
    children: [
      { path: 'overview', name: 'landlordOverview', component: () => import('/@/views/landlord/overview/index.vue') },
      { path: 'homestay', name: 'landlordHomestay', component: () => import('/@/views/landlord/homestay/index.vue') },
      { path: 'homestay/create', name: 'landlordHomestayCreate', component: () => import('/@/views/landlord/homestay/edit.vue') },
      { path: 'homestay/edit/:id', name: 'landlordHomestayEdit', component: () => import('/@/views/landlord/homestay/edit.vue') },
      { path: 'calendar', name: 'landlordCalendar', component: () => import('/@/views/landlord/calendar/index.vue') },
      { path: 'order', name: 'landlordOrder', component: () => import('/@/views/landlord/order/index.vue') },
      { path: 'income', name: 'landlordIncome', component: () => import('/@/views/landlord/overview/index.vue') },
      { path: 'cleaning', name: 'landlordCleaning', component: () => import('/@/views/landlord/cleaning/index.vue') },
      { path: 'ai', name: 'landlordAi', component: () => import('/@/views/landlord/ai/index.vue') },
      { path: 'chat', name: 'landlordChat', component: () => import('/@/views/landlord/chat/index.vue') },
      { path: 'profile', name: 'landlordProfile', component: () => import('/@/views/landlord/profile/index.vue') },
    ]
  },
];

export default constantRouterMap;
