import {get, post} from '/@/utils/http/axios';

enum URL {
    loginLogList = '/monitor/logininfor/list',
    opLogList = '/monitor/operlog/list',
    errorLogList = '/monitor/operlog/list',
}

const listLoginLogApi = async (params: any) => {
    const res = await get<any>({url: URL.loginLogList, params: params, data: {}, headers: {}});
    const rows = (res?.rows || []).map((item: any) => ({
        id: item.infoId,
        reIp: item.ipaddr,
        reUa: `${item.browser || ''} ${item.os || ''}`.trim(),
        reTime: item.loginTime
    }));
    return {...res, data: rows, rows};
};

const listOpLogListApi = async (params: any) => {
    const res = await get<any>({url: URL.opLogList, params: params, data: {}, headers: {}});
    const rows = res?.rows || [];
    return {...res, data: rows, rows};
};

const listErrorLogListApi = async (params: any) => {
    const query = {...params, status: 1};
    const res = await get<any>({url: URL.errorLogList, params: query, data: {}, headers: {}});
    const rows = res?.rows || [];
    return {...res, data: rows, rows};
};

export {listLoginLogApi, listOpLogListApi, listErrorLogListApi};
