import { get, post } from '/@/utils/http/axios';

enum URL {
  landlordList = '/api/order/landlord/list',
  accept = '/api/order/accept',
}

// 房东订单列表
export const landlordListApi = async (params: any) => {
  const query: Record<string, any> = {
    pageNum: Number(params?.pageNum || 1),
    pageSize: Number(params?.pageSize || 10),
  };
  if (params?.orderStatus !== undefined && params?.orderStatus !== null) {
    query.orderStatus = String(params.orderStatus);
  }
  if (params?.checkinDate) {
    query.checkinDate = String(params.checkinDate);
  }
  if (params?.homestayName) {
    query.homestayName = String(params.homestayName);
  }
  return get<any>({ url: URL.landlordList, params: query, headers: {} });
};

// 房东接受订单
export const acceptApi = async (id: number) => {
  return post<any>({ url: `${URL.accept}/${id}`, data: {}, headers: {} });
};
