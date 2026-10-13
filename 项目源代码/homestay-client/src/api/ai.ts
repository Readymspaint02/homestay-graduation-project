import { post } from '/@/utils/http/axios';
import { ADMIN_USER_TOKEN, BASE_URL, RUOYI_CLIENT_ID, USER_TOKEN } from '/@/store/constants';

enum URL {
  interpret = '/api/ai/house/interpret',
  compare = '/api/ai/house/compare',
  stream = '/api/ai/chat/stream',
}

type InterpretPayload = {
  thingId: number;
  question?: string;
};

type ComparePayload = {
  thingIds: number[];
  question?: string;
};

type ChatPayload = {
  scene?: string;
  question: string;
  thingIds?: number[];
  sessionId?: string;
  userProfile?: Record<string, any>;
};

type StreamOptions = {
  signal?: AbortSignal;
  onEvent?: (event: string, data: string) => void;
};

const interpretApi = async (payload: InterpretPayload) => {
  return post<any>({
    url: URL.interpret,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const compareApi = async (payload: ComparePayload) => {
  return post<any>({
    url: URL.compare,
    data: payload,
    headers: { 'Content-Type': 'application/json;charset=utf-8' },
  });
};

const parseSseBuffer = (raw: string, onEvent?: (event: string, data: string) => void) => {
  let buffer = raw;
  while (true) {
    const splitIndex = buffer.indexOf('\n\n');
    if (splitIndex < 0) {
      break;
    }
    const block = buffer.slice(0, splitIndex).replace(/\r/g, '');
    buffer = buffer.slice(splitIndex + 2);
    if (!block.trim()) {
      continue;
    }
    let eventName = 'message';
    const dataLines: string[] = [];
    block.split('\n').forEach((line) => {
      if (line.startsWith('event:')) {
        eventName = line.slice(6).trim();
      } else if (line.startsWith('data:')) {
        dataLines.push(line.slice(5).trimStart());
      }
    });
    onEvent?.(eventName, dataLines.join('\n'));
  }
  return buffer;
};

const streamChatApi = async (payload: ChatPayload, options: StreamOptions = {}) => {
  const adminToken = localStorage.getItem(ADMIN_USER_TOKEN) || '';
  const userToken = localStorage.getItem(USER_TOKEN) || '';
  const authToken = adminToken || userToken;

  const response = await fetch(`${BASE_URL}${URL.stream}`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json;charset=utf-8',
      Accept: 'text/event-stream',
      clientid: RUOYI_CLIENT_ID,
      ADMINTOKEN: adminToken,
      TOKEN: userToken,
      ...(authToken ? { Authorization: authToken.startsWith('Bearer ') ? authToken : `Bearer ${authToken}` } : {}),
    },
    body: JSON.stringify(payload),
    signal: options.signal,
  });

  if (!response.ok) {
    throw new Error(`AI请求失败（${response.status}）`);
  }
  if (!response.body) {
    throw new Error('AI流式响应不可用');
  }

  const reader = response.body.getReader();
  const decoder = new TextDecoder('utf-8');
  let buffer = '';
  while (true) {
    const { done, value } = await reader.read();
    if (done) break;
    buffer += decoder.decode(value, { stream: true });
    buffer = parseSseBuffer(buffer, options.onEvent);
  }

  buffer += decoder.decode();
  if (buffer.trim()) {
    parseSseBuffer(`${buffer}\n\n`, options.onEvent);
  }
};

export { interpretApi, compareApi, streamChatApi };
