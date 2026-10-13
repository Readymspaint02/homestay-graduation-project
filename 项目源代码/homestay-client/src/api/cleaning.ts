import { get, post } from '/@/utils/http/axios';

enum URL {
  calendar = '/api/homestay',
  lock = '/api/homestay',
  unlock = '/api/homestay',
  list = '/api/homestay',
}

// 获取房态日历数据
export const getCalendarDataApi = async (homestayId: number, year?: string, month?: string) => {
  const params: Record<string, any> = {};
  if (year) params.year = year;
  if (month) params.month = month;
  return get<any>({ url: `${URL.calendar}/${homestayId}/calendar`, params, headers: {} });
};

// 获取日历列表
export const listApi = async (homestayId: number, startDate?: string, endDate?: string) => {
  const params: Record<string, any> = {};
  if (startDate) params.startDate = startDate;
  if (endDate) params.endDate = endDate;
  return get<any>({ url: `${URL.list}/${homestayId}/calendar/list`, params, headers: {} });
};

// 锁定日期（设为维护中）
export const lockApi = async (homestayId: number, date: string) => {
  return post<any>({ url: `${URL.lock}/${homestayId}/calendar/lock`, data: { date }, headers: {} });
};

// 解锁日期（恢复可订）
export const unlockApi = async (homestayId: number, date: string) => {
  return post<any>({ url: `${URL.unlock}/${homestayId}/calendar/unlock`, data: { date }, headers: {} });
};
