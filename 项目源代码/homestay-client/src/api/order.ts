import { get, post } from '/@/utils/http/axios';

enum URL {
  create = '/api/order/create',
  cancel = '/api/order/cancel',
  confirm = '/api/order/confirm',
  checkin = '/api/order/checkin',
  checkout = '/api/order/checkout',
  finish = '/api/order/finish',
  reject = '/api/order/reject',
  payMock = '/api/order/pay/mock',
  my = '/api/order/my',
}

const toDateText = (date: Date) => date.toISOString().slice(0, 10);

const getFormValue = (form: any, key: string) => {
  if (!form) return undefined;
  if (form instanceof FormData) return form.get(key);
  return form[key];
};

const toOldStatus = (orderStatus: string) => {
  return orderStatus;
};

const toCityCn = (city: string) => {
  const map: Record<string, string> = {
    Guangzhou: '广州',
    Shenzhen: '深圳',
    Shanghai: '上海',
    Beijing: '北京',
  };
  const raw = String(city || '');
  return map[raw] || raw;
};

const getHomestayMap = async (homestayIds: number[]) => {
  const ids = Array.from(new Set(homestayIds.filter(Boolean)));
  const pairs = await Promise.all(
    ids.map(async (id) => {
      try {
        const res = await get<any>({     url: `/api/homestay/detail/${id}`, params: {}, headers: {} });
        return [id, res?.data] as const;
      } catch (e) {
        return [id, null] as const;
      }
    }),
  );
  return new Map<number, any>(pairs);
};

const normalizeOrders = async (rows: any[]) => {
  const homestayMap = await getHomestayMap(rows.map((r) => Number(r.homestayId)));
  return rows.map((item) => {
    const homestay = homestayMap.get(Number(item.homestayId));
    const nights = Number(item.nights || 1);
    const amount = Number(item.amountPayable || item.amountTotal || 0);
    const fallbackPrice = nights > 0 ? amount / nights : amount;
    return {
      ...item,
      orderNumber: item.orderNo,
      orderTime: item.createTime,
      status: toOldStatus(item.orderStatus),
      thingId: item.homestayId,
      title: homestay?.title || `民宿#${item.homestayId}`,
      cover: homestay?.cover || '',
      cityCn: toCityCn(homestay?.city || ''),
      count: item.guestCount || 1,
      price: homestay?.basePrice ?? fallbackPrice,
      remark: item.remark || item.cancelReason || '',
      username: item.tenantUserId ? `U${item.tenantUserId}` : '',
      abnormalFlag: item.abnormalFlag,
      abnormalReason: item.abnormalReason,
    };
  });
};

const buildMyOrderQuery = (params: any = {}) => {
  const query: Record<string, any> = {
    pageNum: Number(params?.pageNum || 1),
    pageSize: Number(params?.pageSize || 10),
  };

  const roleType = params?.roleType;
  if (roleType !== undefined && roleType !== null && String(roleType).trim() !== '') {
    query.roleType = String(roleType).trim();
  } else if (roleType === undefined) {
    query.roleType = 'landlord';
  }

  if (params?.orderStatus !== undefined && params?.orderStatus !== null && String(params.orderStatus).trim() !== '') {
    query.orderStatus = String(params.orderStatus).trim();
  }
  if (params?.payStatus !== undefined && params?.payStatus !== null && String(params.payStatus).trim() !== '') {
    query.payStatus = String(params.payStatus).trim();
  }
  if (params?.orderNo !== undefined && params?.orderNo !== null && String(params.orderNo).trim() !== '') {
    query.orderNo = String(params.orderNo).trim();
  }
  return query;
};

const listApi = async (params: any) => {
  const res = await get<any>({ url: URL.my, params: buildMyOrderQuery(params), headers: {} });
  const rows = await normalizeOrders(res?.rows || []);
  return { ...res, data: rows, rows };
};

const userOrderListApi = async (params: any) => {
  const res = await get<any>({ url: URL.my, params: { roleType: 'tenant' }, headers: {} });
  let rows = await normalizeOrders(res?.rows || []);
  if (params?.status) {
    rows = rows.filter((it) => String(it.status) === String(params.status));
  }
  return { ...res, data: rows, rows };
};

const createApi = async (data: any) => {
  let homestayId = 0;
  if (data instanceof FormData) {
    homestayId = Number(data.get('thingId') ?? data.get('homestayId') ?? 0);
  } else {
    homestayId = Number(data?.homestayId ?? data?.thingId ?? 0);
  }
  
  if (!homestayId || homestayId <= 0) {
    return Promise.reject({ code: 400, msg: '房源ID无效' });
  }
  
  const guestCount = Number(data?.guestCount ?? data?.count ?? 1);
  const today = new Date();
  const checkin = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 1);
  const checkout = new Date(today.getFullYear(), today.getMonth(), today.getDate() + 2);
  const payload = {
    homestayId,
    checkinDate: String(data?.checkinDate || toDateText(checkin)),
    checkoutDate: String(data?.checkoutDate || toDateText(checkout)),
    guestCount: guestCount > 0 ? guestCount : 1,
  };
  console.log('[createApi] payload:', payload);
  return post<any>({ url: URL.create, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const updateApi = async (_params: any, data: any) => {
  const orderId = Number(getFormValue(data, 'id') ?? getFormValue(data, 'orderId'));
  return post<any>({ url: URL.confirm, data: { orderId }, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const checkinApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.checkin,
    data: { orderId, reason: String(params?.reason || 'checkin-by-landlord') },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const checkoutApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.checkout,
    data: { orderId, reason: String(params?.reason || 'checkout-by-landlord') },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const finishApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.finish,
    data: { orderId, reason: String(params?.reason || 'finish-by-admin') },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const deleteApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.ids);
  return post<any>({
    url: URL.cancel,
    data: { orderId, reason: 'delete-from-page' },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const cancelApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.cancel,
    data: { orderId, reason: 'cancel-by-landlord' },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const cancelUserOrderApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.cancel,
    data: { orderId, reason: 'cancel-by-tenant' },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const rejectApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.reject,
    data: { orderId, reason: String(params?.reason || 'rejected-by-landlord') },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const payMockApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: URL.payMock,
    data: { orderId },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const queryMyOrderById = async (orderId: number) => {
  if (!orderId) return null;
  const roleTypes = ['tenant', 'landlord', ''];
  for (const roleType of roleTypes) {
    try {
      const query: Record<string, any> = { pageNum: 1, pageSize: 200 };
      if (roleType) query.roleType = roleType;
      const res = await get<any>({ url: URL.my, params: query, headers: {} });
      const rows = Array.isArray(res?.rows) ? res.rows : [];
      const hit = rows.find((item: any) => Number(item?.id) === Number(orderId));
      if (hit) return hit;
    } catch (_e) {
      // try next role type
    }
  }
  return null;
};

const wxPrepayApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  if (!orderId) {
    return Promise.reject({ code: 400, msg: '缺少orderId' });
  }
  const hit = await queryMyOrderById(orderId);
  const amount = Number(hit?.amountPayable ?? hit?.amountTotal ?? params?.amount ?? 0);
  return Promise.resolve({
    code: 200,
    msg: 'ok',
    data: {
      orderId,
      prepayNo: `WXMOCK${Date.now()}${String(orderId).padStart(4, '0')}`,
      amount: Number.isFinite(amount) ? amount : 0,
      expireTime: Date.now() + 15 * 60 * 1000,
      payStatus: String(hit?.payStatus ?? '0'),
    },
  });
};

const wxMockNotifyApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  if (!orderId) {
    return Promise.reject({ code: 400, msg: '缺少orderId' });
  }
  if (params?.success === false) {
    return Promise.resolve({ code: 200, msg: 'ok', data: { orderId, payStatus: '0' } });
  }
  const res = await payMockApi({ orderId });
  return {
    ...res,
    data: {
      ...(res?.data || {}),
      orderId,
      payStatus: '1',
      paid: true,
    },
  };
};

const payStatusApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  if (!orderId) {
    return Promise.reject({ code: 400, msg: '缺少orderId' });
  }
  const hit = await queryMyOrderById(orderId);
  if (!hit) {
    return Promise.reject({ code: 404, msg: '订单不存在或无权限查看' });
  }
  return Promise.resolve({
    code: 200,
    msg: 'ok',
    data: {
      orderId,
      payStatus: String(hit?.payStatus ?? '0'),
      orderStatus: String(hit?.orderStatus ?? ''),
      payTime: hit?.payTime || '',
    },
  });
};

const alipayCreateApi = async (params: any) => {
  const orderId = Number(params?.id ?? params?.orderId);
  return post<any>({
    url: '/api/order/pay/alipay/create',
    data: { orderId, amount: params?.amount || 0 },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const alipayStatusApi = async (orderId: number) => {
  return get<any>({ url: '/api/order/pay/alipay/status', params: { orderId }, data: {}, headers: {} });
};

const subscribeSseApi = () => {
  const baseUrl = (window as any).BASE_URL || 'http://localhost:8083';
  return `${baseUrl}/api/order/message/subscribe`;
};

export {
  listApi,
  userOrderListApi,
  createApi,
  updateApi,
  checkinApi,
  checkoutApi,
  finishApi,
  deleteApi,
  cancelApi,
  cancelUserOrderApi,
  rejectApi,
  payMockApi,
  wxPrepayApi,
  wxMockNotifyApi,
  payStatusApi,
  alipayCreateApi,
  alipayStatusApi,
  subscribeSseApi,
};
