import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/supervision/report/list',
  stats = '/api/supervision/report/stats',
  generate = '/api/supervision/report/generate',
  process = '/api/supervision/report/process',
  push = '/api/supervision/report/push',
  retry = '/api/supervision/report/retry',
  retryBatch = '/api/supervision/report/retry/batch',
}

const listApi = async (params: any) => {
  const query = {
    pageNum: params?.pageNum || 1,
    pageSize: params?.pageSize || 10,
  };
  const res = await get<any>({ url: URL.list, params: query, data: {}, headers: {} });
  const rows = (res?.rows || []).map((item: any, index: number) => ({
    ...item,
    index: index + 1,
  }));
  return { ...res, rows, data: rows };
};

const statsApi = async () =>
  get<any>({ url: URL.stats, params: {}, data: {}, headers: {} });

const generateApi = async (limit = 50) =>
  post<any>({
    url: URL.generate,
    params: { limit },
    data: {},
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const processApi = async (limit = 50) =>
  post<any>({
    url: URL.process,
    params: { limit },
    data: {},
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const pushApi = async (params: any) =>
  post<any>({
    url: URL.push,
    data: {
      reportType: String(params?.reportType || '3'),
      bizId: Number(params?.bizId || Date.now()),
      requestJson: String(params?.requestJson || '{"scene":"manual-demo"}'),
    },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const retryApi = async (id: number | string) =>
  post<any>({
    url: `${URL.retry}/${Number(id)}`,
    data: {},
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const retryBatchApi = async (ids: Array<number | string>) =>
  post<any>({
    url: URL.retryBatch,
    data: (ids || []).map((id) => Number(id)).filter((id) => Number.isFinite(id) && id > 0),
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

export { listApi, statsApi, generateApi, processApi, pushApi, retryApi, retryBatchApi };
