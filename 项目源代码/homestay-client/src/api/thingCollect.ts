
import { get, post } from '/@/utils/http/axios';
import { UserState } from '/@/store/modules/user/types';

enum URL {
    userCollectList = '/api/thingCollect/getUserCollectList',
    isCollected = '/api/thingCollect/isCollected',
    collect = '/api/thingCollect/collect',
    unCollect = '/api/thingCollect/unCollect',
}

const normalizeThingId = (input: any) => Number(input?.thingId ?? input?.id ?? 0)

const collectApi = async (data: any) => {
    const thingId = normalizeThingId(data)
    return post<any>({ url: URL.collect, params: { thingId, id: thingId }, data: {}, headers: {} })
}
const unCollectApi = async (params: any) => {
    const thingId = normalizeThingId(params)
    return post<any>({ url: URL.unCollect, params: { thingId, id: thingId }, data: {}, headers: {} })
}
const userCollectListApi = async (params: any) => get<any>({ url: URL.userCollectList, params: params });
const isCollectedApi = async (userId: number, homestayId: number) => get<any>({ url: URL.isCollected, params: { userId, homestayId } });

export { collectApi, unCollectApi, userCollectListApi, isCollectedApi };
