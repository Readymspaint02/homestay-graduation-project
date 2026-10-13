import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/homestay/landlord/list',
  detail = '/api/homestay/detail',
  create = '/api/homestay/create',
  update = '/api/homestay/update',
  publish = '/api/homestay',
  offline = '/api/homestay',
  delete = '/api/homestay',
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
  const res = await get<any>({ url: URL.list, params: query, headers: {} });
  console.log('[homestay list] API response:', res);
  console.log('[homestay list] res.rows:', res?.rows, 'type:', typeof res?.rows, 'isArray:', Array.isArray(res?.rows));
  // 确保 rows 是数组
  const rows = Array.isArray(res?.rows) ? res.rows : [];
  const total = res?.total ?? 0;
  console.log('[homestay list] final rows:', rows, 'total:', total);
  return {
    ...res,
    rows,
    total,
  };
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
  return post<any>({ url: `${URL.publish}/${id}/publish`, data: {}, headers: {} });
};

// 下架房源
export const offlineApi = async (id: number) => {
  return post<any>({ url: `${URL.offline}/${id}/offline`, data: {}, headers: {} });
};

// 删除房源
export const deleteApi = async (id: number) => {
  return post<any>({ url: `${URL.delete}/${id}/delete`, data: {}, headers: {} });
};

// 上传房源图片
export const uploadApi = async (file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  return post<any>({ url: URL.imageUpload, data: formData, headers: {} });
};
