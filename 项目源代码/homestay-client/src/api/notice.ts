import { del, get, post, put } from '/@/utils/http/axios';

enum URL {
  list = '/system/notice/list',
  create = '/system/notice',
  update = '/system/notice',
  detail = '/system/notice',
}

const listApi = async (params: any) => {
  const query = {
    noticeTitle: params?.keyword || params?.title,
    pageNum: params?.pageNum || 1,
    pageSize: params?.pageSize || 100,
  };
  const res = await get<any>({ url: URL.list, params: query, data: {}, headers: {} });
  const rows = (res?.rows || []).map((item: any) => ({
    id: item.noticeId,
    title: item.noticeTitle,
    content: item.noticeContent,
    noticeType: item.noticeType,
    status: item.status,
    createTime: item.createTime,
    updateTime: item.updateTime,
  }));
  return { ...res, data: rows, rows };
};

const createApi = async (data: any) => {
  const payload = {
    noticeTitle: String(data?.title || ''),
    noticeContent: String(data?.content || ''),
    noticeType: String(data?.noticeType || '1'),
    status: String(data?.status || '0'),
    remark: String(data?.remark || ''),
  };
  return post<any>({
    url: URL.create,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const updateApi = async (data: any) => {
  const payload = {
    noticeId: Number(data?.id || data?.noticeId),
    noticeTitle: String(data?.title || ''),
    noticeContent: String(data?.content || ''),
    noticeType: String(data?.noticeType || '1'),
    status: String(data?.status || '0'),
    remark: String(data?.remark || ''),
  };
  return put<any>({
    url: URL.update,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const deleteApi = async (params: any) => {
  const ids = String(params?.id ?? params?.ids ?? '')
    .split(',')
    .map((it) => it.trim())
    .filter(Boolean);
  if (ids.length === 0) {
    return Promise.resolve({ code: 200, msg: 'ok', data: null });
  }
  return del<any>({ url: `${URL.detail}/${ids.join(',')}`, params: {}, headers: {} });
};

export { listApi, createApi, updateApi, deleteApi };
