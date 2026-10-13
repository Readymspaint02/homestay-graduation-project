import { get, post } from '/@/utils/http/axios';
import { BASE_URL } from '/@/store/constants';

enum URL {
  contacts = '/api/chat/contacts',
  history = '/api/chat/history',
  send = '/api/chat/send',
  read = '/api/chat/read',
  upload = '/api/chat/upload',
  userInfo = '/api/chat/user',
}

const contactsApi = async () => {
  return get<any>({ url: URL.contacts, params: {}, data: {}, headers: {} });
};

const userInfoApi = async (userId: number) => {
  return get<any>({ url: `${URL.userInfo}/${userId}`, params: {}, data: {}, headers: {} });
};

const historyApi = async (peerUserId: number) => {
  return get<any>({ url: `${URL.history}/${peerUserId}`, params: {}, data: {}, headers: {} });
};

const sendApi = async (payload: { receiverUserId: number; content: string }) => {
  return post<any>({
    url: URL.send,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const sendImageApi = async (receiverUserId: number, file: File) => {
  const formData = new FormData();
  formData.append('file', file);
  formData.append('receiverUserId', String(receiverUserId));
  return post<any>({
    url: URL.upload,
    data: formData,
    headers: { 'Content-Type': 'multipart/form-data' },
  });
};

const readApi = async (peerUserId: number) => {
  return post<any>({ url: `${URL.read}/${peerUserId}`, params: {}, data: {}, headers: {} });
};

const isImageMessage = (content: string) => {
  if (!content) return false;
  return content.startsWith('http') && /\.(jpg|jpeg|png|gif|webp|bmp)(\?.*)?$/i.test(content);
};

const resolveImageUrl = (content: string) => {
  if (!content) return '';
  if (content.startsWith('http://') || content.startsWith('https://')) {
    return content.replace(/^http:/, 'https:');
  }
  if (content.startsWith('/')) return `${BASE_URL}${content}`;
  return `${BASE_URL}/api/staticfiles/image/${content}`;
};

export { contactsApi, userInfoApi, historyApi, sendApi, sendImageApi, readApi, isImageMessage, resolveImageUrl };
