// 权限问题后期增加
import { get, post } from '/@/utils/http/axios';
import { UserState } from '/@/store/modules/user/types';
// import axios from 'axios';
enum URL {
    userWishList = '/api/thingWish/getUserWishList',
    wish = '/api/thingWish/wish',
    unWish = '/api/thingWish/unWish',
}

const normalizeThingId = (input: any) => Number(input?.thingId ?? input?.id ?? 0)

const wishApi = async (data: any) => {
    const thingId = normalizeThingId(data)
    return post<any>({ url: URL.wish, params: { thingId, id: thingId }, data: {}, headers: {} })
}
const unWishApi = async (params: any) => {
    const thingId = normalizeThingId(params)
    return post<any>({ url: URL.unWish, params: { thingId, id: thingId }, data: {}, headers: {} })
}
const userWishListApi = async (params: any) => get<any>({ url: URL.userWishList, params: params });

export { wishApi, unWishApi, userWishListApi };
