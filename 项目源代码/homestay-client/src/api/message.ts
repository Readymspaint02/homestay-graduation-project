import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/message/my',
  read = '/api/message/read',
}

const TITLE_MAP: Record<string, string> = {
  'new booking': '新订单通知',
  'order cancelled': '订单已取消',
  'order confirmed': '订单已确认',
  'order rejected': '订单已拒绝',
  'tenant checked in': '租客已入住',
  'order paid': '订单已支付',
};

const translateTitle = (title: any) => {
  const raw = String(title || '').trim();
  if (!raw) return '系统消息';
  return TITLE_MAP[raw.toLowerCase()] || raw;
};

const translateContent = (content: any) => {
  const raw = String(content || '').trim();
  if (!raw) return '';

  const lower = raw.toLowerCase();
  if (lower.startsWith('new order:')) return raw.replace(/new order:/i, '新订单：');
  if (lower.startsWith('order cancelled:')) return raw.replace(/order cancelled:/i, '订单已取消：');
  if (lower.startsWith('landlord confirmed:')) return raw.replace(/landlord confirmed:/i, '房东已确认：');
  if (lower.startsWith('landlord rejected:')) return raw.replace(/landlord rejected:/i, '房东已拒绝：');
  if (lower.startsWith('tenant checked in:')) return raw.replace(/tenant checked in:/i, '租客已确认入住：');
  if (lower.startsWith('order paid:')) return raw.replace(/order paid:/i, '订单已支付：');
  return raw;
};

const listApi = async (params: any) => {
  const query = {
    pageNum: params?.pageNum || 1,
    pageSize: params?.pageSize || 50,
  };
  const res = await get<any>({ url: URL.list, params: query, data: {}, headers: {} });
  const rows = res?.rows || [];
  const data = rows.map((item: any) => ({
    ...item,
    id: item.id,
    title: translateTitle(item.title),
    content: translateContent(item.content),
    createTime: item.createTime,
    isRead: item.isRead,
  }));
  return { ...res, data, rows: data };
};

const readApi = async (messageId: number) => {
  if (!messageId) {
    return Promise.resolve({ code: 200, msg: 'ok', data: null });
  }
  return post<any>({ url: `${URL.read}/${messageId}`, params: {}, data: {}, headers: {} });
};

const deleteApi = async (params: any) => {
  const messageId = Number(params?.id ?? params?.ids);
  return readApi(messageId);
};

export { listApi, readApi, deleteApi };
