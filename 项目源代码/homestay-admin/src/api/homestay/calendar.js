import request from '@/utils/request'

// 获取房态日历数据
export function getCalendarData(homestayId, year, month) {
  return request({
    url: `/api/homestay/${homestayId}/calendar`,
    method: 'get',
    params: { year, month }
  })
}

// 获取日历列表
export function listCalendar(homestayId, startDate, endDate) {
  return request({
    url: `/api/homestay/${homestayId}/calendar/list`,
    method: 'get',
    params: { startDate, endDate }
  })
}

// 锁定日期（设为维护中）
export function lockDate(homestayId, date) {
  return request({
    url: `/api/homestay/${homestayId}/calendar/lock`,
    method: 'post',
    data: { date }
  })
}

// 解锁日期（恢复可订）
export function unlockDate(homestayId, date) {
  return request({
    url: `/api/homestay/${homestayId}/calendar/unlock`,
    method: 'post',
    data: { date }
  })
}
