import { get, post } from '/@/utils/http/axios';

enum URL {
  list = '/api/homestay',
  update = '/api/homestay/calendar/update',
}

const listCalendarApi = async (homestayId: number | string, startDate?: string, endDate?: string) => {
  const id = Number(homestayId);
  if (!id) {
    return Promise.reject({ code: 400, msg: '缺少房源 ID' });
  }
  const params: Record<string, any> = {};
  if (startDate) params.startDate = startDate;
  if (endDate) params.endDate = endDate;
  return get<any>({ url: `${URL.list}/${id}/calendar/list`, params, headers: {} });
};

const updateCalendarApi = async (payload: {
  homestayId: number;
  startDate: string;
  endDate: string;
  status?: string;
  price?: number;
}) => {
  return post<any>({
    url: URL.update,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

export { listCalendarApi, updateCalendarApi };
