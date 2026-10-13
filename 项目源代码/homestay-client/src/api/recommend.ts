import { get, post } from '/@/utils/http/axios';

enum URL {
  forYou = '/api/recommend/for-you',
  similar = '/api/recommend/similar',
  popular = '/api/recommend/popular',
  behavior = '/api/recommend/behavior',
}

const getForYouApi = async (limit = 6) => {
  return get<any>({ url: URL.forYou, params: { limit }, data: {}, headers: {} });
};

const getSimilarApi = async (homestayId: number, limit = 6) => {
  return get<any>({ url: `${URL.similar}/${homestayId}`, params: { limit }, data: {}, headers: {} });
};

const getPopularApi = async (limit = 6) => {
  return get<any>({ url: URL.popular, params: { limit }, data: {}, headers: {} });
};

const recordBehaviorApi = async (homestayId: number, type = 'view') => {
  return post<any>({ url: URL.behavior, params: { homestayId, type }, data: {}, headers: {} });
};

export { getForYouApi, getSimilarApi, getPopularApi, recordBehaviorApi };
