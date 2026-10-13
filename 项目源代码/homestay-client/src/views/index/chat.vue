<template>
  <div class="chat-page">
    <Header />
    <div class="chat-wrap">
      <template v-if="!isLogin">
        <div class="login-tip">
          <h3>私信对话</h3>
          <p>登录后可与房东实时沟通。</p>
          <a-button type="primary" @click="goLogin">去登录</a-button>
        </div>
      </template>

      <template v-else>
        <div class="chat-container">
          <div class="sidebar">
            <div class="sidebar-header">
              <span>会话列表</span>
              <a-tag :color="connected ? 'green' : 'default'">{{ connected ? '已连接' : '未连接' }}</a-tag>
            </div>
            <a-spin :spinning="loadingContacts">
              <div class="contact-list">
                <div
                  v-for="item in contacts"
                  :key="item.userId"
                  class="contact-item"
                  :class="{ active: Number(activePeerId) === Number(item.userId) }"
                  @click="selectPeer(item.userId)"
                >
                  <div class="contact-main">
                    <div class="contact-name">{{ item.nickName || item.userName || `用户${item.userId}` }}</div>
                    <div class="contact-meta">
                      <span class="dot" :class="{ online: item.online }"></span>
                      <span>{{ item.online ? '在线' : '离线' }}</span>
                    </div>
                  </div>
                  <a-badge v-if="Number(item.unread || 0) > 0" :count="item.unread" />
                </div>
                <div v-if="contacts.length === 0 && !targetLandlordId" class="empty-tip">暂无联系人</div>
              </div>
            </a-spin>
          </div>

          <div class="main-panel">
            <div class="chat-header">
              <span v-if="activePeer">{{ activePeer.nickName || activePeer.userName || `用户${activePeer.userId}` }}</span>
              <span v-else>请选择联系人</span>
            </div>

            <a-spin :spinning="loadingHistory" style="flex: 1; min-height: 200px">
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
                v-model:value="chatDraft"
                :rows="2"
                :maxlength="500"
                placeholder="输入消息，Enter 发送，Shift+Enter 换行"
                @keydown.enter.prevent="onChatEnter"
              />
              <div class="chat-actions">
                <a-upload
                  :show-upload-list="false"
                  :before-upload="handleImageUpload"
                  accept="image/*"
                >
                  <a-button size="small">图片</a-button>
                </a-upload>
                <a-button size="small" @click="reloadCurrent">刷新</a-button>
                <a-button type="primary" size="small" :loading="sendingChat" @click="sendChatMessage">发送</a-button>
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
import { computed, nextTick, onBeforeUnmount, onMounted, ref } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { message } from 'ant-design-vue';
import Header from '/@/views/index/components/header.vue';
import Footer from '/@/views/index/components/footer.vue';
import { contactsApi, userInfoApi, historyApi, readApi, sendApi, sendImageApi, isImageMessage, resolveImageUrl } from '/@/api/chat';
import { BASE_URL, USER_ID, USER_TOKEN } from '/@/store/constants';
import { chatWebSocket } from '/@/utils/websocket';

const route = useRoute();
const router = useRouter();

const isLogin = computed(() => !!localStorage.getItem(USER_TOKEN));
const currentUserId = computed(() => Number(localStorage.getItem(USER_ID) || 0));
const targetLandlordId = computed(() => Number(route.query.landlordId || route.query.userId || 0));

const connected = ref(false);
const loadingContacts = ref(false);
const loadingHistory = ref(false);
const sendingChat = ref(false);
const contacts = ref<any[]>([]);
const activePeerId = ref<number>();
const messages = ref<any[]>([]);
const chatDraft = ref('');
const chatListRef = ref<HTMLElement>();

const msgIdSet = new Set<number>();

const activePeer = computed(() => contacts.value.find((it) => Number(it.userId) === Number(activePeerId.value)));

const handleWsMessage = (data: any) => {
  if (!data || data.type !== 'chat') return;
  const msgData = data.data || data;
  const incoming = normalizeMessage(msgData, Date.now());
  const peerId = incoming.mine ? incoming.receiverUserId : incoming.senderUserId;
  if (Number(activePeerId.value) === Number(peerId)) {
    appendMessage(incoming);
    if (!incoming.mine) {
      readApi(peerId);
      setUnread(peerId, 0);
    }
    nextTick(() => scrollChatToBottom());
  } else if (!incoming.mine) {
    increaseUnread(peerId);
  }
};

const handleConnected = () => {
  connected.value = true;
};

onMounted(async () => {
  if (!isLogin.value) return;
  
  await loadContacts();
  chatWebSocket.on('chat', handleWsMessage);
  chatWebSocket.on('connected', handleConnected);
  chatWebSocket.connect();
  connected.value = chatWebSocket.isOnline();
  
  if (targetLandlordId.value > 0) {
    await selectPeer(targetLandlordId.value);
  }
});

onBeforeUnmount(() => {
  chatWebSocket.off('chat', handleWsMessage);
  chatWebSocket.off('connected', handleConnected);
});

const goLogin = () => {
  router.push({ name: 'login', query: { redirect: route.fullPath } });
};

const loadContacts = async () => {
  loadingContacts.value = true;
  try {
    const res = await contactsApi();
    contacts.value = Array.isArray(res?.data) ? res.data : [];
    
    if (targetLandlordId.value > 0) {
      const exists = contacts.value.find((c) => Number(c.userId) === targetLandlordId.value);
      if (!exists) {
        try {
          const userRes = await userInfoApi(targetLandlordId.value);
          if (userRes?.data?.nickName) {
            contacts.value.unshift({
              userId: targetLandlordId.value,
              userName: userRes.data.userName || `房东${targetLandlordId.value}`,
              nickName: userRes.data.nickName || `房东${targetLandlordId.value}`,
              online: false,
              unread: 0,
            });
          } else {
            contacts.value.unshift({
              userId: targetLandlordId.value,
              userName: `房东${targetLandlordId.value}`,
              nickName: `房东${targetLandlordId.value}`,
              online: false,
              unread: 0,
            });
          }
        } catch {
          contacts.value.unshift({
            userId: targetLandlordId.value,
            userName: `房东${targetLandlordId.value}`,
            nickName: `房东${targetLandlordId.value}`,
            online: false,
            unread: 0,
          });
        }
      }
    }
    
    if (!activePeerId.value && contacts.value.length > 0) {
      const initialId = targetLandlordId.value > 0 ? targetLandlordId.value : Number(contacts.value[0].userId);
      activePeerId.value = initialId;
      await loadHistory(initialId);
    }
  } catch (err: any) {
    message.error(err?.msg || '联系人加载失败');
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
    scrollChatToBottom();
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

const sendChatMessage = async () => {
  const peer = Number(activePeerId.value || 0);
  const text = String(chatDraft.value || '').trim();
  if (!peer) {
    message.warning('请先选择联系人');
    return;
  }
  if (!text) {
    message.warning('请输入消息内容');
    return;
  }
  if (sendingChat.value) return;
  
  if (chatWebSocket.isOnline()) {
    const sent = chatWebSocket.sendChat(peer, text);
    if (sent) {
      chatDraft.value = '';
      return;
    }
  }
  
  sendingChat.value = true;
  try {
    const res = await sendApi({ receiverUserId: peer, content: text });
    const sent = normalizeMessage(res?.data || {}, Date.now());
    appendMessage(sent);
    chatDraft.value = '';
    await nextTick();
    scrollChatToBottom();
  } catch (err: any) {
    message.error(err?.msg || '发送失败');
  } finally {
    sendingChat.value = false;
  }
};

const onChatEnter = (e: KeyboardEvent) => {
  if (e.shiftKey) {
    chatDraft.value += '\n';
    return;
  }
  sendChatMessage();
};

const handleImageUpload = async (file: File) => {
  const peer = Number(activePeerId.value || 0);
  if (!peer) {
    message.warning('请先选择联系人');
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
    scrollChatToBottom();
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

const scrollChatToBottom = () => {
  const el = chatListRef.value;
  if (!el) return;
  el.scrollTop = el.scrollHeight;
};
</script>

<style scoped lang="less">
.chat-page {
  min-height: 100%;
  background: linear-gradient(180deg, #f2f7ff 0%, #f8fbff 100%);
}

.chat-wrap {
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

.chat-container {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 12px;
  min-height: 600px;
}

.sidebar {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
  display: flex;
  flex-direction: column;
}

.sidebar-header {
  padding: 12px;
  border-bottom: 1px solid #e2e8f0;
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-weight: 600;
  color: #334155;
}

.contact-list {
  flex: 1;
  overflow-y: auto;
  padding: 8px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.contact-item {
  border: 1px solid #e2e8f0;
  border-radius: 8px;
  padding: 10px;
  display: flex;
  justify-content: space-between;
  align-items: center;
  cursor: pointer;
  transition: all 0.2s;
}

.contact-item:hover {
  border-color: #1677ff;
}

.contact-item.active {
  border-color: #1677ff;
  background: #f0f7ff;
}

.contact-name {
  font-size: 14px;
  color: #0f172a;
}

.contact-meta {
  margin-top: 4px;
  font-size: 12px;
  color: #64748b;
  display: flex;
  align-items: center;
  gap: 4px;
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #cbd5e1;
}

.dot.online {
  background: #22c55e;
}

.empty-tip {
  color: #94a3b8;
  font-size: 13px;
  text-align: center;
  padding: 16px 8px;
}

.main-panel {
  background: #fff;
  border: 1px solid #d9e6ff;
  border-radius: 10px;
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
  min-height: 400px;
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
  padding: 8px 12px;
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
  max-width: 180px;
  max-height: 180px;
  border-radius: 8px;
  cursor: pointer;
}

.empty-chat {
  color: #94a3b8;
  text-align: center;
  margin-top: 100px;
}

.chat-input {
  border-top: 1px solid #e2e8f0;
  padding: 10px;
}

.chat-actions {
  margin-top: 8px;
  display: flex;
  justify-content: flex-end;
  gap: 8px;
}

@media (max-width: 900px) {
  .chat-container {
    grid-template-columns: 1fr;
  }

  .sidebar {
    display: none;
  }
}
</style>