import request from '@/utils/request'

// 房东订单列表
export function listLandlordOrders(query) {
  return request({
    url: '/api/order/landlord/list',
    method: 'get',
    params: {
      pageNum: 1,
      pageSize: 10,
      ...query
    }
  })
}

// 房东接受订单
export function acceptOrder(id) {
  return request({
    url: `/api/order/${id}/accept`,
    method: 'post'
  })
}
