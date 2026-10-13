<template>
  <div class="ai-chat-window" :class="{ 'collapsed': collapsed, 'hidden': hidden }">
    <!-- 收起/展开按钮 -->
    <div class="toggle-btn" @click="toggleCollapse">
      <img v-if="collapsed" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiNmZmYiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMjEgMTVhMiAyIDAgMCAxLTIgMkg3bC00IDRWNSIvPjxwYXRoIGQ9Ik0xOCA5bDMgM2wtMyAzIi8+PHBhdGggZD0iTTEzIDE1aDYiLz48L3N2Zz4=" alt="AI 助手" />
      <span v-if="collapsed">AI</span>
      <img v-else src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSIyNCIgaGVpZ2h0PSIyNCIgdmlld0JveD0iMCAwIDI0IDI0IiBmaWxsPSJub25lIiBzdHJva2U9IiMzZDU5OTYiIHN0cm9rZS13aWR0aD0iMiIgc3Ryb2tlLWxpbmVjYXA9InJvdW5kIiBzdHJva2UtbGluZWpvaW49InJvdW5kIj48cGF0aCBkPSJNMjEgMTVhMiAyIDAgMCAxLTIgMkg3bC00IDRWNSIvPjxwYXRoIGQ9Ik0xOCA5bDMgM2wtMyAzIi8+PHBhdGggZD0iTTEzIDE1aDYiLz48L3N2Zz4=" alt="收起" />
    </div>

    <!-- 聊天窗口主体 -->
    <div class="chat-body" v-show="!collapsed">
      <!-- 头部 -->
      <div class="chat-header">
        <div class="header-title">
          <span class="ai-icon">🤖</span>
          <span>{{ homestayId ? 'AI 选房助手' : 'AI 智能助手' }}</span>
        </div>
        <div class="header-actions">
          <a-tooltip title="清空对话">
            <a-button type="text" size="small" @click="clearChat">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M3 6h18M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"/></svg>
            </a-button>
          </a-tooltip>
          <a-tooltip title="收起">
            <a-button type="text" size="small" @click="toggleCollapse">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M18 15l-6-6-6 6"/></svg>
            </a-button>
          </a-tooltip>
        </div>
      </div>

      <!-- 快捷问题 -->
      <div class="quick-questions">
        <a-tag
          v-for="(q, index) in quickQuestions"
          :key="index"
          color="cyan"
          style="cursor: pointer; margin: 4px;"
          @click="sendQuickQuestion(q)"
        >
          {{ q }}
        </a-tag>
      </div>

      <!-- 消息列表 -->
      <div class="message-list" ref="messageListRef">
        <div
          v-for="(msg, index) in messages"
          :key="index"
          class="message-item"
          :class="msg.role"
        >
          <div class="message-avatar">
            <span v-if="msg.role === 'ai'">🤖</span>
            <span v-else>👤</span>
          </div>
          <div class="message-content">
            <div class="message-text" v-html="formatMessage(msg.content)"></div>
            <div class="message-time">{{ msg.time }}</div>
          </div>
        </div>
        <div v-if="loading" class="message-item ai">
          <div class="message-avatar">🤖</div>
          <div class="message-content">
            <a-spin size="small" />
            <span class="typing-text">AI 思考中...</span>
          </div>
        </div>
      </div>

      <!-- 输入框 -->
      <div class="chat-input-area">
        <a-textarea
          v-model:value="inputMessage"
          placeholder="输入问题，如：这套房适合什么人住？"
          :rows="3"
          :disabled="loading"
          @press-enter="handleSend"
          class="chat-input"
        />
        <a-button
          type="primary"
          :loading="loading"
          @click="handleSend"
          class="send-btn"
        >
          发送
        </a-button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, ref } from 'vue';
import { message } from 'ant-design-vue';
import { streamChatApi } from '/@/api/ai';

interface ChatMessage {
  role: 'user' | 'ai';
  content: string;
  time: string;
}

const props = defineProps({
  homestayId: {
    type: Number,
    default: undefined,
  },
  hidden: {
    type: Boolean,
    default: false,
  },
});

const collapsed = ref(false);
const loading = ref(false);
const inputMessage = ref('');
const messages = ref<ChatMessage[]>([]);
const messageListRef = ref<HTMLElement>();

const quickQuestions = computed(() => {
  // 根据场景返回不同的快捷问题
  if (props.homestayId) {
    // 房源详情页 - AI 选房助手
    return [
      '这套房适合什么人？',
      '有什么优缺点？',
      '性价比高吗？',
      '交通方便吗？',
    ];
  } else {
    // 首页 - AI 智能助手
    return [
      '解读当前房源',
      '对比前 3 套',
      '智能推荐',
      '广州有哪些好房源？',
    ];
  }
});

const getCurrentTime = () => {
  const now = new Date();
  return now.toLocaleTimeString('zh-CN', { hour: '2-digit', minute: '2-digit' });
};

const formatMessage = (content: string) => {
  // 移除 *** 标记，简单文本格式化
  return content
    .replace(/\*\*/g, '')  // 移除 **
    .replace(/\*/g, '')     // 移除 *
    .replace(/###/g, '')    // 移除 ###
    .replace(/##/g, '')     // 移除 ##
    .replace(/#/g, '')      // 移除 #
    .replace(/\n/g, '<br/>')
    .replace(/`([^`]+)`/g, '<code style="background:#f0f0f0;padding:2px 6px;border-radius:3px;">$1</code>');
};

const toggleCollapse = () => {
  collapsed.value = !collapsed.value;
};

const clearChat = () => {
  messages.value = [];
  message.success('对话已清空');
};

const sendQuickQuestion = (question: string) => {
  inputMessage.value = question;
  handleSend();
};

const scrollToBottom = () => {
  nextTick(() => {
    if (messageListRef.value) {
      messageListRef.value.scrollTop = messageListRef.value.scrollHeight;
    }
  });
};

const handleSend = async () => {
  const text = inputMessage.value.trim();
  if (!text) {
    message.warning('请输入问题');
    return;
  }

  messages.value.push({
    role: 'user',
    content: text,
    time: getCurrentTime(),
  });

  inputMessage.value = '';
  loading.value = true;
  scrollToBottom();

  const controller = new AbortController();
  let timeoutId: ReturnType<typeof setTimeout> | null = null;
  let answered = false;

  const fallbackToFaq = () => {
    if (answered) return;
    answered = true;
    controller.abort();
    const faqAnswer = searchLocalFaq(text);
    messages.value.push({
      role: 'ai',
      content: faqAnswer || 'AI服务响应较慢，已切换到FAQ模式。您可以尝试其他问题或稍后重试。',
      time: getCurrentTime(),
    });
    loading.value = false;
    scrollToBottom();
  };

  timeoutId = setTimeout(fallbackToFaq, 2000);

  try {
    let aiResponse = '';

    await streamChatApi(
      {
        scene: props.homestayId ? 'interpret' : 'chat',
        question: text,
        thingIds: props.homestayId ? [props.homestayId] : undefined,
      },
      {
        signal: controller.signal,
        onEvent: (event, data) => {
          if (event === 'delta' && !answered) {
            aiResponse += data;
            if (timeoutId) {
              clearTimeout(timeoutId);
              timeoutId = null;
            }
            const lastMsg = messages.value[messages.value.length - 1];
            if (lastMsg && lastMsg.role === 'ai') {
              lastMsg.content = aiResponse;
            } else {
              messages.value.push({
                role: 'ai',
                content: aiResponse,
                time: getCurrentTime(),
              });
            }
            scrollToBottom();
          }
        },
      }
    );

    if (answered) return;
    answered = true;
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }

    if (!messages.value.some(m => m.role === 'ai' && m.content === aiResponse)) {
      messages.value.push({
        role: 'ai',
        content: aiResponse || 'AI 暂无回复，请稍后重试',
        time: getCurrentTime(),
      });
    }
  } catch (err: any) {
    if (answered) return;
    answered = true;
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    const faqAnswer = searchLocalFaq(text);
    messages.value.push({
      role: 'ai',
      content: faqAnswer || `AI 回复失败：${err.message || '请稍后重试'}`,
      time: getCurrentTime(),
    });
  } finally {
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    loading.value = false;
    scrollToBottom();
  }
};

const searchLocalFaq = (question: string): string => {
  const q = question.toLowerCase();
  
  if (q.includes('适合') || q.includes('什么人')) {
    return '这套房源适合情侣、家庭出游或商务人士入住，具体可根据房源设施和位置判断。';
  }
  if (q.includes('优缺点') || q.includes('优点') || q.includes('缺点')) {
    return '优点：位置便利、设施齐全、性价比高。\n缺点：具体需根据实际情况判断，建议查看评价。';
  }
  if (q.includes('性价比') || q.includes('值得')) {
    return '该房源性价比较高，建议对比周边同类房源价格后做决定。';
  }
  if (q.includes('交通') || q.includes('地铁') || q.includes('方便')) {
    return '房源交通便利，建议查看详情页的地图位置，了解周边地铁站和公交站分布。';
  }
  if (q.includes('推荐') || q.includes('好房源')) {
    return '推荐您根据入住人数、预算和位置偏好筛选房源，热门房源通常评价较高。';
  }
  if (q.includes('解读') || q.includes('分析')) {
    return '当前房源信息：建议关注价格、位置、设施和评价等关键因素。';
  }
  if (q.includes('对比')) {
    return '对比房源时建议关注：价格差异、位置便利性、设施配置、用户评价等方面。';
  }
  
  return '';
};
</script>

<style scoped lang="less">
.ai-chat-window {
  position: fixed;
  right: 20px;
  top: 50%;
  transform: translateY(-50%);
  z-index: 999;
  transition: all 0.3s ease;

  &.collapsed {
    .toggle-btn {
      width: 60px;
      height: 60px;
    }
  }
}

.toggle-btn {
  width: 60px;
  height: 60px;
  background: linear-gradient(135deg, #00f5ff 0%, #0066ff 100%);
  border-radius: 12px 0 0 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 0 20px rgba(0, 245, 255, 0.4);
  transition: all 0.3s ease;
  border: 2px solid rgba(0, 245, 255, 0.3);

  &:hover {
    transform: translateX(-4px);
    box-shadow: 0 0 30px rgba(0, 245, 255, 0.6);
  }

  img {
    width: 32px;
    height: 32px;
    filter: drop-shadow(0 0 4px rgba(255, 255, 255, 0.5));
  }

  span {
    color: #fff;
    font-size: 14px;
    font-weight: 600;
    text-shadow: 0 0 8px rgba(0, 245, 255, 0.8);
  }
}

.chat-body {
  width: 400px;
  height: 600px;
  background: linear-gradient(180deg, rgba(10, 25, 47, 0.95) 0%, rgba(10, 30, 60, 0.98) 100%);
  border-radius: 16px 0 0 16px;
  box-shadow: -8px 8px 32px rgba(0, 102, 255, 0.3);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(0, 245, 255, 0.2);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.chat-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  background: linear-gradient(135deg, rgba(0, 245, 255, 0.2) 0%, rgba(0, 102, 255, 0.2) 100%);
  border-bottom: 1px solid rgba(0, 245, 255, 0.3);

  .header-title {
    display: flex;
    align-items: center;
    gap: 10px;
    font-size: 16px;
    font-weight: 600;
    color: #00f5ff;
    text-shadow: 0 0 10px rgba(0, 245, 255, 0.5);

    .ai-icon {
      font-size: 24px;
      filter: drop-shadow(0 0 8px rgba(0, 245, 255, 0.6));
    }
  }

  .header-actions {
    display: flex;
    gap: 8px;

    :deep(.ant-btn) {
      color: #00f5ff;
      background: rgba(0, 245, 255, 0.1);
      border: 1px solid rgba(0, 245, 255, 0.3);

      &:hover {
        background: rgba(0, 245, 255, 0.2);
        box-shadow: 0 0 12px rgba(0, 245, 255, 0.4);
      }
    }
  }
}

.quick-questions {
  padding: 12px 16px;
  background: rgba(0, 245, 255, 0.05);
  border-bottom: 1px solid rgba(0, 245, 255, 0.15);
  display: flex;
  flex-wrap: wrap;
  gap: 8px;

  :deep(.ant-tag) {
    background: rgba(0, 245, 255, 0.1);
    border: 1px solid rgba(0, 245, 255, 0.3);
    color: #00f5ff;
    cursor: pointer;
    transition: all 0.3s ease;

    &:hover {
      background: rgba(0, 245, 255, 0.2);
      box-shadow: 0 0 12px rgba(0, 245, 255, 0.4);
      transform: translateY(-2px);
    }
  }
}

.message-list {
  flex: 1;
  overflow-y: auto;
  padding: 20px;
  background: rgba(0, 0, 0, 0.2);

  &::-webkit-scrollbar {
    width: 6px;
  }

  &::-webkit-scrollbar-thumb {
    background: rgba(0, 245, 255, 0.3);
    border-radius: 3px;

    &:hover {
      background: rgba(0, 245, 255, 0.5);
    }
  }

  .message-item {
    display: flex;
    gap: 12px;
    margin-bottom: 20px;
    animation: fadeIn 0.3s ease;

    @keyframes fadeIn {
      from {
        opacity: 0;
        transform: translateY(10px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }

    &.user {
      flex-direction: row-reverse;

      .message-content {
        align-items: flex-end;

        .message-text {
          background: linear-gradient(135deg, #0066ff 0%, #00f5ff 100%);
          color: #fff;
          box-shadow: 0 4px 16px rgba(0, 102, 255, 0.4);
        }
      }
    }

    &.ai {
      .message-text {
        background: rgba(255, 255, 255, 0.08);
        color: #e0e0e0;
        border: 1px solid rgba(0, 245, 255, 0.15);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
      }
    }

    .message-avatar {
      font-size: 28px;
      flex-shrink: 0;
      filter: drop-shadow(0 0 8px rgba(0, 245, 255, 0.4));
    }

    .message-content {
      max-width: 75%;
      display: flex;
      flex-direction: column;

      .message-text {
        padding: 12px 16px;
        border-radius: 16px;
        font-size: 14px;
        line-height: 1.7;
        word-break: break-word;
      }

      .message-time {
        font-size: 11px;
        color: rgba(255, 255, 255, 0.5);
        margin-top: 6px;
        text-align: right;
      }
    }

    .typing-text {
      color: rgba(0, 245, 255, 0.6);
      font-size: 13px;
      margin-left: 8px;
      animation: pulse 1.5s infinite;

      @keyframes pulse {
        0%, 100% { opacity: 0.4; }
        50% { opacity: 1; }
      }
    }
  }
}

.chat-input-area {
  padding: 16px;
  border-top: 1px solid rgba(0, 245, 255, 0.15);
  background: rgba(0, 0, 0, 0.2);

  .chat-input {
    resize: none;
    font-size: 14px;
    background: rgba(255, 255, 255, 0.05);
    border: 1px solid rgba(0, 245, 255, 0.2);
    color: #fff;
    border-radius: 8px;

    &:focus {
      border-color: rgba(0, 245, 255, 0.5);
      box-shadow: 0 0 12px rgba(0, 245, 255, 0.2);
    }
  }

  .send-btn {
    margin-top: 10px;
    width: 100%;
    background: linear-gradient(135deg, #00f5ff 0%, #0066ff 100%);
    border: none;
    border-radius: 8px;
    font-weight: 600;
    box-shadow: 0 4px 16px rgba(0, 245, 255, 0.3);

    &:hover {
      box-shadow: 0 6px 24px rgba(0, 245, 255, 0.5);
      transform: translateY(-2px);
    }
  }
}
</style>
