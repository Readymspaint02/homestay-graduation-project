<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="mb12">
      <template #title>清洁任务管理</template>
      <div class="alert-line">标记房源清洁状态，确保房源整洁。</div>
    </el-alert>

    <el-form :model="queryParams" :inline="true" class="mb12">
      <el-form-item label="房源">
        <el-select v-model="queryParams.homestayId" placeholder="请选择房源" clearable style="width: 200px">
          <el-option
            v-for="item in homestayOptions"
            :key="item.id"
            :label="item.title"
            :value="item.id"
          />
        </el-select>
      </el-form-item>
      <el-form-item label="清洁状态">
        <el-select v-model="queryParams.status" placeholder="请选择状态" clearable style="width: 120px">
          <el-option label="待清洁" value="0" />
          <el-option label="已清洁" value="1" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="handleReset">重置</el-button>
        <el-button type="primary" @click="handleAdd">新增任务</el-button>
        <el-button type="warning" @click="handleCallCleaning">叫清洁</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="rows" v-loading="loading">
      <el-table-column label="ID" prop="id" width="70" align="center" />
      <el-table-column label="房源" prop="homestayName" min-width="200" />
      <el-table-column label="清洁日期" prop="cleaningDate" width="120" align="center">
        <template #default="scope">{{ formatDate(scope.row.cleaningDate) }}</template>
      </el-table-column>
      <el-table-column label="状态" prop="status" width="100" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.status === '0' ? 'warning' : 'success'">
            {{ scope.row.status === '0' ? '待清洁' : '已清洁' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="备注" prop="remark" min-width="150" show-overflow-tooltip />
      <el-table-column label="创建时间" prop="createTime" width="170" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="封面照" width="100" align="center">
        <template #default="scope">
          <el-image
            v-if="scope.row.imageUrl"
            :src="resolveImage(scope.row.imageUrl)"
            style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px"
            fit="cover"
          />
          <el-text v-else type="info" size="small">无</el-text>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="220" align="center" fixed="right">
        <template #default="scope">
          <el-button
            v-if="scope.row.status === '0'"
            link
            type="success"
            @click="handleMarkClean(scope.row)"
          >
            标记已清洁
          </el-button>
          <el-button v-else link type="info" disabled>已完成</el-button>
          <el-divider direction="vertical" />
          <el-button
            v-if="scope.row.status === '0'"
            link
            type="primary"
            @click="handleUploadPhoto(scope.row)"
          >
            拍照上传
          </el-button>
          <el-divider v-if="scope.row.status === '0'" direction="vertical" />
          <el-button link type="danger" @click="handleDelete(scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <pagination
      v-show="total > 0"
      :total="total"
      v-model:page="queryParams.pageNum"
      v-model:limit="queryParams.pageSize"
      @pagination="loadData"
    />

    <!-- 新增任务对话框 -->
    <el-dialog v-model="addDialog.visible" title="新增清洁任务" width="500px">
      <el-form ref="addFormRef" :model="addForm" :rules="addRules" label-width="100px">
        <el-form-item label="房源" prop="homestayId">
          <el-select v-model="addForm.homestayId" placeholder="请选择房源" style="width: 100%">
            <el-option
              v-for="item in homestayOptions"
              :key="item.id"
              :label="item.title"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="清洁日期" prop="cleaningDate">
          <el-date-picker
            v-model="addForm.cleaningDate"
            type="date"
            placeholder="选择日期"
            style="width: 100%"
            value-format="YYYY-MM-DD"
          />
        </el-form-item>
        <el-form-item label="备注">
          <el-input v-model="addForm.remark" type="textarea" :rows="3" placeholder="请输入备注" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="addDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="submitAdd">确定</el-button>
      </template>
    </el-dialog>

    <!-- 拍照上传弹窗 -->
    <el-dialog v-model="photoDialog.visible" title="拍照上传" width="420px">
      <el-form>
        <el-form-item label="清洁任务">
          <el-tag>{{ photoDialog.taskId }}</el-tag>
        </el-form-item>
        <el-form-item label="上传照片">
          <el-upload
            :action="uploadUrl"
            :headers="uploadHeaders"
            :on-success="handlePhotoSuccess"
            :show-file-list="false"
            accept="image/*"
          >
            <el-button type="primary">选择照片</el-button>
          </el-upload>
        </el-form-item>
        <el-form-item v-if="photoDialog.imageUrl" label="预览">
          <el-image
            :src="resolveImage(photoDialog.imageUrl)"
            style="max-width: 100%; max-height: 200px; border-radius: 4px"
            fit="contain"
            :preview-src-list="[resolveImage(photoDialog.imageUrl)]"
            preview-teleported
          />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="photoDialog.visible = false">取消</el-button>
        <el-button
          type="success"
          :disabled="!photoDialog.imageUrl"
          @click="submitPhoto"
        >
          确认上传并标记清洁
        </el-button>
      </template>
    </el-dialog>

    <!-- 叫清洁弹窗 -->
    <el-dialog v-model="callCleaningDialog.visible" title="叫清洁" width="420px">
      <el-form>
        <el-form-item label="选择房源">
          <el-select v-model="callCleaningDialog.homestayId" placeholder="请选择房源" style="width: 100%" @change="(val) => { const h = homestayOptions.find(x => x.id === val); callCleaningDialog.homestayName = h?.title || '' }">
            <el-option
              v-for="item in homestayOptions"
              :key="item.id"
              :label="item.title"
              :value="item.id"
            />
          </el-select>
        </el-form-item>
        <el-alert type="info" :closable="false" style="margin-top: 12px">
          点击确定后将语音提醒阿姨前往清洁
        </el-alert>
      </el-form>
      <template #footer>
        <el-button @click="callCleaningDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="submitCallCleaning">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="CleaningTask">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus'
import request from '@/utils/request'
import { getToken } from '@/utils/auth'

const loading = ref(false)
const rows = ref([])
const total = ref(0)
const homestayOptions = ref([])

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  homestayId: '',
  status: ''
})

const addDialog = reactive({ visible: false })
const addForm = reactive({
  homestayId: '',
  cleaningDate: '',
  remark: ''
})
const addFormRef = ref(null)

const uploadUrl = import.meta.env.VITE_APP_BASE_API + '/api/homestay/image/upload'
const uploadHeaders = { Authorization: 'Bearer ' + getToken() }
const photoDialog = reactive({
  visible: false,
  taskId: null,
  imageUrl: ''
})

const callCleaningDialog = reactive({
  visible: false,
  homestayId: '',
  homestayName: ''
})

const speakNotification = (text) => {
  if ('speechSynthesis' in window) {
    const utterance = new SpeechSynthesisUtterance(text)
    utterance.lang = 'zh-CN'
    utterance.rate = 1
    utterance.volume = 1
    speechSynthesis.speak(utterance)
  }
}

const playNotificationSound = () => {
  try {
    const audioContext = new (window.AudioContext || window.webkitAudioContext)()
    const oscillator = audioContext.createOscillator()
    const gainNode = audioContext.createGain()
    oscillator.connect(gainNode)
    gainNode.connect(audioContext.destination)
    oscillator.frequency.value = 600
    oscillator.type = 'sine'
    gainNode.gain.setValueAtTime(0.3, audioContext.currentTime)
    gainNode.gain.exponentialRampToValueAtTime(0.01, audioContext.currentTime + 0.5)
    oscillator.start(audioContext.currentTime)
    oscillator.stop(audioContext.currentTime + 0.5)
  } catch (e) {
    console.log('Audio not supported')
  }
}

const resolveImage = (url) => {
  if (!url) return ''
  if (url.startsWith('http://') || url.startsWith('https://')) return url
  if (url.startsWith('/profile/')) return import.meta.env.VITE_APP_BASE_API + url
  if (url.startsWith('/')) return import.meta.env.VITE_APP_BASE_API + url
  return url
}
const addRules = {
  homestayId: [{ required: true, message: '请选择房源', trigger: 'change' }],
  cleaningDate: [{ required: true, message: '请选择清洁日期', trigger: 'change' }]
}

const formatDate = (date) => {
  if (!date) return '--'
  return new Date(date).toLocaleDateString('zh-CN')
}

const formatDateTime = (date) => {
  if (!date) return '--'
  return new Date(date).toLocaleString('zh-CN')
}

const loadHomestays = async () => {
  try {
    const res = await request({
      url: '/api/homestay/landlord/list',
      method: 'get',
      params: { pageNum: 1, pageSize: 100 }
    })
    if (res.code === 200) {
      homestayOptions.value = res.rows || []
    }
  } catch (error) {
    homestayOptions.value = []
  }
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/api/cleaning/list',
      method: 'get',
      params: queryParams
    })
    if (res.code === 200) {
      rows.value = res.data || []
      total.value = rows.value.length
    }
  } catch (error) {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  loadData()
}

const handleReset = () => {
  queryParams.homestayId = ''
  queryParams.status = ''
  loadData()
}

const handleAdd = () => {
  addForm.homestayId = ''
  addForm.cleaningDate = ''
  addForm.remark = ''
  addDialog.visible = true
}

const submitAdd = async () => {
  if (!addFormRef.value) return
  await addFormRef.value.validate(async (valid) => {
    if (valid) {
      try {
        await request({
          url: '/api/cleaning/create',
          method: 'post',
          data: {
            homestayId: addForm.homestayId,
            cleaningDate: addForm.cleaningDate,
            remark: addForm.remark
          }
        })
        ElMessage.success('创建成功')
        addDialog.visible = false
        loadData()
      } catch (error) {
        ElMessage.error('创建失败')
      }
    }
  })
}

const handleMarkClean = async (row) => {
  try {
    await request({
      url: '/api/cleaning/mark',
      method: 'post',
      params: { taskId: row.id, status: '1' }
    })
    ElMessage.success('标记成功')
    loadData()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleDelete = async (row) => {
  try {
    await ElMessageBox.confirm(`确定要删除该清洁任务吗？`, '确认删除')
    await request({
      url: `/api/cleaning/delete/${row.id}`,
      method: 'post'
    })
    ElMessage.success('删除成功')
    loadData()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const handleUploadPhoto = (row) => {
  photoDialog.taskId = row.id
  photoDialog.imageUrl = ''
  photoDialog.visible = true
}

const handlePhotoSuccess = (response) => {
  if (response.code === 200) {
    const url = response.data?.imageUrl || response.data?.url || response.url
    photoDialog.imageUrl = url
    ElMessage.success('照片上传成功')
  } else {
    ElMessage.error(response.msg || '照片上传失败')
  }
}

const submitPhoto = async () => {
  try {
    await request({
      url: '/api/cleaning/mark',
      method: 'post',
      params: { taskId: photoDialog.taskId, status: '1', imageUrl: photoDialog.imageUrl }
    })
    ElMessage.success('清洁任务已完成，照片已保存')
    photoDialog.visible = false
    loadData()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const handleCallCleaning = () => {
  callCleaningDialog.homestayId = ''
  callCleaningDialog.homestayName = ''
  callCleaningDialog.visible = true
}

const submitCallCleaning = async () => {
  if (!callCleaningDialog.homestayId) {
    ElMessage.warning('请选择房源')
    return
  }
  playNotificationSound()
  speakNotification(`阿姨请注意，${callCleaningDialog.homestayName}需要清洁，请尽快前往处理`)
  ElNotification({
    title: '叫清洁通知',
    message: `已通知阿姨前往${callCleaningDialog.homestayName}进行清洁`,
    type: 'success',
    duration: 5000
  })
  try {
    await request({
      url: '/api/cleaning/create',
      method: 'post',
      data: {
        homestayId: callCleaningDialog.homestayId,
        cleaningDate: new Date().toISOString().split('T')[0],
        remark: '房东叫清洁'
      }
    })
    callCleaningDialog.visible = false
    loadData()
  } catch (error) {
    ElMessage.error('创建清洁任务失败')
  }
}

onMounted(() => {
  loadHomestays()
  loadData()
})
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
</style>
