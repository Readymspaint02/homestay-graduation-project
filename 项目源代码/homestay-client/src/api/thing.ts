import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/homestay/list',
  adminList = '/api/homestay/admin/list',
  create = '/api/homestay/create',
  update = '/api/homestay/update',
  audit = '/api/homestay/audit',
  publish = '/api/homestay',
  detail = '/api/homestay/detail',
}

const getFormValue = (form: any, key: string) => {
  if (!form) return undefined;
  if (form instanceof FormData) return form.get(key);
  return form[key];
};

const toNumber = (value: any, defaultValue: number) => {
  const n = Number(value);
  return Number.isFinite(n) && n > 0 ? n : defaultValue;
};

const toNullableNumber = (value: any) => {
  if (value === '' || value === null || value === undefined) return null;
  const n = Number(value);
  return Number.isFinite(n) ? n : null;
};

const normalizeThing = (item: any) => {
  if (!item) return item;
  return {
    ...item,
    price: item.basePrice ?? item.price ?? 0,
    cover: item.coverImage ?? item.cover ?? '',
    cleaningStatus: String(item.cleaningStatus ?? '0'),
  };
};

const listApi = async (params: any) => {
  const query = {
    keyword: params?.keyword ?? params?.title,
    city: params?.city,
    classificationId: params?.c ?? params?.classificationId,
    tagId: params?.tag ?? params?.tagId,
    auditStatus: params?.auditStatus,
    publishStatus: params?.publishStatus,
    cleaningStatus: params?.cleaningStatus,
    landlordUserId: params?.landlordUserId,
    minPrice: params?.minPrice,
    maxPrice: params?.maxPrice,
    sort: params?.sort,
    pageNum: params?.pageNum ?? 1,
    pageSize: params?.pageSize ?? 24,
  };
  const res = await get<any>({ url: URL.list, params: query, data: {}, headers: {} });
  const rows = (res?.rows || []).map((it: any) => normalizeThing(it));
  return { ...res, data: rows, rows };
};

const adminListApi = async (params: any) => {
  const query: Record<string, any> = {
    title: params?.keyword ?? params?.title,
    auditStatus: params?.auditStatus,
    publishStatus: params?.publishStatus,
    pageNum: params?.pageNum ?? 1,
    pageSize: params?.pageSize ?? 24,
  };
  const res = await get<any>({ url: URL.adminList, params: query, data: {}, headers: {} });
  const rows = (res?.rows || []).map((it: any) => normalizeThing(it));
  return { ...res, data: rows, rows };
};

const createApi = async (data: any) => {
  const payload = {
    title: getFormValue(data, 'title') || getFormValue(data, 'name') || '演示民宿',
    description: getFormValue(data, 'description') || getFormValue(data, 'remark') || '',
    province: getFormValue(data, 'province') || '',
    city: getFormValue(data, 'city') || '',
    district: getFormValue(data, 'district') || '',
    address: getFormValue(data, 'address') || '',
    longitude: toNullableNumber(getFormValue(data, 'longitude')),
    latitude: toNullableNumber(getFormValue(data, 'latitude')),
    basePrice: toNumber(getFormValue(data, 'price') ?? getFormValue(data, 'basePrice'), 199),
    maxGuests: toNumber(getFormValue(data, 'maxGuests') ?? getFormValue(data, 'count'), 2),
    cleaningStatus: String(getFormValue(data, 'cleaningStatus') || '0'),
    remark: getFormValue(data, 'remark') || '',
  };
  return post<any>({ url: URL.create, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const updateApi = async (data: any) => {
  const id = Number(getFormValue(data, 'id'));
  if (!id) {
    return Promise.reject({ code: 400, msg: '缺少房源ID' });
  }
  const payload = {
    id,
    title: String(getFormValue(data, 'title') || ''),
    description: String(getFormValue(data, 'description') || ''),
    province: String(getFormValue(data, 'province') || ''),
    city: String(getFormValue(data, 'city') || ''),
    district: String(getFormValue(data, 'district') || ''),
    address: String(getFormValue(data, 'address') || ''),
    longitude: toNullableNumber(getFormValue(data, 'longitude')),
    latitude: toNullableNumber(getFormValue(data, 'latitude')),
    basePrice: toNumber(getFormValue(data, 'price') ?? getFormValue(data, 'basePrice'), 199),
    maxGuests: toNumber(getFormValue(data, 'maxGuests'), 2),
    cleaningStatus: String(getFormValue(data, 'cleaningStatus') || '0'),
    remark: String(getFormValue(data, 'remark') || ''),
  };
  return post<any>({ url: URL.update, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const auditApi = async (data: any) => {
  const id = Number(getFormValue(data, 'id'));
  if (!id) {
    return Promise.reject({ code: 400, msg: '缺少房源ID' });
  }
  const payload = {
    id,
    auditStatus: String(getFormValue(data, 'auditStatus') || '1'),
    publishStatus: getFormValue(data, 'publishStatus') ? String(getFormValue(data, 'publishStatus')) : undefined,
    remark: String(getFormValue(data, 'remark') || ''),
  };
  return post<any>({ url: URL.audit, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const publishApi = async (data: any) => {
  const id = Number(getFormValue(data, 'id'));
  if (!id) {
    return Promise.reject({ code: 400, msg: '缺少房源ID' });
  }
  return post<any>({ url: `${URL.publish}/${id}/publish`, data: {}, headers: {} });
};

const deleteApi = async (params: any) => {
  const id = Number(params?.id ?? params?.ids);
  return auditApi({ id, auditStatus: '2', publishStatus: '2', remark: 'deleted-by-front' });
};

const detailApi = async (params: any) => {
  const id = Number(params?.id ?? params);
  const res = await get<any>({ url: `${URL.detail}/${id}`, params: {}, headers: {} });
  console.log('[detailApi] response:', res);
  return { ...res, data: normalizeThing(res?.data) };
};

export { listApi, adminListApi, createApi, updateApi, deleteApi, detailApi, auditApi, publishApi };
