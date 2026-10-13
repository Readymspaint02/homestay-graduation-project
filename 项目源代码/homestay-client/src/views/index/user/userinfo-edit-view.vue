<template>
  <div class="content-list">
    <div class="list-title">个人中心</div>
    <a-spin :spinning="loading" style="min-height: 200px;">
      <div class="list-content">
      <div class="edit-view">
        <div class="section-title">基本资料</div>
        <div class="item flex-view">
          <div class="label">头像</div>
          <div class="right-box avatar-box flex-view">
            <img v-if="tData.form && tData.form.avatar" :src="tData.form.avatar" class="avatar">
            <img v-else :src="AvatarIcon" class="avatar">
            <div class="change-tips flex-view">
                <a-upload
                  :action="qiniuUploadUrl"
                  :data="qiniuUploadData"
                  accept="image/*"
                  :multiple="false"
                  :before-upload="beforeQiniuUpload"
                  @change="handleQiniuUploadChange"
                  :show-upload-list="false"
                >
                  <label>点击更换头像</label>
                </a-upload>
              <p class="tip">图片格式支持 GIF、PNG、JPEG，尺寸不小于 200 PX，小于 4 MB</p>
            </div>
          </div>
        </div>
        <div class="item flex-view">
          <div class="label">昵称</div>
          <div class="right-box">
            <input type="text" v-model="tData.form.nickname" placeholder="请输入昵称" maxlength="20" class="input-dom">
            <p class="tip">支持中英文，长度不能超过 20 个字符</p>
          </div>
        </div>
        <div class="item flex-view">
          <div class="label">手机号</div>
          <div class="right-box">
            <input type="text" v-model="tData.form.mobile" placeholder="请输入手机号" maxlength="100" class="input-dom web-input">
          </div>
        </div>
        <div class="item flex-view">
          <div class="label">邮箱</div>
          <div class="right-box">
            <input type="text" v-model="tData.form.email" placeholder="请输入邮箱" maxlength="100" class="input-dom web-input">
          </div>
        </div>
        <div class="item flex-view">
          <div class="label">个人简介</div>
          <div class="right-box">
          <textarea v-model="tData.form.description" placeholder="请输入简介" maxlength="200" class="intro">
          </textarea>
            <p class="tip">限制200字以内</p>
          </div>
        </div>
        <button class="save mg" @click="submit()">保存</button>

        <div class="section-title" style="margin-top: 40px;">修改密码</div>
        <div v-if="!showPwdForm">
          <button class="save mg" @click="showPwdForm = true">修改密码</button>
        </div>
        <div v-else>
          <div class="item flex-view">
            <div class="label">原密码</div>
            <div class="right-box">
              <input type="password" v-model="tData.pwdForm.oldPassword" placeholder="请输入原密码" class="input-dom">
            </div>
          </div>
          <div class="item flex-view">
            <div class="label">新密码</div>
            <div class="right-box">
              <input type="password" v-model="tData.pwdForm.newPassword" placeholder="请输入新密码" class="input-dom">
            </div>
          </div>
          <div class="item flex-view">
            <div class="label">确认密码</div>
            <div class="right-box">
              <input type="password" v-model="tData.pwdForm.confirmPassword" placeholder="请再次输入新密码" class="input-dom">
            </div>
          </div>
          <div class="pwd-btns">
            <button class="save mg" @click="submitPwd()">确认修改</button>
            <button class="cancel-btn" @click="cancelPwdEdit()">取消</button>
          </div>
        </div>
      </div>
    </div>
    </a-spin>
  </div>
</template>

<script setup>
import {message} from "ant-design-vue";
import {detailApi, updateUserInfoApi, updateUserPwdApi} from '/@/api/user'
import {BASE_URL, USER_NAME, USER_TOKEN} from "/@/store/constants";
import {useUserStore} from "/@/store";
import {get} from '/@/utils/http/axios';
import AvatarIcon from '/@/assets/images/avatar.jpg'

const router = useRouter();
const userStore = useUserStore();

let loading = ref(false)
let showPwdForm = ref(false)
let qiniuUploadUrl = ref('https://upload.qiniup.com')
let qiniuUploadData = ref({ token: '', key: '' })
let qiniuDomain = ref('')
let tData = reactive({
  form:{
    avatar: undefined,
    avatarFile: undefined,
    nickname: undefined,
    email: undefined,
    mobile: undefined,
    description: undefined,
  },
  pwdForm: {
    oldPassword: '',
    newPassword: '',
    confirmPassword: '',
  }
})

const PHONE_REG = /^1\d{10}$/
const EMAIL_REG = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/

onMounted(()=>{
  getUserInfo()
  loadQiniuToken()
})

const loadQiniuToken = async () => {
  try {
    const res = await get({ url: '/api/homestay/image/qiniu/token', params: {} })
    if (res && res.data) {
      qiniuUploadData.value.token = res.data.token
      qiniuDomain.value = res.data.domain
      if (res.data.uploadUrl) {
        qiniuUploadUrl.value = res.data.uploadUrl
      }
    }
  } catch (e) {
    console.error('获取七牛云token失败', e)
  }
}

const beforeQiniuUpload = async (file) => {
  const isImage = file.type.startsWith('image/')
  if (!isImage) {
    message.error('只能上传图片文件')
    return false
  }
  const isLt4M = file.size / 1024 / 1024 < 4
  if (!isLt4M) {
    message.error('图片大小不能超过4MB')
    return false
  }
  if (!qiniuUploadData.value.token) {
    await loadQiniuToken()
  }
  const key = `avatar/${Date.now()}_${Math.random().toString(36).substr(2, 9)}.${file.name.split('.').pop()}`
  qiniuUploadData.value.key = key
  return true
}

const handleQiniuUploadChange = (info) => {
  if (info.file.status === 'done' && info.file.response) {
    if (info.file.response && info.file.response.key) {
      const domain = qiniuDomain.value || 'https://js.ccnccn.cn/'
      const url = domain + info.file.response.key
      tData.form.avatar = url
      tData.form.avatarFile = undefined
      message.success('头像上传成功')
    } else {
      message.error('上传失败')
    }
  } else if (info.file.status === 'error') {
    message.error('上传失败，请重试')
  }
}

const getUserInfo =(fallbackForm = {})=> {
  loading.value = true
  detailApi({}).then(res => {
    const nextData = res?.data || {}
    tData.form = {
      avatar: nextData.avatar || fallbackForm.avatar || undefined,
      avatarFile: undefined,
      nickname: nextData.nickname || fallbackForm.nickname || '',
      email: nextData.email || fallbackForm.email || '',
      mobile: nextData.mobile || fallbackForm.mobile || '',
      description: nextData.description || fallbackForm.description || '',
    }
    const rawAvatar = String(tData.form.avatar || '').trim()
    if (rawAvatar) {
      if (rawAvatar.startsWith('http://') || rawAvatar.startsWith('https://')) {
        tData.form.avatar = rawAvatar.replace(/^http:/, 'https:')
      } else if (rawAvatar.startsWith('/profile/')) {
        tData.form.avatar = `${BASE_URL}${rawAvatar}`
      } else if (rawAvatar.startsWith('/')) {
        tData.form.avatar = `${BASE_URL}${rawAvatar}`
      } else if (rawAvatar.includes('/') || rawAvatar.includes('.')) {
        tData.form.avatar = rawAvatar
      } else {
        tData.form.avatar = `${BASE_URL}/profile/${rawAvatar}`
      }
    }
    loading.value = false
  }).catch(err => {
    console.log(err)
    if (fallbackForm && Object.keys(fallbackForm).length > 0) {
      tData.form = {
        ...tData.form,
        ...fallbackForm,
        avatarFile: undefined
      }
    }
    loading.value = false
  })
}
const submit =()=> {
  const nickname = String(tData.form.nickname || '').trim()
  const mobile = String(tData.form.mobile || '').trim()
  const email = String(tData.form.email || '').trim()
  const description = String(tData.form.description || '').trim()
  const avatar = String(tData.form.avatar || '').trim()

  if (mobile && !PHONE_REG.test(mobile)) {
    message.warning('请输入正确的11位手机号')
    return
  }
  if (email && !EMAIL_REG.test(email)) {
    message.warning('请输入正确的邮箱格式')
    return
  }

  let formData = new FormData()
  formData.append('nickname', nickname)
  formData.append('email', email)
  formData.append('mobile', mobile)
  formData.append('description', description)
  formData.append('avatar', avatar)
  updateUserInfoApi(formData).then(res => {
    tData.form = {
      ...tData.form,
      nickname,
      email,
      mobile,
      description,
      avatarFile: undefined,
    }
    const latestName = String(tData.form.nickname || '').trim()
    if (latestName) {
      userStore.user_name = latestName
      localStorage.setItem(USER_NAME, latestName)
    }
    message.success('保存成功')
    window.dispatchEvent(new CustomEvent('profile-updated', {
      detail: {
        avatar: tData.form.avatar,
        nickname: tData.form.nickname,
      },
    }))
    getUserInfo({...tData.form})
  }).catch(err => {
    console.log(err)
    message.error(err?.msg || '保存失败')
  })
}

const cancelPwdEdit = () => {
  showPwdForm.value = false
  tData.pwdForm.oldPassword = ''
  tData.pwdForm.newPassword = ''
  tData.pwdForm.confirmPassword = ''
}

const submitPwd = async () => {
  const oldPassword = String(tData.pwdForm.oldPassword || '').trim()
  const newPassword = String(tData.pwdForm.newPassword || '').trim()
  const confirmPassword = String(tData.pwdForm.confirmPassword || '').trim()

  if (!oldPassword || !newPassword) {
    message.warning('请填写原密码和新密码')
    return
  }
  if (newPassword.length < 6) {
    message.warning('新密码长度不能少于6位')
    return
  }
  if (newPassword !== confirmPassword) {
    message.warning('两次输入的新密码不一致')
    return
  }

  try {
    const res = await updateUserPwdApi({ oldPassword, newPassword })
    if (res.code === 200) {
      message.success('密码修改成功，请重新登录')
      userStore.logout()
      localStorage.removeItem(USER_TOKEN)
      localStorage.removeItem(USER_NAME)
      router.push({ name: 'login' })
    } else {
      message.warning(res.msg || '修改失败')
    }
  } catch (err) {
    message.error(err?.msg || '密码修改失败')
  }
}
</script>

<style scoped lang="less">
input, textarea {
  border-style: none;
  outline: none;
  margin: 0;
  padding: 0;
}

.flex-view {
  display: -webkit-box;
  display: -ms-flexbox;
  display: flex;
}

.content-list {
  -webkit-box-flex: 1;
  -ms-flex: 1;
  flex: 1;

  .list-title {
    color: #152844;
    font-weight: 600;
    font-size: 18px;
    line-height: 48px;
    height: 48px;
    margin-bottom: 4px;
    border-bottom: 1px solid #cedce4;
  }

  .edit-view {
    .item {
      -webkit-box-align: center;
      -ms-flex-align: center;
      align-items: center;
      margin: 24px 0;

      .label {
        width: 100px;
        color: #152844;
        font-weight: 600;
        font-size: 14px;
      }

      .right-box {
        -webkit-box-flex: 1;
        -ms-flex: 1;
        flex: 1;
      }

      .avatar {
        width: 64px;
        height: 64px;
        border-radius: 50%;
        margin-right: 16px;
      }

      .change-tips {
        -webkit-box-align: center;
        -ms-flex-align: center;
        align-items: center;
        -ms-flex-wrap: wrap;
        flex-wrap: wrap;
      }

      label {
        color: #4684e2;
        font-size: 14px;
        line-height: 22px;
        height: 22px;
        cursor: pointer;
        width: 100px;
        display: block;
      }

      .tip {
        color: #6f6f6f;
        font-size: 14px;
        height: 22px;
        line-height: 22px;
        margin: 0;
        width: 100%;
      }

      .right-box {
        -webkit-box-flex: 1;
        -ms-flex: 1;
        flex: 1;
      }

      .input-dom {
        width: 400px;
      }

      .input-dom {
        background: #f8fafb;
        border-radius: 4px;
        height: 40px;
        line-height: 40px;
        font-size: 14px;
        color: #152844;
        padding: 0 12px;
      }

      .tip {
        font-size: 12px;
        line-height: 16px;
        color: #6f6f6f;
        height: 16px;
        margin-top: 4px;
      }

      .intro {
        resize: none;
        background: #f8fafb;
        width: 100%;
        padding: 8px 12px;
        height: 82px;
        line-height: 22px;
        font-size: 14px;
        color: #152844;
      }
    }

    .save {
      background: #4684e2;
      border-radius: 32px;
      width: 96px;
      height: 32px;
      line-height: 32px;
      font-size: 14px;
      color: #fff;
      border: none;
      outline: none;
      cursor: pointer;
    }

    .cancel-btn {
      background: #f5f5f5;
      border-radius: 32px;
      width: 96px;
      height: 32px;
      line-height: 32px;
      font-size: 14px;
      color: #666;
      border: none;
      outline: none;
      cursor: pointer;
      margin-left: 16px;
    }

    .mg {
      margin-left: 100px;
    }

    .pwd-btns {
      display: flex;
      align-items: center;
      margin-left: 100px;
    }
  }
}

</style>
