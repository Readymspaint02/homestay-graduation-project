import request from '@/utils/request'

// 获取房东房源列表
export function listHomestay(query) {
  return request({
    url: '/api/homestay/landlord/list',
    method: 'get',
    params: {
      pageNum: 1,
      pageSize: 10,
      ...query
    }
  })
}

// 获取房源详情
export function getHomestay(id) {
  return request({
    url: `/api/homestay/detail/${id}`,
    method: 'get'
  })
}

// 创建房源
export function createHomestay(data) {
  return request({
    url: '/api/homestay/create',
    method: 'post',
    data
  })
}

// 更新房源
export function updateHomestay(data) {
  return request({
    url: '/api/homestay/update',
    method: 'post',
    data
  })
}

// 上架房源
export function publishHomestay(id) {
  return request({
    url: `/api/homestay/${id}/publish`,
    method: 'post'
  })
}

// 下架房源
export function offlineHomestay(id) {
  return request({
    url: `/api/homestay/${id}/offline`,
    method: 'post'
  })
}

// 删除房源
export function deleteHomestay(id) {
  return request({
    url: `/api/homestay/${id}/delete`,
    method: 'post'
  })
}

// 上传房源图片
export function uploadHomestayImage(file) {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: '/api/homestay/image/upload',
    method: 'post',
    data: formData,
    headers: { 'Content-Type': undefined }
  })
}
