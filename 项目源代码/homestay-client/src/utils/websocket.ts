import { USER_TOKEN, BASE_URL } from '/@/store/constants';

type MessageHandler = (data: any) => void;

class ChatWebSocket {
  private ws: WebSocket | null = null;
  private reconnectTimer: number | null = null;
  private reconnectAttempts = 0;
  private maxReconnectAttempts = 5;
  private handlers: Map<string, MessageHandler[]> = new Map();
  private isConnected = false;

  connect() {
    const token = localStorage.getItem(USER_TOKEN);
    if (!token) {
      console.warn('[ChatWS] No token, skip connection');
      return;
    }

    const wsProtocol = window.location.protocol === 'https:' ? 'wss:' : 'ws:';
    let wsHost: string;
    if (BASE_URL && BASE_URL.trim() !== '') {
      wsHost = BASE_URL.replace(/^https?:/, wsProtocol);
    } else {
      wsHost = `${wsProtocol}//${window.location.host}`;
    }
    const cleanToken = token.startsWith('Bearer ') ? token.replace('Bearer ', '') : token;
    const wsUrl = `${wsHost}/ws/chat/${cleanToken}`;

    try {
      this.ws = new WebSocket(wsUrl);
      
      this.ws.onopen = () => {
        console.log('[ChatWS] Connected');
        this.isConnected = true;
        this.reconnectAttempts = 0;
      };

      this.ws.onmessage = (event) => {
        try {
          const msg = JSON.parse(event.data);
          this.handleMessage(msg);
        } catch (e) {
          console.error('[ChatWS] Parse error:', e);
        }
      };

      this.ws.onclose = () => {
        console.log('[ChatWS] Disconnected');
        this.isConnected = false;
        this.scheduleReconnect();
      };

      this.ws.onerror = (error) => {
        console.error('[ChatWS] Error:', error);
      };
    } catch (e) {
      console.error('[ChatWS] Connection failed:', e);
      this.scheduleReconnect();
    }
  }

  private handleMessage(msg: { type: string; data?: any }) {
    const handlers = this.handlers.get(msg.type) || [];
    handlers.forEach(handler => handler(msg.data || msg));
    
    const allHandlers = this.handlers.get('*') || [];
    allHandlers.forEach(handler => handler(msg));
  }

  private scheduleReconnect() {
    if (this.reconnectTimer) return;
    if (this.reconnectAttempts >= this.maxReconnectAttempts) {
      console.warn('[ChatWS] Max reconnect attempts reached');
      return;
    }

    this.reconnectAttempts++;
    const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempts), 30000);
    
    this.reconnectTimer = window.setTimeout(() => {
      this.reconnectTimer = null;
      this.connect();
    }, delay);
  }

  disconnect() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer);
      this.reconnectTimer = null;
    }
    if (this.ws) {
      this.ws.close();
      this.ws = null;
    }
    this.isConnected = false;
  }

  on(type: string, handler: MessageHandler) {
    if (!this.handlers.has(type)) {
      this.handlers.set(type, []);
    }
    this.handlers.get(type)!.push(handler);
  }

  off(type: string, handler: MessageHandler) {
    const handlers = this.handlers.get(type);
    if (handlers) {
      const index = handlers.indexOf(handler);
      if (index > -1) handlers.splice(index, 1);
    }
  }

  sendChat(receiverUserId: number, content: string) {
    if (!this.ws || !this.isConnected) {
      console.warn('[ChatWS] Not connected');
      return false;
    }
    this.ws.send(JSON.stringify({
      type: 'chat',
      receiverUserId,
      content
    }));
    return true;
  }

  sendImage(receiverUserId: number, imageUrl: string) {
    if (!this.ws || !this.isConnected) {
      console.warn('[ChatWS] Not connected');
      return false;
    }
    this.ws.send(JSON.stringify({
      type: 'image',
      receiverUserId,
      content: imageUrl
    }));
    return true;
  }

  sendTyping(receiverUserId: number) {
    if (!this.ws || !this.isConnected) return;
    this.ws.send(JSON.stringify({
      type: 'typing',
      receiverUserId
    }));
  }

  isOnline() {
    return this.isConnected;
  }
}

export const chatWebSocket = new ChatWebSocket();
