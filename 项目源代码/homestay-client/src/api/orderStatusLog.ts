import { get } from '/@/utils/http/axios';

enum URL {
  list = '/api/order/status-log',
}

const listApi = async (orderId: number | string) => {
  const id = Number(orderId);
  if (!id) {
    return Promise.resolve({ code: 200, msg: 'ok', data: [] });
  }
  return get<any>({
    url: `${URL.list}/${id}`,
    params: {},
    data: {},
    headers: {},
  });
};

export { listApi };
