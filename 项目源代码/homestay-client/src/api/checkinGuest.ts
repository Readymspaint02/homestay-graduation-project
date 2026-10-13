import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/order/checkin-guest/list',
  save = '/api/order/checkin-guest/save',
}

const listApi = async (orderId: number | string) =>
  get<any>({
    url: URL.list,
    params: { orderId: Number(orderId) || 0 },
    data: {},
    headers: {},
  });

const saveApi = async (payload: { orderId: number; guests: Array<any> }) =>
  post<any>({
    url: URL.save,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

export { listApi, saveApi };
