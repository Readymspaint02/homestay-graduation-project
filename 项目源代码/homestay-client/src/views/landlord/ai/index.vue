<template>
  <div class="page-view">
    <a-alert type="info" show-icon style="margin-bottom: 16px;">
      <template #message>AI助手功能说明</template>
      <template #description>1. 一键生成自然语言日报（使用DeepSeek AI）2. 当AI服务不可用时，自动降级为FAQ模式</template>
    </a-alert>

    <a-row :gutter="20" style="margin-bottom: 16px;">
      <a-col :span="8">
        <a-card hoverable @click="generateDailyReport">
          <div style="text-align: center; padding: 20px;">
            <div style="font-size: 36px; margin-bottom: 10px;">📊</div>
            <div style="font-size: 16px; font-weight: bold;">生成日报</div>
            <div style="font-size: 13px; color: #999; margin-top: 8px;">一键生成今日运营日报</div>
          </div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card hoverable @click="generateWeeklyReport">
          <div style="text-align: center; padding: 20px;">
            <div style="font-size: 36px; margin-bottom: 10px;">📈</div>
            <div style="font-size: 16px; font-weight: bold;">生成周报</div>
            <div style="font-size: 13px; color: #999; margin-top: 8px;">生成近7天运营周报</div>
          </div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card hoverable @click="showFaq">
          <div style="text-align: center; padding: 20px;">
            <div style="font-size: 36px; margin-bottom: 10px;">❓</div>
            <div style="font-size: 16px; font-weight: bold;">FAQ模式</div>
            <div style="font-size: 13px; color: #999; margin-top: 8px;">查看常见问题解答</div>
          </div>
        </a-card>
      </a-col>
    </a-row>

    <a-row :gutter="20">
      <a-col :span="16">
        <a-card>
          <template #title>
            <a-space>
              <span>AI 智能助手</span>
              <a-tag :color="aiStatus === 'online' ? 'green' : 'orange'">
                {{ aiStatus === 'online' ? 'DeepSeek在线' : 'FAQ降级模式' }}
              </a-tag>
            </a-space>
          </template>
          <div class="chat-container" ref="chatContainer">
            <div v-for="(msg, idx) in messages" :key="idx" :class="['message', msg.role]">
              <div class="message-content">
                <div v-if="msg.role === 'user'" class="avatar user-avatar">我</div>
                <div v-else class="avatar ai-avatar">AI</div>
                <div class="text" v-html="formatMessage(msg.content)"></div>
              </div>
            </div>
            <div v-if="loading" class="message assistant">
              <div class="message-content">
                <div class="avatar ai-avatar">AI</div>
                <div class="text typing">
                  <span class="dot"></span>
                  <span class="dot"></span>
                  <span class="dot"></span>
                </div>
              </div>
            </div>
          </div>
          <div class="input-area">
            <a-textarea
              v-model:value="inputText"
              :rows="2"
              placeholder="输入问题，如：今日有多少订单？近7天收入趋势如何？"
              @pressEnter.ctrl="sendMessage"
            />
            <a-button type="primary" :loading="loading" @click="sendMessage" style="margin-top: 8px">发送</a-button>
          </div>
        </a-card>
      </a-col>
      <a-col :span="8">
        <a-card title="快捷问题">
          <a-space direction="vertical" style="width: 100%">
            <a-button v-for="q in quickQuestions" :key="q" style="width: 100%; text-align: left" @click="askQuick(q)">
              {{ q }}
            </a-button>
          </a-space>
        </a-card>
        <a-card title="使用说明" style="margin-top: 20px">
          <ul class="help-list">
            <li>可询问今日订单、收入趋势</li>
            <li>可查询房源状态、入住率</li>
            <li>可获取经营建议</li>
            <li>AI 回答仅供参考</li>
          </ul>
        </a-card>
      </a-col>
    </a-row>

    <a-modal v-model:open="faqDialogVisible" title="常见问题解答（FAQ降级模式）" width="600px" :footer="null">
      <a-collapse>
        <a-collapse-panel v-for="(item, idx) in faqList" :key="idx" :header="item.q">
          <div>{{ item.a }}</div>
        </a-collapse-panel>
      </a-collapse>
    </a-modal>
  </div>
</template>

<script setup lang="ts">
import { onMounted, ref, nextTick } from 'vue';
import { message } from 'ant-design-vue';
import { post } from '/@/utils/http/axios';
import { streamChatApi } from '/@/api/ai';
import { ADMIN_USER_TOKEN, BASE_URL, RUOYI_CLIENT_ID, USER_TOKEN } from '/@/store/constants';

const messages = ref<{ role: string; content: string }[]>([
  { role: 'assistant', content: '您好！我是 AI 智能助手，可以帮您查询订单、收入、房源等信息。请问有什么可以帮您的？' },
]);
const inputText = ref('');
const loading = ref(false);
const chatContainer = ref<HTMLElement | null>(null);

const quickQuestions = [
  '今日有多少新订单？',
  '今日收入多少？',
  '近7天收入趋势如何？',
  '当前入住率是多少？',
  '有哪些待处理的订单？',
  '给我一些经营建议',
];

const aiStatus = ref('online');

const faqList = [
  { q: '今日订单数如何查看？', a: '可在运营看板页面查看今日新增订单数，或直接询问AI助手"今日有多少订单"。' },
  { q: '今日收入如何查看？', a: '可在运营看板页面查看今日收入，或直接询问AI助手"今日收入多少"。' },
  { q: '如何处理待确认订单？', a: '在订单处理页面，可以接受或拒绝订单，拒绝需填写原因。超时24小时将自动确认。' },
  { q: '房源审核流程是什么？', a: '房东提交房源后进入待审核状态，管理员可在后台审核通过或驳回。' },
  { q: '订单超时如何处理？', a: '未支付订单超过30分钟会自动关闭并释放库存。待确认订单超时24小时自动确认。' },
  { q: '如何管理房态日历？', a: '在房态日历页面，可以查看每日房态，已预订日期会灰掉防止重复下单。' },
  { q: '如何发布新房源？', a: '在房源管理页面点击"发布房源"，填写信息后提交审核，审核通过后自动上架。' },
  { q: '入住率如何计算？', a: '入住率 = 已上架房源数 / 房源总数。可在运营看板或询问AI助手查看。' },
];

const faqDialogVisible = ref(false);

const generateDailyReport = async () => {
  messages.value.push({ role: 'user', content: '请生成今日运营日报' });
  loading.value = true;
  scrollToBottom();

  try {
    const res = await post<any>({ url: '/api/ai/report/daily', data: {}, headers: {}, timeout: 60000 });
    if (res.code === 200 && res.data) {
      messages.value.push({ role: 'assistant', content: res.data.report || res.data.message });
      aiStatus.value = 'online';
    } else {
      throw new Error('AI服务不可用');
    }
  } catch (error) {
    aiStatus.value = 'offline';
    const fallbackReport = `【今日运营日报 - FAQ降级模式】

由于AI服务暂时不可用，以下是基础数据摘要：

1. 今日新增订单：可在运营看板查看实时数据
2. 今日新增房源：可在运营看板查看实时数据
3. 今日收入：可在运营看板查看实时数据

建议操作：
- 检查待处理订单，及时确认或拒绝
- 关注房态日历，确保房源状态正确
- 确认清洁任务完成情况

（AI服务恢复后将提供更详细的智能分析）`;
    messages.value.push({ role: 'assistant', content: fallbackReport });
  } finally {
    loading.value = false;
    scrollToBottom();
  }
};

const generateWeeklyReport = async () => {
  messages.value.push({ role: 'user', content: '请生成近7天运营周报' });
  loading.value = true;
  scrollToBottom();

  try {
    const res = await post<any>({ url: '/api/ai/report/weekly', data: {}, headers: {}, timeout: 60000 });
    if (res.code === 200 && res.data) {
      messages.value.push({ role: 'assistant', content: res.data.report || res.data.message });
      aiStatus.value = 'online';
    } else {
      throw new Error('AI服务不可用');
    }
  } catch (error) {
    aiStatus.value = 'offline';
    const fallbackReport = `【近7天运营周报 - FAQ降级模式】

由于AI服务暂时不可用，以下是基础分析：

1. 订单趋势：建议查看运营看板的收入趋势图
2. 房源分布：建议查看房源管理页面
3. 热门房源：建议查看订单数据

关键指标建议：
- 关注入住率变化趋势
- 分析热门房源特征
- 优化定价策略

（AI服务恢复后将提供更详细的智能分析）`;
    messages.value.push({ role: 'assistant', content: fallbackReport });
  } finally {
    loading.value = false;
    scrollToBottom();
  }
};

const showFaq = () => {
  faqDialogVisible.value = true;
};

const formatMessage = (text: string) => {
  if (!text) return '';
  return text.replace(/\n/g, '<br>').replace(/(\d+\.)/g, '<strong>$1</strong>');
};

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight;
    }
  });
};

const matchFaq = (question: string) => {
  const q = question.toLowerCase();
  
  if (q.includes('今日订单') || q.includes('今天订单') || q.includes('今日有多少订单') || q.includes('新订单')) {
    return '关于今日订单：\n\n您可以在"运营看板"页面查看今日新增订单数。\n\nAI服务响应较慢，已切换到FAQ模式。如需详细数据，请稍后重试或查看运营看板。';
  }
  if (q.includes('今日收入') || q.includes('今天收入') || q.includes('今日收入多少')) {
    return '关于今日收入：\n\n您可以在"运营看板"页面查看今日收入数据。\n\nAI服务响应较慢，已切换到FAQ模式。如需详细数据，请稍后重试或查看运营看板。';
  }
  if (q.includes('收入趋势') || q.includes('7天收入') || q.includes('近7天') || q.includes('周收入') || q.includes('趋势')) {
    return '关于收入趋势：\n\n您可以在"运营看板"页面查看近7日收入趋势图。\n\nAI服务响应较慢，已切换到FAQ模式。如需详细分析，请稍后重试或点击"生成周报"。';
  }
  if (q.includes('入住率')) {
    return '关于入住率：\n\n入住率 = 已上架房源数 / 房源总数。\n\n可在"运营看板"页面查看实时数据。\n\nAI服务响应较慢，已切换到FAQ模式。';
  }
  if (q.includes('待处理') || q.includes('待确认') || q.includes('待审核')) {
    return '关于待处理事项：\n\n1. 待确认订单：在"订单管理"页面处理\n2. 待清洁房源：在"清洁管理"页面查看\n3. 房态管理：在"房态日历"页面调整\n\nAI服务响应较慢，已切换到FAQ模式。';
  }
  if (q.includes('房源') && !q.includes('入住率')) {
    return '关于房源管理：\n\n- 房源总数和上架数量可在"房源管理"页面查看\n- 发布新房源：点击"发布房源"按钮\n- 编辑房源：在房源列表点击编辑\n\nAI服务响应较慢，已切换到FAQ模式。';
  }
  if (q.includes('建议') || q.includes('经营') || q.includes('运营')) {
    return '房东运营建议：\n\n1. 及时处理待确认订单，提升响应速度\n2. 关注房态日历，避免重复预订\n3. 保持房源清洁，提升租客评价\n4. 分析收入趋势，优化定价策略\n5. 关注热门房源特征，复制成功经验\n\nAI服务响应较慢，已切换到FAQ模式。';
  }
  
  return '抱歉，AI服务响应较慢，已切换到FAQ模式。\n\n您可以尝试询问：\n- 今日订单数\n- 今日收入\n- 近7天收入趋势\n- 入住率\n- 待处理订单\n- 经营建议\n\n或稍后重试AI服务。';
};

const sendMessage = async () => {
  const text = inputText.value.trim();
  if (!text) return;
  if (loading.value) return;

  messages.value.push({ role: 'user', content: text });
  inputText.value = '';
  loading.value = true;
  scrollToBottom();

  const controller = new AbortController();
  let timeoutId: ReturnType<typeof setTimeout> | null = null;
  let answered = false;

  const fallbackToFaq = () => {
    if (answered) return;
    answered = true;
    controller.abort();
    aiStatus.value = 'offline';
    messages.value.push({ role: 'assistant', content: matchFaq(text) });
    loading.value = false;
    scrollToBottom();
  };

  timeoutId = setTimeout(fallbackToFaq, 1500);

  try {
    let fullAnswer = '';
    await streamChatApi(
      { question: text, scene: 'landlord' },
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
      messages.value.push({ role: 'assistant', content: fullAnswer });
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
    messages.value.push({ role: 'assistant', content: matchFaq(text) });
  } finally {
    if (timeoutId) {
      clearTimeout(timeoutId);
      timeoutId = null;
    }
    loading.value = false;
    scrollToBottom();
  }
};

const askQuick = (q: string) => {
  inputText.value = q;
  sendMessage();
};

onMounted(() => {
  scrollToBottom();
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
}

.chat-container {
  height: 400px;
  overflow-y: auto;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  padding: 16px;
  background: #fafafa;
}

.message {
  margin-bottom: 16px;

  &.user {
    text-align: right;

    .message-content {
      justify-content: flex-end;
    }

    .text {
      background: #1890ff;
      color: #fff;
    }
  }

  &.assistant {
    text-align: left;

    .text {
      background: #fff;
      border: 1px solid #d9d9d9;
    }
  }
}

.message-content {
  display: inline-flex;
  align-items: flex-start;
  max-width: 80%;
}

.avatar {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 12px;
  font-weight: bold;
  flex-shrink: 0;

  &.user-avatar {
    background: #1890ff;
    color: #fff;
    margin-left: 8px;
  }

  &.ai-avatar {
    background: #52c41a;
    color: #fff;
    margin-right: 8px;
  }
}

.text {
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
  text-align: left;
  word-break: break-word;
}

.typing {
  display: flex;
  align-items: center;
  gap: 4px;
  padding: 10px 16px;

  .dot {
    width: 8px;
    height: 8px;
    background: #999;
    border-radius: 50%;
    animation: typing 1.4s infinite ease-in-out both;

    &:nth-child(1) { animation-delay: -0.32s; }
    &:nth-child(2) { animation-delay: -0.16s; }
  }
}

@keyframes typing {
  0%, 80%, 100% { transform: scale(0); }
  40% { transform: scale(1); }
}

.input-area {
  margin-top: 16px;
}

.help-list {
  padding-left: 20px;
  margin: 0;
  font-size: 13px;
  color: #666;
  line-height: 2;
}
</style>