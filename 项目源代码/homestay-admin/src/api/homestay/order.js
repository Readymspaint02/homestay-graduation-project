import request from '@/utils/request'

export function listOrder(query) {
  return request({
    url: '/api/order/my',
    method: 'get',
    params: query
  })
}

export function confirmOrder(data) {
  return request({
    url: '/api/order/confirm',
    method: 'post',
    data
  })
}

export function rejectOrder(data) {
  return request({
    url: '/api/order/reject',
    method: 'post',
    data
  })
}
