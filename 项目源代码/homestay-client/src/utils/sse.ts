import { getToken } from '/@/utils/auth';
import { BASE_URL } from '/@/store/constants';

type SseHandler = (data: any) => void;

class SystemSseService {
  private eventSource: EventSource | null = null;
  private handlers: Map<string, SseHandler[]> = new Map();

  connect() {
    const token = getToken();
    if (!token) {
      console.warn('[SystemSSE] No token, skip connection');
      return;
    }

    const url = `${BASE_URL}/api/order/message/subscribe?token=${token}`;

    try {
      this.eventSource = new EventSource(url);

      this.eventSource.onopen = () => {
        console.log('[SystemSSE] Connected');
      };

      this.eventSource.onerror = (error) => {
        console.error('[SystemSSE] Error:', error);
        this.disconnect();
      };

      this.eventSource.addEventListener('connected', (event) => {
        console.log('[SystemSSE] Server confirmed:', event.data);
      });

      this.eventSource.addEventListener('system_notification', (event) => {
        try {
          const data = JSON.parse(event.data);
          this.handleEvent('system_notification', data);
        } catch (e) {
          console.error('[SystemSSE] Parse error:', e);
        }
      });

      this.eventSource.addEventListener('order_status', (event) => {
        try {
          const data = JSON.parse(event.data);
          this.handleEvent('order_status', data);
        } catch (e) {
          console.error('[SystemSSE] Parse error:', e);
        }
      });

      this.eventSource.addEventListener('payment_status', (event) => {
        try {
          const data = JSON.parse(event.data);
          this.handleEvent('payment_status', data);
        } catch (e) {
          console.error('[SystemSSE] Parse error:', e);
        }
      });

    } catch (e) {
      console.error('[SystemSSE] Connection failed:', e);
    }
  }

  private handleEvent(eventType: string, data: any) {
    const handlers = this.handlers.get(eventType) || [];
    handlers.forEach(handler => handler(data));
    
    const allHandlers = this.handlers.get('*') || [];
    allHandlers.forEach(handler => handler({ type: eventType, data }));
  }

  disconnect() {
    if (this.eventSource) {
      this.eventSource.close();
      this.eventSource = null;
    }
  }

  on(eventType: string, handler: SseHandler) {
    if (!this.handlers.has(eventType)) {
      this.handlers.set(eventType, []);
    }
    this.handlers.get(eventType)!.push(handler);
  }

  off(eventType: string, handler: SseHandler) {
    const handlers = this.handlers.get(eventType);
    if (handlers) {
      const index = handlers.indexOf(handler);
      if (index > -1) handlers.splice(index, 1);
    }
  }
}

export const systemSse = new SystemSseService();