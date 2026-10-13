import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/review/list',
  my = '/api/review/my',
  create = '/api/review/create',
}

const normalizeReview = (item: any) => ({
  ...item,
  commentTime: item.createTime,
  username: item.isAnonymous === '1' ? '匿名用户' : `U${item.tenantUserId || ''}`,
  likeCount: item.likeCount || 0,
});

const listApi = async (params: any) => {
  const homestayId = params?.homestayId ?? params?.thingId;
  const res = await get<any>({ url: URL.list, params: { homestayId }, data: {}, headers: {} });
  const data = (res?.data || []).map((it: any) => normalizeReview(it));
  return { ...res, data };
};

const createApi = async (data: any) => {
  const orderId = Number(data?.orderId || 0);
  if (!orderId) {
    return Promise.reject({ code: 400, msg: '缺少订单ID' });
  }
  const payload = {
    orderId,
    rating: Number(data?.rating || 5),
    content: data?.content || '',
    isAnonymous: data?.isAnonymous || '0',
  };
  return post<any>({ url: URL.create, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const listMyApi = async () => {
  const res = await get<any>({ url: URL.my, params: {}, data: {}, headers: {} });
  const data = (res?.data || []).map((it: any) => normalizeReview(it));
  return { ...res, data };
};

const deleteApi = async (_params: any) => Promise.resolve({ code: 200, msg: '当前版本未开放删除评论', data: null });

const listThingCommentsApi = async (params: any) => listApi(params);

const listUserCommentsApi = async (_params: any) => {
  const res = await listMyApi();
  const reviews = res?.data || [];
  const data = reviews.map((item: any) => ({
    ...item,
    thingId: item.homestayId,
    title: item.title || `民宿#${item.homestayId}`,
    cover: item.cover || '',
  }));
  return { ...res, data };
};

const likeApi = async (_params: any) => Promise.resolve({ code: 200, msg: 'ok', data: null });

export { listApi, createApi, deleteApi, listThingCommentsApi, listUserCommentsApi, likeApi, listMyApi };
