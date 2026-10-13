import { del, get, post, put } from '/@/utils/http/axios';
import { BASE_URL, RUOYI_CLIENT_ID, USER_ID, USER_NAME } from '/@/store/constants';
import { encryptPassword } from '/@/utils/jsencrypt';

enum URL {
  profile = '/system/user/profile',
  profileAvatar = '/system/user/profile/avatar',
  profilePwd = '/system/user/profile/updatePwd',
  userList = '/system/user/list',
  user = '/system/user',
}

const DEFAULT_DEPT_ID = 103;
const DEFAULT_TENANT_ID = (import.meta.env.VITE_TENANT_ID as string) || '000000';
const DEFAULT_GRANT_TYPE = (import.meta.env.VITE_GRANT_TYPE as string) || 'password';
const DEFAULT_FALLBACK_BASES = (import.meta.env.VITE_API_FALLBACK_BASES as string) || '';
const AUTH_FAST_ONLY = String((import.meta.env.VITE_AUTH_FAST_ONLY as string) || 'true') === 'true';
const AUTH_PATHS = {
  login: ['/login'],
  logout: ['/logout'],
  register: ['/register'],
  getInfo: ['/getInfo'],
  captchaImage: ['/captchaImage'],
};

export interface LoginData {
  username: string;
  password: string;
  code?: string;
  uuid?: string;
}

const getFormValue = (form: any, key: string) => {
  if (!form) return undefined;
  if (form instanceof FormData) return form.get(key);
  return form[key];
};

const PROFILE_EXTRA_PREFIX = 'profile_extra_';
const getProfileExtraKey = (userId?: string | number | null) => {
  const raw = String(userId ?? localStorage.getItem(USER_ID) ?? '').trim();
  return `${PROFILE_EXTRA_PREFIX}${raw || 'unknown'}`;
};

const readProfileExtra = (userId?: string | number | null) => {
  try {
    const raw = localStorage.getItem(getProfileExtraKey(userId));
    return raw ? JSON.parse(raw) : {};
  } catch (_e) {
    return {};
  }
};

const saveProfileExtra = (userId: string | number | null | undefined, patch: Record<string, any>) => {
  if (!patch || typeof patch !== 'object') return;
  const current = readProfileExtra(userId);
  const next = { ...current, ...patch };
  Object.keys(next).forEach((key) => {
    if (next[key] === undefined || next[key] === null) delete next[key];
  });
  try {
    localStorage.setItem(getProfileExtraKey(userId), JSON.stringify(next));
  } catch (_e) {
    // ignore localStorage quota errors
  }
};

const normalizeText = (value: any) => String(value ?? '').trim();

const roleToOldValue = (roles: any) => {
  const roleList = Array.isArray(roles) ? roles : [];
  const text = roleList.join(',').toLowerCase();
  if (text.includes('superadmin') || text.includes('admin')) return '3';
  if (text.includes('hs:landlord') || text.includes('landlord')) return '2';
  return '1';
};

const normalizeBaseUrl = (url: string) =>
  String(url || '')
    .trim()
    .replace(/\/+$/, '');
const normalizeApiPath = (path: string) => {
  const text = String(path || '').trim();
  if (!text) return '';
  if (/^https?:\/\//i.test(text)) return text;
  return text.startsWith('/') ? text : `/${text}`;
};

const parsePathname = (url: string) => {
  try {
    return new URL(url, `${normalizeBaseUrl(BASE_URL) || 'http://127.0.0.1'}/`).pathname || '';
  } catch (_e) {
    return String(url || '');
  }
};

const isAuthNamespacePath = (url: string) => /\/auth\/(login|logout|register|code)$/i.test(parsePathname(url));

const buildApiBaseCandidates = () => {
  const result: string[] = [];
  const push = (value?: string) => {
    const base = normalizeBaseUrl(String(value || ''));
    if (!base || result.includes(base)) return;
    result.push(base);
  };

  push(BASE_URL);
  DEFAULT_FALLBACK_BASES.split(',')
    .map((item) => item.trim())
    .filter(Boolean)
    .forEach((item) => push(item));

  if (typeof window !== 'undefined') {
    const { protocol, hostname } = window.location;
    push(`${protocol}//${hostname}:8083`);
  } else {
    push('http://127.0.0.1:8083');
  }

  return result;
};

const API_BASE_CANDIDATES = buildApiBaseCandidates();

const resolveUrlCandidates = (url: string) => {
  const normalized = normalizeApiPath(url);
  if (!normalized) return [];
  if (/^https?:\/\//i.test(normalized)) return [normalized];
  const candidates = [normalized];
  API_BASE_CANDIDATES.forEach((base) => {
    candidates.push(`${base}${normalized}`);
  });
  return Array.from(new Set(candidates));
};

const roleToIds = (role: any): number[] => {
  const roleValue = String(role ?? '');
  if (roleValue === '3') return [1];
  if (roleValue === '2') return [200];
  return [201];
};

const isAdminRole = (roles: any) => {
  const roleList = Array.isArray(roles) ? roles : [];
  return roleList.some((item) =>
    String(item || '')
      .toLowerCase()
      .includes('admin'),
  );
};

const withBearer = (token: string) => (token.startsWith('Bearer ') ? token : `Bearer ${token}`);
const normalizeCredential = (value: any) => String(value ?? '').trim();
const errorText = (err: any) =>
  [
    err?.msg,
    err?.message,
    err?.error,
    err?.data?.msg,
    err?.data?.message,
    err?.response?.data?.msg,
    err?.response?.data?.message,
    err?.response?.statusText,
  ]
    .filter(Boolean)
    .join(' ');
const errorCode = (err: any) =>
  Number(err?.code ?? err?.status ?? err?.data?.code ?? err?.response?.data?.code ?? err?.response?.status ?? 0);
const isNotFoundError = (err: any) =>
  errorCode(err) === 404 || /No static resource|NoResourceFoundException|Cannot GET|Cannot POST|404|not found/i.test(errorText(err));
const isNetworkError = (err: any) =>
  /Network Error|ERR_NETWORK|ERR_CONNECTION_REFUSED|ECONNREFUSED|timeout|Failed to fetch/i.test(errorText(err));
const isRetryableFallbackError = (err: any) => isNotFoundError(err) || isNetworkError(err);

const requestWithFallback = async <T>(urls: string[], executor: (url: string) => Promise<T>) => {
  let lastError: any;
  for (const logicalUrl of urls) {
    const candidates = resolveUrlCandidates(logicalUrl);
    for (const url of candidates) {
      try {
        return await executor(url);
      } catch (err: any) {
        lastError = err;
        if (!isRetryableFallbackError(err)) {
          throw err;
        }
      }
    }
  }
  throw lastError;
};

type AuthPathKey = keyof typeof AUTH_PATHS;

const requestAuth = async <T>(key: AuthPathKey, executor: (url: string) => Promise<T>) => {
  const urls = AUTH_PATHS[key] || [];
  if (!urls.length) {
    return Promise.reject({ code: 500, msg: `missing auth path for ${key}` });
  }
  if (!AUTH_FAST_ONLY) {
    return requestWithFallback<T>(urls, executor);
  }
  try {
    return await executor(urls[0]);
  } catch (err: any) {
    if (!isRetryableFallbackError(err)) {
      throw err;
    }
    if (urls.length <= 1) {
      throw err;
    }
    return requestWithFallback<T>(urls.slice(1), executor);
  }
};

const encryptCache = new Map<string, { value: string; ts: number }>();
const ENCRYPT_CACHE_TTL = 30000;

const encryptPasswordCached = (text: string) => {
  const cached = encryptCache.get(text);
  if (cached && Date.now() - cached.ts < ENCRYPT_CACHE_TTL) {
    return cached.value;
  }
  const value = encryptPassword(text);
  if (value) {
    encryptCache.set(text, { value, ts: Date.now() });
  }
  return value;
};

const buildLoginPayload = (data: LoginData, url: string) => {
  const username = normalizeCredential(data.username);
  const payload: Record<string, any> = {
    username,
    password: encryptPasswordCached(data.password) || data.password,
    code: data.code,
    uuid: data.uuid,
    phonenumber: username,
  };
  if (isAuthNamespacePath(url)) {
    payload.clientId = RUOYI_CLIENT_ID;
    payload.grantType = DEFAULT_GRANT_TYPE;
    payload.tenantId = DEFAULT_TENANT_ID;
  }
  return payload;
};

const buildRegisterPayload = (data: any, url: string) => {
  const mobile = normalizeCredential(data?.mobile || data?.username);
  const payload: Record<string, any> = {
    username: mobile,
    phonenumber: mobile,
    nickName: mobile,
    mobile,
    password: data?.password,
    role: data?.role || 'hs:tenant',
    code: data?.code,
    uuid: data?.uuid,
  };
  if (isAuthNamespacePath(url)) {
    payload.tenantId = DEFAULT_TENANT_ID;
  }
  return payload;
};

const fetchUserInfoByToken = async (accessToken: string) => {
  const headers = {
    Authorization: withBearer(accessToken),
    clientid: RUOYI_CLIENT_ID,
  };
  return requestAuth<any>('getInfo', (url) =>
    get<any>({
      url,
      params: {},
      headers,
    }),
  );
};

const loginByRole = async (data: LoginData, adminMode: boolean) => {
  const loginRes = await requestAuth<any>('login', (url) =>
    post<any>({
      url,
      data: buildLoginPayload(data, url),
      headers: { 'Content-Type': 'application/json;charset=utf-8' },
    }),
  );
  const accessToken = loginRes?.token || loginRes?.data?.token || loginRes?.data?.access_token;
  if (!accessToken) {
    return Promise.reject({ code: 500, msg: '登录响应缺少access_token' });
  }

  const infoRes = await fetchUserInfoByToken(accessToken);
  const user = infoRes?.user || infoRes?.data?.user || {};
  const roles = infoRes?.roles || infoRes?.data?.roles || [];

  if (adminMode && !isAdminRole(roles)) {
    try {
      const headers = {
        Authorization: withBearer(accessToken),
        clientid: RUOYI_CLIENT_ID,
      };
      await requestAuth<any>('logout', (url) =>
        post<any>({
          url,
          data: {},
          headers,
        }),
      );
    } catch (_e) {
      // ignore logout errors for non-admin login attempts
    }
    return Promise.reject({ code: 403, msg: '当前账号不是管理员账号' });
  }

  return {
    code: 200,
    msg: '操作成功',
    data: {
      id: user?.userId,
      username: user?.nickName || user?.userName || data.username,
      userName: user?.userName || data.username,
      token: accessToken,
      roles,
    },
  };
};

const normalizeProfile = (profileRes: any) => {
  const profile = profileRes?.data?.user || {};
  return {
    id: profile?.userId,
    username: profile?.userName,
    nickname: profile?.nickName,
    email: profile?.email,
    mobile: profile?.phonenumber,
    avatar: profile?.avatar || '',
    description: '',
    pushEmail: profile?.email || '',
    pushSwitch: '0',
    score: 0,
  };
};

const listApi = async (params: any) => {
  const query = {
    userName: params?.keyword || params?.userName,
    pageNum: params?.pageNum || 1,
    pageSize: params?.pageSize || 100,
  };
  const res = await get<any>({ url: URL.userList, params: query, headers: {} });
  const rows = (res?.rows || []).map((item: any, index: number) => ({
    id: item.userId,
    username: item.userName,
    nickname: item.nickName,
    role: roleToOldValue(item.roles),
    status: item.status,
    email: item.email,
    mobile: item.phonenumber,
    createTime: item.createTime,
    index: index + 1,
  }));
  return { ...res, data: rows, rows };
};

const detailApi = async (_params: any) => {
  const res = await get<any>({ url: URL.profile, params: {}, headers: {} });
  const baseProfile = normalizeProfile(res);
  const extra = readProfileExtra(baseProfile?.id);
  const pickText = (primary: any, fallback: any) => normalizeText(primary) || normalizeText(fallback);
  const mergedProfile = {
    ...baseProfile,
    ...extra,
    nickname: pickText(baseProfile?.nickname, extra?.nickname),
    email: pickText(baseProfile?.email, extra?.email),
    mobile: pickText(baseProfile?.mobile, extra?.mobile),
    avatar: pickText(baseProfile?.avatar, extra?.avatar),
    description: pickText(extra?.description, baseProfile?.description),
    pushEmail: pickText(baseProfile?.pushEmail, extra?.pushEmail || extra?.email),
  };
  return {
    ...res,
    data: mergedProfile,
  };
};

const createApi = async (data: any) => {
  const userName = String(getFormValue(data, 'username') || '');
  const nickName = String(getFormValue(data, 'nickname') || userName);
  const password = String(getFormValue(data, 'password') || '');
  const role = getFormValue(data, 'role');
  const status = String(getFormValue(data, 'status') || '0');
  const email = String(getFormValue(data, 'email') || '');
  const phonenumber = String(getFormValue(data, 'mobile') || '');
  const deptId = Number(getFormValue(data, 'deptId') || DEFAULT_DEPT_ID);
  const payload = {
    userName,
    nickName,
    password,
    status,
    email,
    phonenumber,
    deptId,
    roleIds: roleToIds(role),
    postIds: [],
  };
  return post<any>({ url: URL.user, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const updateApi = async (data: any) => {
  const userId = Number(getFormValue(data, 'id') || getFormValue(data, 'userId'));
  const userName = String(getFormValue(data, 'username') || '');
  const nickName = String(getFormValue(data, 'nickname') || userName);
  const role = getFormValue(data, 'role');
  const status = String(getFormValue(data, 'status') || '0');
  const email = String(getFormValue(data, 'email') || '');
  const phonenumber = String(getFormValue(data, 'mobile') || '');
  const deptId = Number(getFormValue(data, 'deptId') || DEFAULT_DEPT_ID);
  const payload = {
    userId,
    userName,
    nickName,
    status,
    email,
    phonenumber,
    deptId,
    roleIds: roleToIds(role),
    postIds: [],
  };
  return put<any>({ url: URL.user, data: payload, headers: { 'Content-Type': 'application/json;charset=utf-8' } });
};

const deleteApi = async (params: any) => {
  const ids = String(params?.ids || params?.id || '')
    .split(',')
    .map((it) => it.trim())
    .filter(Boolean);
  if (ids.length === 0) {
    return Promise.resolve({ code: 200, msg: 'ok', data: null });
  }
  return del<any>({ url: `${URL.user}/${ids.join(',')}`, params: {}, headers: {} });
};

const loginApi = async (data: LoginData) => loginByRole(data, true);
const userLoginApi = async (data: LoginData) => loginByRole(data, false);

const userRegisterApi = async (data: any) => {
  return requestAuth<any>('register', (url) =>
    post<any>({
      url,
      data: buildRegisterPayload(data, url),
      headers: { 'Content-Type': 'application/json;charset=utf-8' },
    }),
  );
};

const getCaptchaApi = async () => {
  try {
    const res = await requestAuth<any>('captchaImage', (url) =>
      get<any>({
        url,
        params: { t: Date.now() },
        data: {},
        headers: {},
      }),
    );
    const enabledRaw = res?.captchaEnabled ?? res?.captchaOnOff;
    const enabledText = String(enabledRaw ?? '')
      .trim()
      .toLowerCase();
    const captchaEnabled = typeof enabledRaw === 'boolean' ? enabledRaw : ['1', 'true', 'yes', 'on'].includes(enabledText);
    return {
      ...res,
      captchaEnabled,
      uuid: String(res?.uuid || ''),
      img: String(res?.img || ''),
    };
  } catch (_err) {
    return { captchaEnabled: false, uuid: '', img: '' };
  }
};

const updateUserPwdApi = async (params: any) => {
  const oldPassword = params?.oldPassword || params?.password;
  const newPassword = params?.newPassword;
  if (!oldPassword || !newPassword) {
    return Promise.reject({ code: 400, msg: '缺少密码参数' });
  }
  return put<any>({
    url: URL.profilePwd,
    data: { oldPassword, newPassword },
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const updateUserInfoApi = async (data: any) => {
  let avatarUrl = '';
  const avatarFile = getFormValue(data, 'avatarFile');
  const avatarText = getFormValue(data, 'avatar');
  if (avatarFile) {
    const avatarForm = new FormData();
    avatarForm.append('avatarfile', avatarFile as Blob);
    const avatarRes = await post<any>({
      url: URL.profileAvatar,
      data: avatarForm,
      headers: { 'Content-Type': 'multipart/form-data;charset=utf-8' },
    });
    avatarUrl = normalizeText(avatarRes?.imgUrl || avatarRes?.data?.imgUrl);
  } else if (avatarText) {
    avatarUrl = normalizeText(avatarText);
  }

  const nickName = getFormValue(data, 'nickname') || getFormValue(data, 'nickName');
  const email = getFormValue(data, 'email');
  const phonenumber = getFormValue(data, 'mobile') || getFormValue(data, 'phonenumber');
  const description = getFormValue(data, 'description');
  const userId = getFormValue(data, 'id') || localStorage.getItem(USER_ID);
  const payload: any = {};
  if (nickName !== undefined && nickName !== null) payload.nickName = String(nickName);
  if (email !== undefined && email !== null) payload.email = String(email);
  if (phonenumber !== undefined && phonenumber !== null) payload.phonenumber = String(phonenumber);
  if (nickName !== undefined && nickName !== null) {
    localStorage.setItem(USER_NAME, String(nickName));
  }
  saveProfileExtra(userId, {
    nickname: nickName !== undefined && nickName !== null ? String(nickName) : undefined,
    email: email !== undefined && email !== null ? String(email) : undefined,
    mobile: phonenumber !== undefined && phonenumber !== null ? String(phonenumber) : undefined,
    description: description !== undefined && description !== null ? String(description) : undefined,
    avatar: avatarUrl || undefined,
  });

  if (Object.keys(payload).length === 0) {
    return Promise.resolve({ code: 200, msg: 'ok', data: null });
  }

  return put<any>({
    url: URL.profile,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

export {
  loginApi,
  listApi,
  detailApi,
  createApi,
  updateApi,
  deleteApi,
  userLoginApi,
  userRegisterApi,
  updateUserPwdApi,
  updateUserInfoApi,
  getCaptchaApi,
};
