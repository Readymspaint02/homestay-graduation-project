<template>
  <div class="content-list">
    <div class="list-title">消息中心</div>
    <a-tabs v-model:activeKey="activeTab" class="msg-tabs">
      <a-tab-pane key="notification" tab="系统通知" />
      <a-tab-pane key="chat" tab="私信对话" />
    </a-tabs>

    <!-- 系统通知 -->
    <a-spin v-if="activeTab === 'notification'" :spinning="loading" style="min-height: 200px;">
      <div class="list-content">
        <div class="notification-view">
          <div class="list">
            <div class="notification-item flex-view" v-for="item in msgData" :key="item.id">
              <img
                src="data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADsAAAA7CAYAAADFJfKzAAAF+ElEQVRoge2aW2xURRjH/7Pby0IvttuW3oAWUKMWNTQSawmEaMBIQIOlQMtFwJZS0hovDxp9MPHFGCGEtgp4Ly3ygvEBE2MMGkO4eKsJXrgWArSlpWVvSgva3XFmztk9ezm7e073ZJss+9+e7NnpmW++35nvzMy3s2RB3V6KO0SmyXYgnkrCJqqSsImqJGyiKgmbqErCJqqSsImqFGPMREqciIH2JmJLkUGwsoJ9JN5CPU5SA20FyrgwpvyPYtW8I5iSNirOKaWy01pTZul6Xo+/rBkOrHjoqDjXbCKCDIClPlBQD+aWXMKuVR2YknpTfFYcjeatYoeyetYpdrSt3o0ZuUOKnRhlYM9SuUck4J01e2BJYT3scWsA9gNl1+ekO9C2th3leYPif1KExN67hsBS74s56tXD0y9iR+0+pJvHogAHgVqc6KjrwCwBKoc081kj4tjQnuUOEao4NW96L3bWfoA0VWD58APNTneive49zC4YDLRLqXx1bMCGzrOUhjpTOfMCdtSoASMQ1OJC+9r3Mafgmppl+WbGprgsKh4pv4B3az5CqumWBMwHHDk8+efM9L8F6D2FAyF1faO6ATIcNlyozS8/h3e8wDIkf+egbWsY6LR+o10JUVyXi1WzzuLtlR8jlUghnZnmwu41e3BfUV9c2o/72rh6zhm89XQnC4Hb2LV6L+4vuhq3ticlEags70UaC+eKkviBck1a1kOpO/pF6jUn3KZKIkBDTqPOb2J01Tfx+y9ANNbwzbeR2iHeRIEElnIFwSoZB/XNbUGoqtMA9S0X/3NrS6S0LhDG3WbJtscjxSFVyXpIUBkxCZcEuF+2pOoZd2RZxXEUZdsUp6LOdRSOmxZ0HFmCiuLLKMsf0QQTSaf6ZqL7eDXWV30HS9o4oqZ3MjSH7B0uxQ8X5ik9DbUwFp1J0XPlbrZGbUMxA9aj2QX9aOrcjH2bPkFZ3g1ddf31e98MvHywHm8+cwgL7z2jq+7566U41LNI+uCXAocdoK45rWg50IxBV66uhp6t/AVbF3+PbZ9twpUbebrqevVnfyle+ryOgX6pG7R3uBgtB5vhHMsIicYIozHBgDMf27ubMOTK0dXgyspfsWXRUTR3bkSfTd/N+mugBC901+P15YcZ6FlddXuHC5m/W+HioFxBz3IoLJEvEocJ/Q4G3NWIYVe25kYJoaid/xOeW3gMTayHtQKfZqCtXevwxoqv8PgDpzW3x3VpZBrzcyvr0WzhNyGho3IQrPKAixerZDKZ0eeYhm3M0PA/WbocWM2ANyw4IYAH7IHRQYIGm3ODRWhhoK8t/3oCoAWiQxy3shmnWfgtgH1tSO8qYSwN10TcHXaYUmAypzDgQmzb34gbOoHXPnoS66pPMuDNAcD+qBLoBrzKQJdU/KHL/uURKfJsYzmsY1IlWH74ph2lpTDPbBhgezGauxp0A9dXncCaqh/RtH+L8vwzh7jOXy9ES/dGvPLUN1iqE5QPgDzibGO5Cqi3R4NAI8DKF6oAX7aVYPuBBthGM3Q5tv6x4+w5/plFRwMDvkvY5ANKa/fzeHHpt3hy7ild9q7aOWijDJqigIoQDgUVJdF/GqR84SXloePwuMdRnt+PPRs+hHXqTV1OfnpsMb7oqWYLkCxkWcbQ+sRhLHvwN102OGizGEOsgT0aAVSUavsdVDCwGx4GbZ1qR36mUy5Xr0lMYniXQsskhdjFkWKxrLSk/osy65C0SvN4xDeTojWPujEizxJDLitc3sFIIyiXxh0BImYiaTFiEsFvYgX2sTzYR62SkxF3LIg8FRDZKWbFTHCbrXvPXS/zJRGUKl/ChbMl2mf1iVmGDDMYxQCrAMsPMghbkFPWGHdUWmtHCBDvmlUGJX7FHJADSO/R7Sg3jSjTiwZQLp17PdwwL"
                class="avatar"
              />
              <div class="content-box">
                <div class="header">
                  <span class="title-txt">{{ item.title }}</span>
                  <span class="time">{{ item.createTime }}</span>
                </div>
                <div class="content">
                  <p>{{ item.content }}</p>
                </div>
                <div class="actions">
                  <a-button
                    v-if="String(item.isRead || '0') !== '1'"
                    type="link"
                    size="small"
                    @click="handleRead(item)"
                  >
                    标记已读
                  </a-button>
                  <span v-else class="read-tag">已读</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </a-spin>

    <!-- 私信对话 -->
    <div v-if="activeTab === 'chat'" class="chat-panel">
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
              <div v-if="contacts.length === 0" class="empty-tip">暂无联系人</div>
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
    </div>
  </div>
</template>

<script setup lang="ts">
import { message } from 'ant-design-vue';
import { listApi, readApi as readMessageApi } from '/@/api/message';
import { contactsApi, userInfoApi, historyApi, readApi, sendApi, sendImageApi, isImageMessage, resolveImageUrl } from '/@/api/chat';
import { subscribeSseApi } from '/@/api/order';
import { USER_TOKEN, USER_ID, BASE_URL } from '/@/store/constants';
import { chatWebSocket } from '/@/utils/websocket';
import { ref, computed, onMounted, onBeforeUnmount, nextTick, watch } from 'vue';
import { useRoute } from 'vue-router';

const route = useRoute();
const activeTab = ref('notification');

const loading = ref(false);
const msgData = ref<any[]>([]);

const connected = ref(false);
const loadingContacts = ref(false);
const loadingHistory = ref(false);
const sendingChat = ref(false);
const contacts = ref<any[]>([]);
const activePeerId = ref<number>();
const messages = ref<any[]>([]);
const chatDraft = ref('');
const chatListRef = ref<HTMLElement>();

const currentUserId = computed(() => Number(localStorage.getItem(USER_ID) || 0));
const activePeer = computed(() => contacts.value.find((it) => Number(it.userId) === Number(activePeerId.value)));

let eventSource: EventSource | null = null;
const msgIdSet = new Set<number>();

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

onMounted(() => {
  getMessageList();
  connectSse();
  chatWebSocket.on('chat', handleWsMessage);
  chatWebSocket.on('connected', handleConnected);
  
  const queryTab = route.query.tab as string;
  const queryPeerId = Number(route.query.peerId || 0);
  if (queryTab === 'chat') {
    activeTab.value = 'chat';
    if (queryPeerId > 0) {
      activePeerId.value = queryPeerId;
    }
    initChat();
  } else if (activeTab.value === 'chat') {
    initChat();
  }
});

onBeforeUnmount(() => {
  closeSse();
  chatWebSocket.off('chat', handleWsMessage);
  chatWebSocket.off('connected', handleConnected);
});

const connectSse = () => {
  const token = localStorage.getItem(USER_TOKEN);
  if (!token) return;
  const baseUrl = subscribeSseApi();
  const auth = token.startsWith('Bearer ') ? token : `Bearer ${token}`;
  const url = `${baseUrl}?Authorization=${encodeURIComponent(auth)}`;
  eventSource = new EventSource(url);
  eventSource.addEventListener('new_message', (event: MessageEvent) => {
    try {
      const data = JSON.parse(event.data);
      const exists = msgData.value.some((m) => Number(m.id) === Number(data.id));
      if (!exists) {
        msgData.value.unshift({
          id: data.id,
          title: data.title || '新消息',
          content: data.content || '',
          createTime: new Date().toLocaleString(),
          isRead: '0',
        });
      }
    } catch (_e) { }
  });
  eventSource.addEventListener('order_status', (event: MessageEvent) => {
    getMessageList();
  });
  eventSource.onerror = () => {
    setTimeout(() => connectSse(), 5000);
  };
};

const closeSse = () => {
  if (eventSource) {
    eventSource.close();
    eventSource = null;
  }
};

const getMessageList = () => {
  loading.value = true;
  listApi({})
    .then((res) => {
      msgData.value = Array.isArray(res?.data) ? res.data : [];
    })
    .catch((err) => {
      console.log(err);
      message.error(err?.msg || '消息加载失败');
    })
    .finally(() => {
      loading.value = false;
    });
};

const handleRead = async (item: any) => {
  const id = Number(item?.id || 0);
  if (!id) return;
  try {
    await readMessageApi(id);
    item.isRead = '1';
    message.success('已标记为已读');
  } catch (err: any) {
    message.error(err?.msg || '操作失败');
  }
};

const loadContacts = async () => {
  loadingContacts.value = true;
  try {
    const res = await contactsApi();
    contacts.value = Array.isArray(res?.data) ? res.data : [];
    
    const targetPeerId = Number(activePeerId.value || 0);
    const existsInContacts = contacts.value.some((it) => Number(it.userId) === targetPeerId);
    
    if (targetPeerId > 0 && existsInContacts) {
      await loadHistory(targetPeerId);
    } else if (!activePeerId.value && contacts.value.length > 0) {
      activePeerId.value = Number(contacts.value[0].userId);
      await loadHistory(activePeerId.value);
    } else if (targetPeerId > 0 && !existsInContacts) {
      try {
        const userRes = await userInfoApi(targetPeerId);
        if (userRes?.data) {
          contacts.value.unshift({
            userId: targetPeerId,
            nickName: userRes.data.nickName || userRes.data.userName || `用户${targetPeerId}`,
            userName: userRes.data.userName || `用户${targetPeerId}`,
            online: false,
            unread: 0,
          });
        } else {
          contacts.value.unshift({
            userId: targetPeerId,
            nickName: `用户${targetPeerId}`,
            userName: `用户${targetPeerId}`,
            online: false,
            unread: 0,
          });
        }
      } catch {
        contacts.value.unshift({
          userId: targetPeerId,
          nickName: `用户${targetPeerId}`,
          userName: `用户${targetPeerId}`,
          online: false,
          unread: 0,
        });
      }
      await loadHistory(targetPeerId);
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

const initChat = async () => {
  await loadContacts();
  chatWebSocket.connect();
  connected.value = chatWebSocket.isOnline();
};

watch(activeTab, (newTab) => {
  if (newTab === 'chat' && contacts.value.length === 0) {
    initChat();
  }
});
</script>

<style scoped lang="less">
.content-list {
  flex: 1;
}

.list-title {
  color: #152844;
  font-weight: 600;
  font-size: 18px;
  height: 48px;
  margin-bottom: 4px;
  border-bottom: 1px solid #cedce4;
}

.msg-tabs {
  margin-top: 8px;
}

.notification-view {
  .list {
    min-height: 200px;
  }
}

.flex-view {
  display: flex;
}

.notification-item {
  padding-top: 16px;

  .avatar {
    width: 32px;
    height: 32px;
    border-radius: 50%;
    margin-right: 8px;
  }

  .content-box {
    flex: 1;
    border-bottom: 1px dashed #e9e9e9;
    padding: 4px 0 16px;
  }

  .header {
    margin-bottom: 12px;
  }

  .title-txt {
    color: #315c9e;
    font-weight: 500;
    font-size: 14px;
  }

  .time {
    color: #a1adc5;
    font-size: 14px;
    margin-left: 16px;
  }

  .content {
    margin-top: 4px;
    color: #484848;
    font-size: 14px;
    line-height: 22px;
  }

  .actions {
    margin-top: 6px;
  }

  .read-tag {
    color: #94a3b8;
    font-size: 12px;
  }
}

.chat-panel {
  margin-top: 12px;
}

.chat-container {
  display: grid;
  grid-template-columns: 240px 1fr;
  gap: 12px;
  min-height: 500px;
  background: #fff;
  border-radius: 8px;
  overflow: hidden;
}

.sidebar {
  background: #f8fafc;
  border-right: 1px solid #e2e8f0;
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
  background: #fff;
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
  min-height: 300px;
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

@media (max-width: 768px) {
  .chat-container {
    grid-template-columns: 1fr;
  }

  .sidebar {
    display: none;
  }
}
</style>
