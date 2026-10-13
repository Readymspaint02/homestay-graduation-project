import { get, post } from '/@/utils/http/axios';

enum URL {
  create = '/api/order/exception/create',
  list = '/api/order/exception/list',
  assign = '/api/order/exception/assign',
  resolve = '/api/order/exception/resolve',
  close = '/api/order/exception/close',
}

const createApi = async (data: any) =>
  post<any>({
    url: URL.create,
    data,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const listApi = async (params: any) =>
  get<any>({
    url: URL.list,
    params: {
      pageNum: params?.pageNum || 1,
      pageSize: params?.pageSize || 10,
      orderId: params?.orderId,
      exceptionType: params?.exceptionType,
      status: params?.status,
    },
    data: {},
    headers: {},
  });

const assignApi = async (data: any) =>
  post<any>({
    url: URL.assign,
    data,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const resolveApi = async (data: any) =>
  post<any>({
    url: URL.resolve,
    data,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

const closeApi = async (data: any) =>
  post<any>({
    url: URL.close,
    data,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });

export { createApi, listApi, assignApi, resolveApi, closeApi };
