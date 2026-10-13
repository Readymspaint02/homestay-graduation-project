<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="mb12">
      <template #title>房东AI助手</template>
      <div class="alert-line">1. 智能问答：今日订单、收入趋势、房源状态等</div>
      <div class="alert-line">2. AI响应超时1.5秒自动降级FAQ模式</div>
    </el-alert>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <el-card>
          <template #header>
            <span>AI 智能助手</span>
            <el-tag :type="aiStatus === 'online' ? 'success' : 'warning'" size="small" style="margin-left: 8px">
              {{ aiStatus === 'online' ? 'AI在线' : 'FAQ降级模式' }}
            </el-tag>
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
            <el-input
              v-model="inputText"
              type="textarea"
              :rows="2"
              placeholder="输入问题，如：今日有多少订单？近7天收入如何？"
              @keyup.enter.ctrl="sendMessage"
            />
            <el-button type="primary" :loading="loading" @click="sendMessage" style="margin-top: 8px">
              发送
            </el-button>
          </div>
        </el-card>
      </el-col>
      <el-col :xs="24" :lg="8">
        <el-card>
          <template #header>快速提问</template>
          <el-space direction="vertical" style="width: 100%">
            <el-button v-for="q in quickQuestions" :key="q" type="default" style="width: 100%; text-align: left" @click="askQuick(q)">
              {{ q }}
            </el-button>
          </el-space>
        </el-card>
        <el-card style="margin-top: 20px">
          <template #header>使用说明</template>
          <ul class="help-list">
            <li>可询问今日订单、收入趋势</li>
            <li>可查询房源状态、入住率</li>
            <li>可获取经营建议</li>
            <li>AI回答仅供参考</li>
          </ul>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="LandlordAiAssistant">
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const messages = ref([
  { role: 'assistant', content: '您好！我是房东AI助手，可以帮您查询今日订单、收入趋势、房源状态等信息。请问有什么可以帮您的？' }
])
const inputText = ref('')
const loading = ref(false)
const chatContainer = ref(null)

const quickQuestions = [
  '今日有多少订单？',
  '今日收入是多少？',
  '近7天收入趋势如何？',
  '当前入住率是多少？',
  '有多少待处理订单？',
  '给我一些经营建议'
]

const aiStatus = ref('online')

const formatMessage = (text) => {
  if (!text) return ''
  let result = text.replace(/\n/g, '<br>')
  result = result.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
  result = result.replace(/\*(.*?)\*/g, '<em>$1</em>')
  return result
}

const scrollToBottom = () => {
  nextTick(() => {
    if (chatContainer.value) {
      chatContainer.value.scrollTop = chatContainer.value.scrollHeight
    }
  })
}

const sendMessage = async () => {
  const text = inputText.value.trim()
  if (!text) return
  if (loading.value) return

  messages.value.push({ role: 'user', content: text })
  inputText.value = ''
  loading.value = true
  scrollToBottom()

  const controller = new AbortController()
  let timeoutId = null
  let answered = false

  const fallbackToFaq = () => {
    if (answered) return
    answered = true
    controller.abort()
    aiStatus.value = 'offline'
    messages.value.push({ role: 'assistant', content: matchFaq(text) })
    loading.value = false
    scrollToBottom()
  }

  timeoutId = setTimeout(fallbackToFaq, 1500)

  try {
    const res = await request({
      url: '/api/ai/chat',
      method: 'post',
      data: { question: text, scene: 'landlord' },
      timeout: 5000,
      signal: controller.signal
    })
    if (answered) return
    answered = true
    if (timeoutId) {
      clearTimeout(timeoutId)
      timeoutId = null
    }
    if (res.code === 200 && res.data && res.data.reply) {
      messages.value.push({ role: 'assistant', content: res.data.reply })
      aiStatus.value = 'online'
    } else if (res.msg) {
      aiStatus.value = 'offline'
      messages.value.push({ role: 'assistant', content: res.msg })
    } else {
      aiStatus.value = 'offline'
      messages.value.push({ role: 'assistant', content: matchFaq(text) })
    }
  } catch (error) {
    if (answered) return
    answered = true
    if (timeoutId) {
      clearTimeout(timeoutId)
      timeoutId = null
    }
    console.error('AI chat error:', error)
    aiStatus.value = 'offline'
    messages.value.push({ role: 'assistant', content: matchFaq(text) })
  } finally {
    if (timeoutId) {
      clearTimeout(timeoutId)
      timeoutId = null
    }
    loading.value = false
    scrollToBottom()
  }
}

const matchFaq = (question) => {
  const q = question.toLowerCase()
  
  if (q.includes('今日订单') || q.includes('今天订单') || q.includes('今日有多少订单')) {
    return '今日订单数据：\n\n请在「订单管理」页面查看今日新增订单。\n\n建议：及时处理待确认订单，超时24小时将自动确认。'
  }
  if (q.includes('今日收入') || q.includes('今天收入')) {
    return '今日收入：\n\n请在「运营看板」页面查看今日收入数据。\n\n建议：关注订单完成率，提升租客满意度可增加复购。'
  }
  if (q.includes('收入趋势') || q.includes('7天收入') || q.includes('近7天') || q.includes('周收入')) {
    return '近7天收入数据：\n\n请在「运营看板」页面查看收入趋势图。\n\n建议：分析订单来源，优化房源定价策略。'
  }
  if (q.includes('入住率')) {
    return '当前入住率：\n\n请在「运营看板」页面查看入住率数据。\n\n建议：关注空置房源，可考虑调整价格或优化房源描述。'
  }
  if (q.includes('待处理') || q.includes('待确认')) {
    return '待处理订单：\n\n请在「订单管理」页面查看待处理订单，可接受或拒绝订单。拒绝需填写原因。'
  }
  if (q.includes('建议') || q.includes('经营') || q.includes('运营')) {
    return '房东运营建议：\n\n1. 及时处理待确认订单，提升响应速度\n2. 关注房态日历，避免重复预订\n3. 保持房源清洁，提升租客评价\n4. 分析收入趋势，优化定价策略\n5. 关注热门房源特征，复制成功经验'
  }
  if (q.includes('房源')) {
    return '房源概况：\n\n请在「房源管理」页面查看所有房源。\n\n可在该页面发布新房源或编辑现有房源。'
  }
  if (q.includes('房态') || q.includes('日历')) {
    return '房态日历管理：\n\n1. 在「房态日历」页面查看每日房态\n2. 已预订日期会灰掉，防止重复下单\n3. 可手动锁定/解锁日期\n4. 清洁中的日期也会标记'
  }
  if (q.includes('清洁')) {
    return '清洁管理：\n\n1. 在「清洁管理」页面查看清洁任务\n2. 点击「叫清洁」通知清洁人员\n3. 清洁完成后拍照上传\n4. 房源恢复可租状态'
  }
  
  return '抱歉，我暂时无法回答这个问题。\n\n您可以尝试询问：\n- 今日订单数\n- 今日收入\n- 近7天收入趋势\n- 入住率\n- 待处理订单\n- 经营建议'
}

const askQuick = (q) => {
  inputText.value = q
  sendMessage()
}

onMounted(() => {
  scrollToBottom()
})
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
}

.chat-container {
  height: 400px;
  overflow-y: auto;
  border: 1px solid #ebeef5;
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
      background: #409eff;
      color: #fff;
    }
  }

  &.assistant {
    text-align: left;

    .text {
      background: #fff;
      border: 1px solid #e4e7ed;
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
    background: #409eff;
    color: #fff;
    margin-left: 8px;
  }

  &.ai-avatar {
    background: #67c23a;
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
    background: #909399;
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
  color: #606266;
  line-height: 2;
}

.alert-line {
  font-size: 13px;
  line-height: 1.8;
}

.mb12 {
  margin-bottom: 12px;
}
</style>
