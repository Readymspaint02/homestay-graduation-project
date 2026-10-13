import request from '@/utils/request'

export function getSupervisionStats() {
  return request({
    url: '/api/supervision/report/stats',
    method: 'get'
  })
}

export function listSupervision(query) {
  return request({
    url: '/api/supervision/report/list',
    method: 'get',
    params: query
  })
}

export function generateSupervision(limit = 20) {
  return request({
    url: '/api/supervision/report/generate',
    method: 'post',
    params: { limit }
  })
}

export function processSupervision(limit = 20) {
  return request({
    url: '/api/supervision/report/process',
    method: 'post',
    params: { limit }
  })
}

export function pushSupervision(data) {
  return request({
    url: '/api/supervision/report/push',
    method: 'post',
    data
  })
}

export function reportSingleOrder(orderId) {
  return request({
    url: `/api/supervision/report/order/${orderId}`,
    method: 'post'
  })
}

export function getOrderReportStatus(orderId) {
  return request({
    url: `/api/supervision/report/order/status/${orderId}`,
    method: 'get'
  })
}
