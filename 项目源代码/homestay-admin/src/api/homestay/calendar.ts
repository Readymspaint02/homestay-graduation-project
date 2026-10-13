import { get, post } from '/@/utils/http/axios';

enum URL {
  calendar = '/api/homestay/calendar',
  lock = '/api/homestay/calendar/lock',
  unlock = '/api/homestay/calendar/unlock',
  list = '/api/homestay/calendar/list',
}

// 获取房态日历数据
export const getCalendarDataApi = async (homestayId: number, year?: string, month?: string) => {
  const params: Record<string, any> = {};
  if (year) params.year = year;
  if (month) params.month = month;
  return get<any>({ url: `${URL.calendar}/${homestayId}`, params, headers: {} });
};

// 获取日历列表
export const listApi = async (homestayId: number, startDate?: string, endDate?: string) => {
  const params: Record<string, any> = {};
  if (startDate) params.startDate = startDate;
  if (endDate) params.endDate = endDate;
  return get<any>({ url: `${URL.list}/${homestayId}`, params, headers: {} });
};

// 锁定日期（设为维护中）
export const lockApi = async (homestayId: number, date: string) => {
  return post<any>({ url: `${URL.lock}/${homestayId}`, data: { date }, headers: {} });
};

// 解锁日期（恢复可订）
export const unlockApi = async (homestayId: number, date: string) => {
  return post<any>({ url: `${URL.unlock}/${homestayId}`, data: { date }, headers: {} });
};
