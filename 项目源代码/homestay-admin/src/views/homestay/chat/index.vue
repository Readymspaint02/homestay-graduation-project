<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="mb12">
      <template #title>租客沟通功能说明</template>
      <div class="alert-line">1. 在左侧会话列表选择租客，右侧进行实时对话</div>
      <div class="alert-line">2. 支持发送文字和图片消息，WebSocket实时通信</div>
      <div class="alert-line">3. 绿色状态表示已连接，可实时收发消息</div>
    </el-alert>

    <el-row :gutter="20">
      <el-col :xs="24" :sm="6">
        <el-card class="contact-card">
          <template #header>
            <div class="contact-header">
              <span>会话列表</span>
              <el-tag :type="connected ? 'success' : 'info'" size="small">
                {{ connected ? '已连接' : '未连接' }}
              </el-tag>
            </div>
          </template>
          <el-scrollbar height="400px" v-loading="loadingContacts">
            <div v-for="item in contacts" :key="item.userId"
              :class="['contact-item', { active: Number(activePeerId) === Number(item.userId) }]"
              @click="selectPeer(item.userId)">
              <div class="contact-info">
                <div class="contact-name">{{ item.nickName || item.userName || `租客${item.userId}` }}</div>
                <div class="contact-meta">
                  <span :class="['status-dot', { online: item.online }]"></span>
                  <span>{{ item.online ? '在线' : '离线' }}</span>
                </div>
              </div>
              <el-badge v-if="Number(item.unread || 0) > 0" :value="item.unread" />
            </div>
            <el-empty v-if="contacts.length === 0" description="暂无联系人" :image-size="60" />
          </el-scrollbar>
        </el-card>
      </el-col>

      <el-col :xs="24" :sm="18">
        <el-card>
          <template #header>
            <div class="chat-header-info">
              <span v-if="activePeer">{{ activePeer.nickName || activePeer.userName || `租客${activePeer.userId}` }}</span>
              <span v-else>请选择联系人</span>
              <el-tag v-if="typing" type="warning" size="small" style="margin-left: 8px">正在输入...</el-tag>
            </div>
          </template>

          <div class="chat-container" ref="chatContainer" v-loading="loadingHistory">
            <div v-for="msg in messages" :key="msg.localKey" :class="['message', msg.mine ? 'user' : 'peer']">
              <div class="message-content">
                <div v-if="msg.isImage" class="image-content">
                  <el-image :src="msg.content" fit="cover" style="max-width: 200px; max-height: 200px;"
                    :preview-src-list="[msg.content]" />
                </div>
                <div v-else class="text">{{ msg.content }}</div>
                <div class="time">{{ formatTime(msg.createTime) }}</div>
              </div>
            </div>
            <el-empty v-if="messages.length === 0 && !loadingHistory" description="暂无消息，发一条开始聊天吧" :image-size="80" />
          </div>

          <div class="input-area">
            <el-input v-model="chatDraft" type="textarea" :rows="3" :maxlength="500"
              placeholder="输入消息，Ctrl+Enter 发送" @keyup.enter.ctrl="sendChatMessage"
              @input="onTyping" />
            <div class="chat-actions">
              <el-upload :show-file-list="false" :before-upload="handleImageUpload" accept="image/*">
                <el-button size="small" :loading="uploadingImage">
                  <el-icon><Picture /></el-icon> 图片
                </el-button>
              </el-upload>
              <el-button size="small" @click="reloadCurrent">
                <el-icon><Refresh /></el-icon> 刷新
              </el-button>
              <el-button type="primary" size="small" :loading="sendingChat" @click="sendChatMessage">
                发送
              </el-button>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="LandlordChat">
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { ElMessage } from 'element-plus'
import { Picture, Refresh } from '@element-plus/icons-vue'
import request from '@/utils/request'
import { getToken } from '@/utils/auth'

class ChatWebSocket {
  ws = null
  reconnectTimer = null
  reconnectAttempts = 0
  maxReconnectAttempts = 5
  handlers = new Map()
  isConnected = false

  connect() {
    const token = getToken()
    if (!token) {
      console.warn('[ChatWS] No token')
      return
    }

    const baseUrl = import.meta.env.VITE_APP_BASE_API || ''
    const wsProtocol = baseUrl.startsWith('https://') ? 'wss:' : baseUrl.startsWith('http://') ? 'ws:' : window.location.protocol === 'https:' ? 'wss:' : 'ws:'
    const wsHost = baseUrl ? baseUrl.replace(/^https?:/, wsProtocol) : `${wsProtocol}//${window.location.host}`
    const wsUrl = `${wsHost}/ws/chat/${token}`

    try {
      this.ws = new WebSocket(wsUrl)
      
      this.ws.onopen = () => {
        console.log('[ChatWS] Connected')
        this.isConnected = true
        this.reconnectAttempts = 0
        this.emit('connected', { status: 'ok' })
      }

      this.ws.onmessage = (event) => {
        try {
          const msg = JSON.parse(event.data)
          this.emit(msg.type, msg.data || msg)
        } catch (e) {
          console.error('[ChatWS] Parse error:', e)
        }
      }

      this.ws.onclose = () => {
        console.log('[ChatWS] Disconnected')
        this.isConnected = false
        this.scheduleReconnect()
      }

      this.ws.onerror = (error) => {
        console.error('[ChatWS] Error:', error)
      }
    } catch (e) {
      console.error('[ChatWS] Connection failed:', e)
      this.scheduleReconnect()
    }
  }

  emit(type, data) {
    const handlers = this.handlers.get(type) || []
    handlers.forEach(handler => handler(data))
  }

  scheduleReconnect() {
    if (this.reconnectTimer) return
    if (this.reconnectAttempts >= this.maxReconnectAttempts) return

    this.reconnectAttempts++
    const delay = Math.min(1000 * Math.pow(2, this.reconnectAttempts), 30000)
    
    this.reconnectTimer = window.setTimeout(() => {
      this.reconnectTimer = null
      this.connect()
    }, delay)
  }

  disconnect() {
    if (this.reconnectTimer) {
      clearTimeout(this.reconnectTimer)
      this.reconnectTimer = null
    }
    if (this.ws) {
      this.ws.close()
      this.ws = null
    }
    this.isConnected = false
  }

  on(type, handler) {
    if (!this.handlers.has(type)) {
      this.handlers.set(type, [])
    }
    this.handlers.get(type).push(handler)
  }

  off(type, handler) {
    const handlers = this.handlers.get(type)
    if (handlers) {
      const index = handlers.indexOf(handler)
      if (index > -1) handlers.splice(index, 1)
    }
  }

  sendChat(receiverUserId, content) {
    if (!this.ws || !this.isConnected) return false
    this.ws.send(JSON.stringify({ type: 'chat', receiverUserId, content }))
    return true
  }

  sendImage(receiverUserId, imageUrl) {
    if (!this.ws || !this.isConnected) return false
    this.ws.send(JSON.stringify({ type: 'image', receiverUserId, content: imageUrl }))
    return true
  }

  sendTyping(receiverUserId) {
    if (!this.ws || !this.isConnected) return
    this.ws.send(JSON.stringify({ type: 'typing', receiverUserId }))
  }

  isOnline() {
    return this.isConnected
  }
}

const chatWebSocket = new ChatWebSocket()

const connected = ref(false)
const loadingContacts = ref(false)
const loadingHistory = ref(false)
const sendingChat = ref(false)
const uploadingImage = ref(false)
const typing = ref(false)
const contacts = ref([])
const activePeerId = ref(null)
const messages = ref([])
const chatDraft = ref('')
const chatContainer = ref(null)

const msgIdSet = new Set()

const activePeer = computed(() => contacts.value.find(it => Number(it.userId) === Number(activePeerId.value)))
const currentUserId = computed(() => {
  const token = getToken()
  if (!token) return 0
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return payload?.user_id || payload?.sub || 0
  } catch {
    return 0
  }
})

const handleWsMessage = (data) => {
  if (!data) return
  const incoming = normalizeMessage(data, Date.now())
  const peerId = incoming.mine ? incoming.receiverUserId : incoming.senderUserId
  if (Number(activePeerId.value) === Number(peerId)) {
    appendMessage(incoming)
    if (!incoming.mine) {
      request({ url: `/api/chat/read/${peerId}`, method: 'post' })
      setUnread(peerId, 0)
    }
    nextTick(() => scrollChatToBottom())
  } else if (!incoming.mine) {
    increaseUnread(peerId)
  }
}

const handleTyping = (data) => {
  if (data && Number(data.fromUserId) === Number(activePeerId.value)) {
    typing.value = true
    setTimeout(() => { typing.value = false }, 3000)
  }
}

onMounted(() => {
  loadContacts()
  chatWebSocket.connect()
  chatWebSocket.on('chat', handleWsMessage)
  chatWebSocket.on('connected', () => { connected.value = true })
  chatWebSocket.on('typing', handleTyping)
  connected.value = chatWebSocket.isOnline()
})

onBeforeUnmount(() => {
  chatWebSocket.off('chat', handleWsMessage)
  chatWebSocket.off('typing', handleTyping)
  chatWebSocket.disconnect()
})

const loadContacts = async () => {
  loadingContacts.value = true
  try {
    const res = await request({ url: '/api/chat/contacts', method: 'get' })
    contacts.value = Array.isArray(res?.data) ? res.data : []
    if (!activePeerId.value && contacts.value.length > 0) {
      activePeerId.value = Number(contacts.value[0].userId)
      await loadHistory(activePeerId.value)
    }
  } catch (err) {
    ElMessage.error(err?.msg || '联系人加载失败')
  } finally {
    loadingContacts.value = false
  }
}

const selectPeer = async (peerUserId) => {
  activePeerId.value = Number(peerUserId)
  await loadHistory(activePeerId.value)
}

const loadHistory = async (peerUserId) => {
  const peer = Number(peerUserId || 0)
  if (!peer) return
  loadingHistory.value = true
  msgIdSet.clear()
  try {
    const res = await request({ url: `/api/chat/history/${peer}`, method: 'get' })
    const rows = Array.isArray(res?.data) ? res.data : []
    messages.value = rows.map((item, index) => normalizeMessage(item, index))
    messages.value.forEach(item => {
      if (item.id > 0) msgIdSet.add(item.id)
    })
    setUnread(peer, 0)
    await request({ url: `/api/chat/read/${peer}`, method: 'post' })
    await nextTick()
    scrollChatToBottom()
  } catch (err) {
    ElMessage.error(err?.msg || '历史消息加载失败')
  } finally {
    loadingHistory.value = false
  }
}

const reloadCurrent = async () => {
  await loadContacts()
  if (activePeerId.value) {
    await loadHistory(activePeerId.value)
  }
}

const onTyping = () => {
  if (activePeerId.value && chatWebSocket.isOnline()) {
    chatWebSocket.sendTyping(activePeerId.value)
  }
}

const sendChatMessage = async () => {
  const peer = Number(activePeerId.value || 0)
  const text = String(chatDraft.value || '').trim()
  if (!peer) {
    ElMessage.warning('请先选择联系人')
    return
  }
  if (!text) {
    ElMessage.warning('请输入消息内容')
    return
  }
  if (sendingChat.value) return
  
  if (chatWebSocket.isOnline()) {
    const sent = chatWebSocket.sendChat(peer, text)
    if (sent) {
      chatDraft.value = ''
      return
    }
  }
  
  sendingChat.value = true
  try {
    const res = await request({
      url: '/api/chat/send',
      method: 'post',
      data: { receiverUserId: peer, content: text }
    })
    const sentMsg = normalizeMessage(res?.data || {}, Date.now())
    appendMessage(sentMsg)
    chatDraft.value = ''
    await nextTick()
    scrollChatToBottom()
  } catch (err) {
    ElMessage.error(err?.msg || '发送失败')
  } finally {
    sendingChat.value = false
  }
}

const handleImageUpload = async (file) => {
  const peer = Number(activePeerId.value || 0)
  if (!peer) {
    ElMessage.warning('请先选择联系人')
    return false
  }
  if (file.size > 10 * 1024 * 1024) {
    ElMessage.warning('图片大小不能超过 10MB')
    return false
  }
  uploadingImage.value = true
  try {
    const formData = new FormData()
    formData.append('file', file)
    formData.append('receiverUserId', peer)
    const res = await request({
      url: '/api/chat/upload',
      method: 'post',
      data: formData,
      headers: { 'Content-Type': 'multipart/form-data' }
    })
    const sent = normalizeMessage(res?.data || {}, Date.now())
    appendMessage(sent)
    if (chatWebSocket.isOnline() && sent.content) {
      chatWebSocket.sendImage(peer, sent.content)
    }
    await nextTick()
    scrollChatToBottom()
  } catch (err) {
    ElMessage.error(err?.msg || '图片发送失败')
  } finally {
    uploadingImage.value = false
  }
  return false
}

const normalizeMessage = (item, fallbackKey) => {
  const id = Number(item?.id || 0)
  const senderUserId = Number(item?.senderUserId || item?.sender_user_id || 0)
  const receiverUserId = Number(item?.receiverUserId || item?.receiver_user_id || 0)
  const content = String(item?.content || item?.message || '')
  const createTime = item?.createTime || item?.create_time || Date.now()
  const isRead = String(item?.isRead || item?.is_read || '0')
  const mine = senderUserId === currentUserId.value
  const isImage = isImageMessage(content)
  const imageContent = isImage ? resolveImageUrl(content) : ''
  return {
    id,
    localKey: id > 0 ? `msg_${id}` : `tmp_${fallbackKey}`,
    senderUserId,
    receiverUserId,
    content: imageContent || content,
    createTime,
    isRead,
    mine,
    isImage
  }
}

const isImageMessage = (content) => {
  if (!content) return false
  return content.startsWith('http') && /\.(jpg|jpeg|png|gif|webp|bmp)(\?.*)?$/i.test(content) || content.startsWith('/uploads/')
}

const resolveImageUrl = (content) => {
  if (!content) return ''
  if (content.startsWith('http://') || content.startsWith('https://')) return content
  const baseUrl = import.meta.env.VITE_APP_BASE_API || ''
  if (content.startsWith('/')) return `${baseUrl}${content}`
  return `${baseUrl}/${content}`
}

const appendMessage = (msg) => {
  if (msg.id > 0 && msgIdSet.has(msg.id)) return
  if (msg.id > 0) msgIdSet.add(msg.id)
  messages.value.push(msg)
}

const setUnread = (peerId, value) => {
  contacts.value = contacts.value.map(item =>
    Number(item.userId) === Number(peerId) ? { ...item, unread: value } : item
  )
}

const increaseUnread = (peerId) => {
  contacts.value = contacts.value.map(item => {
    if (Number(item.userId) !== Number(peerId)) return item
    return { ...item, unread: Number(item.unread || 0) + 1 }
  })
}

const formatTime = (value) => {
  if (!value) return '--'
  const date = new Date(value)
  if (Number.isNaN(date.getTime())) return String(value)
  const mm = `${date.getMonth() + 1}`.padStart(2, '0')
  const dd = `${date.getDate()}`.padStart(2, '0')
  const hh = `${date.getHours()}`.padStart(2, '0')
  const mi = `${date.getMinutes()}`.padStart(2, '0')
  return `${mm}-${dd} ${hh}:${mi}`
}

const scrollChatToBottom = () => {
  const el = chatContainer.value
  if (!el) return
  el.scrollTop = el.scrollHeight
}
</script>

<style scoped lang="scss">
.app-container {
  padding: 20px;
}

.mb12 {
  margin-bottom: 12px;
}

.alert-line {
  font-size: 13px;
  line-height: 1.8;
}

.contact-card {
  :deep(.el-card__body) {
    padding: 0;
  }
}

.contact-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.contact-item {
  padding: 12px 16px;
  border-bottom: 1px solid #ebeef5;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  justify-content: space-between;
  align-items: center;

  &:hover {
    background: #f5f7fa;
  }

  &.active {
    background: #ecf5ff;
    border-left: 3px solid #409eff;
  }
}

.contact-info {
  flex: 1;
}

.contact-name {
  font-size: 14px;
  color: #303133;
  font-weight: 500;
}

.contact-meta {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
  display: flex;
  align-items: center;
  gap: 4px;
}

.status-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #c0c4cc;

  &.online {
    background: #67c23a;
  }
}

.chat-header-info {
  display: flex;
  align-items: center;
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
      align-items: flex-end;
    }

    .text {
      background: #409eff;
      color: #fff;
    }

    .time {
      text-align: right;
    }
  }

  &.peer {
    text-align: left;

    .message-content {
      align-items: flex-start;
    }

    .text {
      background: #fff;
      border: 1px solid #e4e7ed;
    }
  }
}

.message-content {
  display: inline-flex;
  flex-direction: column;
  max-width: 70%;
}

.text {
  padding: 10px 14px;
  border-radius: 8px;
  font-size: 14px;
  line-height: 1.6;
  text-align: left;
  word-break: break-word;
}

.image-content {
  padding: 4px;
}

.time {
  font-size: 11px;
  color: #909399;
  margin-top: 4px;
}

.input-area {
  margin-top: 16px;
}

.chat-actions {
  margin-top: 8px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>