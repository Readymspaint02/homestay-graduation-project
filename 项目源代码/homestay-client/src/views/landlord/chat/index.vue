<template>
  <div class="chat-page">
    <div class="chat-wrap">
      <aside class="contact-panel">
        <div class="panel-title">
          <span>租客会话</span>
          <a-tag :color="connected ? 'green' : 'default'">{{ connected ? '已连接' : '未连接' }}</a-tag>
        </div>
        <a-spin :spinning="loadingContacts" style="min-height: 120px">
          <div class="contact-list">
            <div
              v-for="item in contacts"
              :key="item.userId"
              class="contact-item"
              :class="{ active: Number(activePeerId) === Number(item.userId) }"
              @click="selectPeer(item.userId)"
            >
              <div class="contact-avatar">{{ (item.nickName || item.userName || '?')[0] }}</div>
              <div class="contact-main">
                <div class="name">{{ item.nickName || item.userName || `租客${item.userId}` }}</div>
                <div class="meta">
                  <span class="dot" :class="{ online: item.online }"></span>
                  <span>{{ item.online ? '在线' : '离线' }}</span>
                </div>
              </div>
              <a-badge v-if="Number(item.unread || 0) > 0" :count="item.unread" />
            </div>
            <div v-if="contacts.length === 0" class="empty">暂无租客对话</div>
          </div>
        </a-spin>
      </aside>

      <section class="chat-panel">
        <div class="chat-header">
          <span v-if="activePeer">{{ activePeer.nickName || activePeer.userName || `租客${activePeer.userId}` }}</span>
          <span v-else>请选择租客开始对话</span>
        </div>

        <a-spin :spinning="loadingHistory" style="flex: 1; min-height: 260px">
          <div class="chat-list" ref="chatListRef">
            <div v-for="msg in messages" :key="msg.localKey" class="msg-row" :class="{ mine: msg.mine }">
              <div class="bubble">
                <div v-if="msg.isImage" class="image-content">
                  <img :src="msg.content" alt="图片" class="chat-image" @click="previewImage(msg.content)" />
                </div>
                <div v-else class="content">{{ msg.content }}</div>
                <div class="time">{{ formatTime(msg.createTime) }}</div>
              </div>
            </div>
            <div v-if="messages.length === 0" class="empty-chat">暂无消息，发一条开始聊天吧</div>
          </div>
        </a-spin>

        <div class="chat-input">
          <a-textarea
            v-model:value="draft"
            :rows="3"
            :maxlength="500"
            placeholder="输入消息，Enter 发送，Shift+Enter 换行"
            @keydown.enter.prevent="onEnter"
          />
          <div class="actions">
            <a-upload
              :show-upload-list="false"
              :before-upload="handleImageUpload"
              accept="image/*"
            >
              <a-button>
                <template #icon>
                  <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2" ry="2"/><circle cx="8.5" cy="8.5" r="1.5"/><polyline points="21 15 16 10 5 21"/></svg>
                </template>
                图片
              </a-button>
            </a-upload>
            <a-button @click="reloadCurrent">刷新</a-button>
            <a-button type="primary" :loading="sending" @click="sendMessage">发送</a-button>
          </div>
        </div>
      </section>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue';
import { message } from 'ant-design-vue';
import { contactsApi, historyApi, readApi, sendApi, sendImageApi, isImageMessage, resolveImageUrl } from '/@/api/chat';
import { USER_ID, USER_TOKEN } from '/@/store/constants';
import { chatWebSocket } from '/@/utils/websocket';

const loadingContacts = ref(false);
const loadingHistory = ref(false);
const sending = ref(false);
const connected = ref(false);
const contacts = ref<any[]>([]);
const activePeerId = ref<number>();
const messages = ref<any[]>([]);
const draft = ref('');
const chatListRef = ref<HTMLElement>();

const msgIdSet = new Set<number>();

const currentUserId = computed(() => Number(localStorage.getItem(USER_ID) || 0));
const activePeer = computed(() => contacts.value.find((it) => Number(it.userId) === Number(activePeerId.value)));

const handleWsMessage = (data: any) => {
  if (!data || data.type !== 'chat') return;
  const msgData = data.data || data;
  const fromUserId = Number(msgData.senderUserId || 0);
  const incoming = normalizeMessage(msgData, Date.now());
  const peerId = incoming.mine ? incoming.receiverUserId : incoming.senderUserId;
  if (Number(activePeerId.value) === Number(peerId)) {
    appendMessage(incoming);
    if (!incoming.mine) {
      readApi(peerId);
      setUnread(peerId, 0);
    }
    nextTick(() => scrollToBottom());
  } else if (!incoming.mine) {
    increaseUnread(peerId);
  }
};

const handleConnected = () => {
  connected.value = true;
};

onMounted(async () => {
  await loadContacts();
  chatWebSocket.on('chat', handleWsMessage);
  chatWebSocket.on('connected', handleConnected);
  chatWebSocket.connect();
  connected.value = chatWebSocket.isOnline();
});

onBeforeUnmount(() => {
  chatWebSocket.off('chat', handleWsMessage);
  chatWebSocket.off('connected', handleConnected);
});

const loadContacts = async () => {
  loadingContacts.value = true;
  try {
    const res = await contactsApi();
    contacts.value = Array.isArray(res?.data) ? res.data : [];
    if (!activePeerId.value && contacts.value.length > 0) {
      activePeerId.value = Number(contacts.value[0].userId);
      await loadHistory(activePeerId.value);
    }
  } catch (err: any) {
    message.error(err?.msg || '租客列表加载失败');
  } finally {
    loadingContacts.value = false;
  }
};

const selectPeer = async (peerUserId: number) => {
  activePeerId.value = Number(peerUserId);
  await loadHistory(activePeerId.value);
};

const loadHistory = async (peerUserId?: number) => {
  const peer = Number(peerUserId || 0);
  if (!peer) return;
  loadingHistory.value = true;
  msgIdSet.clear();
  try {
    const res = await historyApi(peer);
    const rows = Array.isArray(res?.data) ? res.data : [];
    messages.value = rows.map((item: any, index: number) => normalizeMessage(item, index));
    messages.value.forEach((item) => {
      if (item.id > 0) msgIdSet.add(item.id);
    });
    setUnread(peer, 0);
    await readApi(peer);
    await nextTick();
    scrollToBottom();
  } catch (err: any) {
    message.error(err?.msg || '历史消息加载失败');
  } finally {
    loadingHistory.value = false;
  }
};

const reloadCurrent = async () => {
  await loadContacts();
  if (activePeerId.value) {
    await loadHistory(activePeerId.value);
  }
};

const sendMessage = async () => {
  const peer = Number(activePeerId.value || 0);
  const text = String(draft.value || '').trim();
  if (!peer) {
    message.warning('请先选择租客');
    return;
  }
  if (!text) {
    message.warning('请输入消息内容');
    return;
  }
  if (sending.value) return;
  
  if (chatWebSocket.isOnline()) {
    const sent = chatWebSocket.sendChat(peer, text);
    if (sent) {
      draft.value = '';
      return;
    }
  }
  
  sending.value = true;
  try {
    const res = await sendApi({ receiverUserId: peer, content: text });
    const sent = normalizeMessage(res?.data || {}, Date.now());
    appendMessage(sent);
    draft.value = '';
    await nextTick();
    scrollToBottom();
  } catch (err: any) {
    message.error(err?.msg || '发送失败');
  } finally {
    sending.value = false;
  }
};

const onEnter = (e: KeyboardEvent) => {
  if (e.shiftKey) {
    draft.value += '\n';
    return;
  }
  sendMessage();
};

const handleImageUpload = async (file: File) => {
  const peer = Number(activePeerId.value || 0);
  if (!peer) {
    message.warning('请先选择租客');
    return false;
  }
  if (file.size > 10 * 1024 * 1024) {
    message.warning('图片大小不能超过 10MB');
    return false;
  }
  try {
    const res = await sendImageApi(peer, file);
    const sent = normalizeMessage(res?.data || {}, Date.now());
    appendMessage(sent);
    if (chatWebSocket.isOnline() && sent.content) {
      chatWebSocket.sendImage(peer, sent.content);
    }
    await nextTick();
    scrollToBottom();
  } catch (err: any) {
    message.error(err?.msg || '图片发送失败');
  }
  return false;
};

const previewImage = (url: string) => {
  window.open(url, '_blank');
};

const normalizeMessage = (item: any, fallbackKey: number) => {
  const id = Number(item?.id || 0);
  const senderUserId = Number(item?.senderUserId || 0);
  const receiverUserId = Number(item?.receiverUserId || 0);
  const content = String(item?.content || item?.message || '');
  const createTime = item?.createTime || item?.timestamp || Date.now();
  const isRead = String(item?.isRead || '0');
  const mine = senderUserId === currentUserId.value;
  const imageContent = isImageMessage(content) ? resolveImageUrl(content) : '';
  return { id, localKey: id > 0 ? `msg_${id}` : `tmp_${fallbackKey}`, senderUserId, receiverUserId, content: imageContent || content, createTime, isRead, mine, isImage: !!imageContent };
};

const appendMessage = (msg: any) => {
  if (msg.id > 0 && msgIdSet.has(msg.id)) return;
  if (msg.id > 0) msgIdSet.add(msg.id);
  messages.value.push(msg);
};

const setUnread = (peerId: number, value: number) => {
  contacts.value = contacts.value.map((item) =>
    Number(item.userId) === Number(peerId) ? { ...item, unread: value } : item,
  );
};

const increaseUnread = (peerId: number) => {
  contacts.value = contacts.value.map((item) => {
    if (Number(item.userId) !== Number(peerId)) return item;
    return { ...item, unread: Number(item.unread || 0) + 1 };
  });
};

const formatTime = (value: any) => {
  if (!value) return '--';
  const date = new Date(value);
  if (Number.isNaN(date.getTime())) return String(value);
  const hh = `${date.getHours()}`.padStart(2, '0');
  const mm = `${date.getMinutes()}`.padStart(2, '0');
  return `${hh}:${mm}`;
};

const scrollToBottom = () => {
  const el = chatListRef.value;
  if (!el) return;
  el.scrollTop = el.scrollHeight;
};
</script>

<style scoped lang="less">
.chat-page {
  height: calc(100vh - 120px);
  background: linear-gradient(180deg, #f2f7ff 0%, #f8fbff 100%);
}

.chat-wrap {
  height: 100%;
  display: grid;
  grid-template-columns: 280px 1fr;
  gap: 12px;
}

.contact-panel,
.chat-panel {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
}

.contact-panel {
  padding: 12px;
  display: flex;
  flex-direction: column;
}

.panel-title {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #334155;
  padding-bottom: 12px;
  border-bottom: 1px solid #e2e8f0;
}

.contact-list {
  margin-top: 10px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  flex: 1;
  overflow-y: auto;
}

.contact-item {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 10px;
  display: flex;
  align-items: center;
  cursor: pointer;
  transition: all 0.2s;
}

.contact-item:hover {
  border-color: #1677ff;
  background: #f0f7ff;
}

.contact-item.active {
  border-color: #1677ff;
  background: #f0f7ff;
}

.contact-avatar {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  background: #1677ff;
  color: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: 600;
  font-size: 14px;
  margin-right: 10px;
  flex-shrink: 0;
}

.contact-main {
  flex: 1;
  min-width: 0;
}

.contact-item .name {
  color: #0f172a;
  font-size: 14px;
}

.contact-item .meta {
  margin-top: 4px;
  color: #64748b;
  font-size: 12px;
  display: inline-flex;
  align-items: center;
  gap: 5px;
}

.dot {
  width: 7px;
  height: 7px;
  border-radius: 50%;
  background: #cbd5e1;
}

.dot.online {
  background: #22c55e;
}

.empty {
  color: #94a3b8;
  font-size: 13px;
  padding: 8px 2px;
}

.chat-panel {
  display: flex;
  flex-direction: column;
  min-height: 0;
}

.chat-header {
  height: 50px;
  border-bottom: 1px solid #e2e8f0;
  padding: 0 14px;
  display: flex;
  align-items: center;
  font-weight: 600;
  color: #1e293b;
}

.chat-list {
  flex: 1;
  overflow-y: auto;
  padding: 12px;
  background: #f8fbff;
}

.msg-row {
  display: flex;
  margin-bottom: 10px;
}

.msg-row.mine {
  justify-content: flex-end;
}

.bubble {
  max-width: 70%;
  border-radius: 10px;
  background: #fff;
  border: 1px solid #e2e8f0;
  padding: 8px 10px 6px;
}

.msg-row.mine .bubble {
  background: #1677ff;
  border-color: #1677ff;
  color: #fff;
}

.content {
  line-height: 20px;
  white-space: pre-wrap;
  word-break: break-word;
}

.time {
  margin-top: 4px;
  font-size: 11px;
  color: #64748b;
}

.msg-row.mine .time {
  color: rgba(255, 255, 255, 0.85);
}

.image-content {
  margin: 0;
}

.chat-image {
  max-width: 200px;
  max-height: 200px;
  border-radius: 8px;
  cursor: pointer;
  display: block;
  transition: transform 0.2s;
}

.chat-image:hover {
  transform: scale(1.05);
}

.empty-chat {
  color: #94a3b8;
  text-align: center;
  margin-top: 80px;
}

.chat-input {
  border-top: 1px solid #e2e8f0;
  padding: 10px;
}

.actions {
  margin-top: 8px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}
</style>
