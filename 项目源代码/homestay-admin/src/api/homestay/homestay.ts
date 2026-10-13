import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/homestay/landlord/list',
  detail = '/api/homestay/detail',
  create = '/api/homestay/create',
  update = '/api/homestay/update',
  publish = '/api/homestay/publish',
  offline = '/api/homestay/offline',
  delete = '/api/homestay/delete',
  audit = '/api/homestay/audit',
  imageUpload = '/api/homestay/image/upload',
}

// 获取房东房源列表
export const listApi = async (params: any) => {
  const query: Record<string, any> = {
    pageNum: Number(params?.pageNum || 1),
    pageSize: Number(params?.pageSize || 10),
  };
  if (params?.auditStatus !== undefined && params?.auditStatus !== null) {
    query.auditStatus = String(params.auditStatus);
  }
  if (params?.publishStatus !== undefined && params?.publishStatus !== null) {
    query.publishStatus = String(params.publishStatus);
  }
  if (params?.title) {
    query.title = String(params.title);
  }
  return get<any>({ url: URL.list, params: query, headers: {} });
};

// 获取房源详情
export const detailApi = async (id: number) => {
  return get<any>({ url: `${URL.detail}/${id}`, params: {}, headers: {} });
};

// 创建房源
export const createApi = async (data: any) => {
  return post<any>({ url: URL.create, data, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

// 更新房源
export const updateApi = async (data: any) => {
  return post<any>({ url: URL.update, data, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

// 上架房源
export const publishApi = async (id: number) => {
  return post<any>({ url: `${URL.publish}/${id}`, data: {}, headers: {} });
};

// 下架房源
export const offlineApi = async (id: number) => {
  return post<any>({ url: `${URL.offline}/${id}`, data: {}, headers: {} });
};

// 删除房源
export const deleteApi = async (id: number) => {
  return post<any>({ url: `${URL.delete}/${id}`, data: {}, headers: {} });
};

// 上传房源图片
export const uploadApi = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  return post<any>({ url: URL.imageUpload, data: formData, headers: {} });
};
