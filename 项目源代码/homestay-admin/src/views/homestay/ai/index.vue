<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="mb12">
      <template #title>AI助手功能说明</template>
      <div class="alert-line">1. 一键生成自然语言日报（使用DeepSeek AI）</div>
      <div class="alert-line">2. 当AI服务不可用时，自动降级为FAQ模式</div>
    </el-alert>

    <el-row :gutter="20" class="mb12">
      <el-col :xs="24" :sm="8">
        <el-card shadow="hover" class="action-card" @click="generateDailyReport">
          <div class="action-icon">📊</div>
          <div class="action-title">生成日报</div>
          <div class="action-desc">一键生成今日运营日报</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card shadow="hover" class="action-card" @click="generateWeeklyReport">
          <div class="action-icon">📈</div>
          <div class="action-title">生成周报</div>
          <div class="action-desc">生成近7天运营周报</div>
        </el-card>
      </el-col>
      <el-col :xs="24" :sm="8">
        <el-card shadow="hover" class="action-card" @click="showFaq">
          <div class="action-icon">❓</div>
          <div class="action-title">FAQ模式</div>
          <div class="action-desc">查看常见问题解答</div>
        </el-card>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :xs="24" :lg="16">
        <el-card>
          <template #header>
            <span>AI 智能助手</span>
            <el-tag :type="aiStatus === 'online' ? 'success' : 'warning'" size="small" style="margin-left: 8px">
              {{ aiStatus === 'online' ? 'DeepSeek在线' : 'FAQ降级模式' }}
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
              placeholder="输入问题，如：今日有多少订单？近7天收入趋势如何？"
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
          <template #header>快捷问题</template>
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
            <li>AI 回答仅供参考</li>
          </ul>
        </el-card>
      </el-col>
    </el-row>

    <el-dialog v-model="showFaqDialog" title="常见问题解答（FAQ降级模式）" width="600px">
      <el-collapse>
        <el-collapse-item v-for="(item, idx) in faqList" :key="idx" :title="item.q" :name="idx">
          <div>{{ item.a }}</div>
        </el-collapse-item>
      </el-collapse>
      <template #footer>
        <el-button type="primary" @click="showFaqDialog = false">关闭</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="AiAssistant">
import { ref, nextTick, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'
import { getToken } from '@/utils/auth'

const messages = ref([
  { role: 'assistant', content: '您好！我是 AI 智能助手，可以帮您查询订单、收入、房源等信息。请问有什么可以帮您的？' }
])
const inputText = ref('')
const loading = ref(false)
const chatContainer = ref(null)

const quickQuestions = [
  '今日有多少新订单？',
  '近7天收入趋势如何？',
  '当前入住率是多少？',
  '有哪些待处理的订单？',
  '给我一些经营建议'
]

const aiStatus = ref('online')

const faqList = [
  { q: '今日订单数如何查看？', a: '可在数据看板页面查看今日新增订单数，或点击"生成日报"按钮获取AI生成的日报摘要。' },
  { q: '如何处理异常订单？', a: '在交易监管页面，金额超过20000元或退款率超过60%的订单会自动标红，可点击"人工复核"进行处理。' },
  { q: '房源审核流程是什么？', a: '房东提交房源后进入待审核状态，管理员可在房源审核页面一键通过或驳回，驳回需填写原因。' },
  { q: '订单超时如何处理？', a: '未支付订单超过30分钟会自动关闭并释放库存，系统每5分钟自动检查超时订单。' },
  { q: '如何冻结用户账号？', a: '在系统管理-用户管理页面，通过状态开关可冻结/解冻用户账号。' },
  { q: '监管上报功能是什么？', a: '监管上报用于将房源、订单、入住数据汇总上报至文旅、公安等监管部门。' }
]

const showFaqDialog = ref(false)

const generateDailyReport = async () => {
  messages.value.push({ role: 'user', content: '请生成今日运营日报' })
  loading.value = true
  scrollToBottom()

  try {
    const res = await request({
      url: '/api/ai/report/daily',
      method: 'post',
      timeout: 60000
    })
    if (res.code === 200 && res.data) {
      messages.value.push({ role: 'assistant', content: res.data.report || res.data.message })
      aiStatus.value = 'online'
    } else {
      throw new Error('AI服务不可用')
    }
  } catch (error) {
    aiStatus.value = 'offline'
    const fallbackReport = generateFallbackDailyReport()
    messages.value.push({ role: 'assistant', content: fallbackReport })
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

const generateWeeklyReport = async () => {
  messages.value.push({ role: 'user', content: '请生成近7天运营周报' })
  loading.value = true
  scrollToBottom()

  try {
    const res = await request({
      url: '/api/ai/report/weekly',
      method: 'post',
      timeout: 60000
    })
    if (res.code === 200 && res.data) {
      messages.value.push({ role: 'assistant', content: res.data.report || res.data.message })
      aiStatus.value = 'online'
    } else {
      throw new Error('AI服务不可用')
    }
  } catch (error) {
    aiStatus.value = 'offline'
    const fallbackReport = generateFallbackWeeklyReport()
    messages.value.push({ role: 'assistant', content: fallbackReport })
  } finally {
    loading.value = false
    scrollToBottom()
  }
}

const generateFallbackDailyReport = () => {
  return `【今日运营日报 - FAQ降级模式】

由于AI服务暂时不可用，以下是基础数据摘要：

1. 今日新增订单：可在数据看板查看实时数据
2. 今日新增房源：可在数据看板查看实时数据  
3. 今日注册用户：可在数据看板查看实时数据
4. 监管成功率：可在数据看板查看实时数据

建议操作：
- 检查待审核房源，及时处理
- 关注异常订单，进行人工复核
- 确认已支付订单入住状态

（AI服务恢复后将提供更详细的智能分析）`
}

const generateFallbackWeeklyReport = () => {
  return `【近7天运营周报 - FAQ降级模式】

由于AI服务暂时不可用，以下是基础分析：

1. 订单趋势：建议查看数据看板的订单趋势图
2. 房源分布：建议查看数据看板的房源类型分布
3. 热门房源：建议查看数据看板的热门房源TOP5

关键指标建议：
- 关注入住率变化趋势
- 分析热门房源特征
- 优化定价策略

（AI服务恢复后将提供更详细的智能分析）`
}

const showFaq = () => {
  showFaqDialog.value = true
}

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

  timeoutId = setTimeout(fallbackToFaq, 2000)

  try {
    const res = await request({
      url: '/api/ai/chat',
      method: 'post',
      data: { question: text, scene: 'admin' },
      timeout: 60000,
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
  
  if (q.includes('订单') || q.includes('今日订单')) {
    return '关于订单查询：\n\n您可以在"数据看板"页面查看今日新增订单数。\n\n如需更详细的分析，请点击"生成日报"按钮获取AI生成的运营日报。'
  }
  if (q.includes('收入') || q.includes('趋势') || q.includes('7天') || q.includes('近7天')) {
    return '关于收入趋势：\n\n您可以在"数据看板"页面查看近7日订单趋势图。\n\n如需更详细的分析，请点击"生成周报"按钮获取AI生成的运营周报。'
  }
  if (q.includes('入住率')) {
    return '关于入住率：\n\n入住率数据可在"运营看板"页面查看。\n\n建议关注热门房源的入住情况，及时调整定价策略。'
  }
  if (q.includes('待处理') || q.includes('待审核')) {
    return '关于待处理事项：\n\n1. 待审核房源：在"房源审核"页面处理\n2. 待支付订单：在"订单监控"页面查看\n3. 异常订单：在"交易监管"页面人工复核'
  }
  if (q.includes('建议') || q.includes('经营')) {
    return '运营建议：\n\n1. 及时处理待审核房源，提升房源上线效率\n2. 关注异常订单（金额>20k或退款率高），进行人工复核\n3. 分析热门房源特征，优化定价策略\n4. 定期查看数据看板，掌握运营趋势'
  }
  
  return '抱歉，我暂时无法回答这个问题。\n\n您可以尝试以下操作：\n1. 点击"生成日报"获取今日运营摘要\n2. 点击"生成周报"获取近7天运营分析\n3. 点击"FAQ模式"查看常见问题解答'
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

.action-card {
  cursor: pointer;
  text-align: center;
  padding: 20px;
  transition: all 0.3s;

  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  }
}

.action-icon {
  font-size: 36px;
  margin-bottom: 10px;
}

.action-title {
  font-size: 16px;
  font-weight: bold;
  color: #303133;
  margin-bottom: 8px;
}

.action-desc {
  font-size: 13px;
  color: #909399;
}

.alert-line {
  font-size: 13px;
  line-height: 1.8;
}

.mb12 {
  margin-bottom: 12px;
}
</style>
