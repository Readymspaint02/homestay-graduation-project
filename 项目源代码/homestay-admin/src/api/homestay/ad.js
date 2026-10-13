import request from '@/utils/request'

function toFormData(data = {}) {
  const formData = new FormData()
  Object.keys(data).forEach((key) => {
    const value = data[key]
    if (value === undefined || value === null || value === '') {
      return
    }
    formData.append(key, value)
  })
  return formData
}

export function listAd(query) {
  return request({
    url: '/api/ad/list',
    method: 'get',
    params: query
  })
}

export function createAd(data) {
  return request({
    url: '/api/ad/create',
    method: 'post',
    data: toFormData(data)
  })
}

export function updateAd(data) {
  return request({
    url: '/api/ad/update',
    method: 'post',
    data: toFormData(data)
  })
}

export function deleteAd(data) {
  return request({
    url: '/api/ad/delete',
    method: 'post',
    data: toFormData(data)
  })
}

