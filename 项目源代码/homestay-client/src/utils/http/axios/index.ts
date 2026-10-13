import axios from 'axios';
import type { AxiosInstance, AxiosRequestConfig, AxiosResponse, AxiosError, InternalAxiosRequestConfig } from 'axios';
import { IResponse } from './type';
import { ADMIN_USER_TOKEN, USER_TOKEN, BASE_URL, RUOYI_CLIENT_ID } from '/@/store/constants'

const toBearerToken = (token?: string | null) => {
  if (!token) return undefined
  return token.startsWith('Bearer ') ? token : `Bearer ${token}`
}

const service: AxiosInstance = axios.create({
  baseURL: BASE_URL + '',
  timeout: 5000,
});

const getPathname = () => {
  try {
    return String(window?.location?.pathname || '');
  } catch (_e) {
    return '';
  }
};

const pickTokenByPage = (adminToken?: string | null, userToken?: string | null) => {
  const pathname = getPathname();
  const inAdminPage = pathname.startsWith('/admin');
  if (inAdminPage) {
    return adminToken || userToken;
  }
  return userToken || adminToken;
};

// axios实例拦截请求
service.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const adminToken = localStorage.getItem(ADMIN_USER_TOKEN)
    const userToken = localStorage.getItem(USER_TOKEN)
    const token = pickTokenByPage(adminToken, userToken)
    const requestAuth = String(config.headers.Authorization || '')

    config.headers.ADMINTOKEN = adminToken
    config.headers.TOKEN = userToken
    if (!config.headers.clientid) {
      config.headers.clientid = RUOYI_CLIENT_ID
    }

    const authToken = toBearerToken(requestAuth) || toBearerToken(token)
    if (authToken) {
      config.headers.Authorization = authToken
    }

    return config;
  },
  (error: AxiosError) => {
    return Promise.reject(error);
  },
);

// axios实例拦截响应
service.interceptors.response.use(
  (response: AxiosResponse) => {
    if(response.status == 200) {
      if(response.data.code == 0 || response.data.code == 200) {
        return response.data
      }else {
        return Promise.reject(response.data)
      }
    } else {
      return Promise.reject(response.data)
    }
  },
  // 请求失败
  (error: any) => {
    const status = error?.response?.status
    if(status == 404) {
      // todo
    } else if(status == 403) {
      // todo
    }
    return Promise.reject(error?.response?.data || error)
  },
);



const request = <T = any>(config: AxiosRequestConfig): Promise<T> => {
  const conf = config;
  return new Promise((resolve, reject) => {
    service.request<any, AxiosResponse<IResponse>>(conf).then((res: any) => {
      // 拦截器已经返回了 response.data，直接使用
      resolve(res as T);
    }).catch(err => {
      reject(err)
    });
  });
};

export function get<T = any>(config: AxiosRequestConfig): Promise<T> {
  return request({ ...config, method: 'GET' });
}

export function post<T = any>(config: AxiosRequestConfig): Promise<T> {
  return request({ ...config, method: 'POST' });
}

export function put<T = any>(config: AxiosRequestConfig): Promise<T> {
  return request({ ...config, method: 'PUT' });
}

export function del<T = any>(config: AxiosRequestConfig): Promise<T> {
  return request({ ...config, method: 'DELETE' });
}

export default request;

export type { AxiosInstance, AxiosResponse };
