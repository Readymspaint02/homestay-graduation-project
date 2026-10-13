import {createRouter, createWebHistory} from 'vue-router';
import root from './root';

import { ADMIN_USER_TOKEN, USER_TOKEN } from '/@/store/constants'

const allowList = ['login', 'register', 'portal', 'qa', 'ai', 'chat', 'search', 'detail', '403', '404', 'orderView', 'pay', 'cleaner']
const loginRoutePath = '/index/login'
const adminLoginRoutePath = '/adminLogin'
const landlordRoutePath = '/landlord/overview'


const router = createRouter({
  history: createWebHistory(),
  routes: root,
});

router.beforeEach(async (to, from, next) => {
  console.log(to, from)

  /** 房东端路由 **/
  if (to.path.startsWith('/landlord')) {
    if (localStorage.getItem(USER_TOKEN)) {
      next()
    } else {
      next({ path: loginRoutePath, query: { redirect: to.fullPath, role: 'landlord' } })
    }
    return
  }

  /** 后台路由 - 已隐藏，重定向到首页 **/
  if (to.path.startsWith('/admin') || to.path === '/adminLogin') {
    next({ path: '/' })
    return
  }

  /** 前台路由 **/
  if (to.path.startsWith('/index')) {
    if (localStorage.getItem(USER_TOKEN)) {
      if (to.path === loginRoutePath) {
        next({ path: '/' })
      } else {
        next()
      }
    } else {
      if (allowList.includes(to.name as string)) {
        next()
      } else {
        next({ path: loginRoutePath, query: { redirect: to.fullPath } })
      }
    }
    return
  }

  next()
});

router.afterEach((_to) => {
  document.getElementById("html")?.scrollTo(0, 0)
});

export default router;
