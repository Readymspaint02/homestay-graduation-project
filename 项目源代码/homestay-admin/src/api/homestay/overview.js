import request from '@/utils/request'

export function getOverviewCount() {
  return request({
    url: '/api/overview/count',
    method: 'get'
  })
}

export function getOverviewSysInfo() {
  return request({
    url: '/api/overview/sysInfo',
    method: 'get'
  })
}
