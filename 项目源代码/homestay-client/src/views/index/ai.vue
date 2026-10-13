<template>
  <div class="ai-page">
    <Header />
    <div class="ai-wrap">
      <template v-if="!isLogin">
        <div class="login-tip">
          <h3>AI智能助手</h3>
          <p>登录后可使用AI智能问答功能。</p>
          <a-button type="primary" @click="goLogin">去登录</a-button>
        </div>
      </template>

      <template v-else>
        <div class="ai-container">
          <div class="ai-panel">
            <div class="ai-header">
              <div class="ai-title-area">
                <span class="ai-title">AI智能助手</span>
                <a-tag :color="aiStatus === 'online' ? 'green' : 'orange'">
                  {{ aiStatus === 'online' ? '在线' : 'FAQ降级' }}
                </a-tag>
              </div>
              <div class="ai-subtitle">可询问房源推荐、预订流程、入住须知等问题</div>
            </div>

            <div class="ai-chat-area" ref="aiChatAreaRef">
              <div v-for="(msg, idx) in aiMessages" :key="idx" :class="['ai-msg', msg.role]">
                <div class="ai-msg-content">
                  <div v-if="msg.role === 'user'" class="ai-avatar user">我</div>
                  <div v-else class="ai-avatar bot">AI</div>
                  <div class="ai-text" v-html="formatAiMessage(msg.content)"></div>
                </div>
              </div>
              <div v-if="aiLoading" class="ai-msg assistant">
                <div class="ai-msg-content">
                  <div class="ai-avatar bot">AI</div>
                  <div class="ai-text typing">
                    <span class="dot"></span>
                    <span class="dot"></span>
                    <span class="dot"></span>
                  </div>
                </div>
              </div>
            </div>

            <div class="ai-quick">
              <div class="ai-quick-title">快捷问题</div>
              <div class="ai-quick-list">
                <a-button v-for="q in quickQuestions" :key="q" size="small" @click="askQuick(q)">{{ q }}</a-button>
              </div>
            </div>

            <div class="ai-input-area">
              <a-textarea
                v-model:value="aiInput"
                :rows="2"
                :maxlength="500"
                placeholder="输入问题，如：推荐适合亲子入住的房源..."
                @pressEnter.ctrl="sendAiMessage"
              />
              <div class="ai-actions">
                <span class="hint">Ctrl+Enter 发送</span>
                <a-button type="primary" :loading="aiLoading" @click="sendAiMessage">发送</a-button>
              </div>
            </div>
          </div>

          <div class="faq-panel">
            <div class="faq-title">常见问题</div>
            <div class="faq-list">
              <div v-for="(item, idx) in faqList" :key="idx" class="faq-item" @click="askFaq(item.q)">
                <div class="faq-q">{{ item.q }}</div>
                <div class="faq-a">{{ item.a }}</div>
              </div>
            </div>
          </div>
        </div>
      </template>
    </div>
    <Footer />
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import Header from '/@/views/index/components/header.vue';
import Footer from '/@/views/index/components/footer.vue';
import { streamChatApi } from '/@/api/ai';
import { USER_TOKEN } from '/@/store/constants';

const route = useRoute();
const router = useRouter();

const isLogin = computed(() => !!localStorage.getItem(USER_TOKEN));

const aiStatus = ref<'online' | 'offline'>('online');
const aiLoading = ref(false);
const aiInput = ref('');
const aiChatAreaRef = ref<HTMLElement>();
const aiMessages = ref<{ role: string; content: string }[]>([
  { role: 'assistant', content: '您好！我是AI智能助手，可以帮您推荐房源、解答预订问题、提供入住建议。请问有什么可以帮您的？' },
]);

const quickQuestions = [
  '推荐性价比高的房源',
  '适合亲子入住的房源',
  '如何取消订单？',
  '入住需要什么证件？',
];

const faqList = [
  { q: '如何预订房源？', a: '在房源详情页选择入住/退房日期和人数，点击预订按钮。' },
  { q: '如何支付？', a: '支持在线支付（模拟微信支付）和支付宝沙箱支付。' },
  { q: '如何取消订单？', a: '在订单详情页点击"取消订单"按钮即可取消。' },
  { q: '如何退款？', a: '订单取消后系统会自动释放日历，已支付请联系房东处理退款。' },
  { q: '怎么办理入住？', a: '订单状态变为"已确认"后，在订单页面点击"确认入住"。' },
  { q: '如何评价？', a: '退房完成后（订单状态为"已完成"），点击"去评价"即可。' },
  { q: '如何收藏房源？', a: '在房源详情页点击收藏按钮，房源将保存到"我的收藏"。' },
  { q: '如何退房？', a: '入住后，在订单页面点击"确认退房"按钮即可完成退房。' },
];

onMounted(() => {
});

const goLogin = () => {
  router.push({ name: 'login', query: { redirect: route.fullPath } });
};

const formatAiMessage = (text: string) => {
  if (!text) return '';
  return text.replace(/\n/g, '<br>');
};

const scrollAiToBottom = () => {
  const el = aiChatAreaRef.value;
  if (!el) return;
  el.scrollTop = el.scrollHeight;
};

const sendAiMessage = async () => {
  const text = aiInput.value.trim();
  if (!text || aiLoading.value) return;

  aiMessages.value.push({ role: 'user', content: text });
  aiInput.value = '';
  aiLoading.value = true;
  scrollAiToBottom();

  const controller = new AbortController();
  let timeoutId: ReturnType<typeof setTimeout> | null = null;
  let answered = false;

  const fallbackToFaq = () => {
    if (answered) return;
    answered = true;
    controller.abort();
    aiStatus.value = 'offline';
    const faqAnswer = searchLocalFaq(text);
    if (faqAnswer) {
      aiMessages.value.push({ role: 'assistant', content: faqAnswer });
    } else {
      aiMessages.value.push({ role: 'assistant', content: 'AI服务响应较慢，已切换到FAQ模式。您也可以查看右侧常见问题获取帮助。' });
    }
    aiLoading.value = false;
    scrollAiToBottom();
  };

  timeoutId = setTimeout(fallbackToFaq, 2000);

  try {
    let fullAnswer = '';
    await streamChatApi(
      { question: text, scene: 'tenant' },
      {
        signal: controller.signal,
        onEvent: (event, data) => {
          if (event === 'delta' && !answered) {
            fullAnswer += data;
            if (timeoutId) {
              clearTimeout(timeoutId);
              timeoutId = null;
            }
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
    if (fullAnswer) {
      aiMessages.value.push({ role: 'assistant', content: fullAnswer });
      aiStatus.value = 'online';
    } else {
      throw new Error('AI返回为空');
    }
  } catch (error) {
    if (answered) return;
    answered = true;
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    aiStatus.value = 'offline';
    const faqAnswer = searchLocalFaq(text);
    if (faqAnswer) {
      aiMessages.value.push({ role: 'assistant', content: faqAnswer });
    } else {
      aiMessages.value.push({ role: 'assistant', content: 'AI服务暂时不可用，已切换到FAQ模式。您也可以查看右侧常见问题获取帮助。' });
    }
  } finally {
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    aiLoading.value = false;
    scrollAiToBottom();
  }
};

const askQuick = (q: string) => {
  aiInput.value = q;
  sendAiMessage();
};

const askFaq = (q: string) => {
  aiInput.value = q;
  sendAiMessage();
};

const searchLocalFaq = (question: string): string => {
  const q = question.toLowerCase();
  for (const item of faqList) {
    if (q.includes(item.q.replace('？', '').replace('?', '').toLowerCase()) ||
        item.q.toLowerCase().includes(q)) {
      return item.a;
    }
  }
  return '';
};
</script>

<style scoped lang="less">
.ai-page {
  min-height: 100%;
  background: linear-gradient(180deg, #f2f7ff 0%, #f8fbff 100%);
}

.ai-wrap {
  width: 1200px;
  max-width: calc(100% - 32px);
  margin: 78px auto 24px;
  min-height: 600px;
}

.login-tip {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
  padding: 32px;
  text-align: center;
}

.login-tip h3 {
  margin: 0 0 8px;
  color: #1552d6;
  font-size: 20px;
}

.login-tip p {
  color: #4b5563;
  margin: 0 0 16px;
}

.ai-container {
  display: grid;
  grid-template-columns: 1fr 260px;
  gap: 12px;
  min-height: 600px;
}

.ai-panel {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.ai-header {
  padding: 12px 14px;
  border-bottom: 1px solid #e2e8f0;
}

.ai-title-area {
  display: flex;
  align-items: center;
  gap: 8px;
}

.ai-title {
  font-weight: 600;
  color: #1e293b;
}

.ai-subtitle {
  margin-top: 4px;
  font-size: 12px;
  color: #64748b;
}

.ai-chat-area {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
  background: #f8fafc;
  min-height: 400px;
}

.ai-msg {
  margin-bottom: 12px;
}

.ai-msg-content {
  display: flex;
  gap: 8px;
  align-items: flex-start;
}

.ai-msg.user .ai-msg-content {
  flex-direction: row-reverse;
}

.ai-avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: 600;
  flex-shrink: 0;
}

.ai-avatar.user {
  background: #1677ff;
  color: #fff;
}

.ai-avatar.bot {
  background: #f0f7ff;
  color: #1677ff;
}

.ai-text {
  max-width: 80%;
  padding: 10px 14px;
  border-radius: 12px;
  font-size: 14px;
  line-height: 1.6;
  word-break: break-word;
}

.ai-msg.user .ai-text {
  background: #1677ff;
  color: #fff;
  border-radius: 12px 12px 4px 12px;
}

.ai-msg.assistant .ai-text {
  background: #fff;
  border: 1px solid #e2e8f0;
  border-radius: 12px 12px 12px 4px;
}

.ai-text.typing {
  display: flex;
  gap: 4px;
  padding: 12px 16px;
}

.ai-text.typing .dot {
  width: 8px;
  height: 8px;
  background: #94a3b8;
  border-radius: 50%;
  animation: typing 1.4s infinite;
}

.ai-text.typing .dot:nth-child(2) {
  animation-delay: 0.2s;
}

.ai-text.typing .dot:nth-child(3) {
  animation-delay: 0.4s;
}

@keyframes typing {
  0%, 60%, 100% { opacity: 0.3; }
  30% { opacity: 1; }
}

.ai-quick {
  padding: 8px 12px;
  border-top: 1px solid #e2e8f0;
}

.ai-quick-title {
  font-size: 12px;
  color: #64748b;
  margin-bottom: 6px;
}

.ai-quick-list {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.ai-input-area {
  padding: 10px 12px;
  border-top: 1px solid #e2e8f0;
}

.ai-actions {
  margin-top: 6px;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.ai-actions .hint {
  font-size: 12px;
  color: #94a3b8;
}

.faq-panel {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
  padding: 12px;
  overflow-y: auto;
  max-height: 600px;
}

.faq-title {
  font-weight: 600;
  color: #334155;
  margin-bottom: 10px;
  padding-bottom: 8px;
  border-bottom: 1px solid #e2e8f0;
}

.faq-list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.faq-item {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 10px;
  cursor: pointer;
  transition: all 0.2s;
}

.faq-item:hover {
  border-color: #1677ff;
  background: #f0f7ff;
}

.faq-q {
  font-size: 13px;
  font-weight: 500;
  color: #1e293b;
}

.faq-a {
  margin-top: 4px;
  font-size: 12px;
  color: #64748b;
  line-height: 1.5;
}

@media (max-width: 900px) {
  .ai-container {
    grid-template-columns: 1fr;
  }

  .faq-panel {
    display: none;
  }
}
</style>
