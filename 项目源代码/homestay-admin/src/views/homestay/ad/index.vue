<template>
  <div class="app-container">
    <el-form :inline="true" class="mb12">
      <el-form-item label="跳转链接">
        <el-input v-model="queryParams.keyword" placeholder="请输入链接关键字" clearable style="width: 260px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button type="primary" plain icon="Plus" @click="handleAdd" v-hasPermi="['homestay:ad:add']">新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleBatchDelete" v-hasPermi="['homestay:ad:remove']">批量删除</el-button>
      </el-col>
    </el-row>

    <el-table v-loading="loading" :data="rows" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="55" align="center" />
      <el-table-column label="序号" width="80" align="center">
        <template #default="scope">{{ scope.$index + 1 }}</template>
      </el-table-column>
      <el-table-column label="图片" width="180" align="center">
        <template #default="scope">
          <el-image
            v-if="scope.row.image"
            :src="toDisplayImage(scope.row.image)"
            fit="cover"
            style="width: 120px; height: 56px; border-radius: 4px"
            :preview-src-list="[toDisplayImage(scope.row.image)]"
            preview-teleported
          />
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="跳转链接" prop="link" min-width="220" show-overflow-tooltip />
      <el-table-column label="状态" width="110" align="center">
        <template #default="scope">
          <el-tag :type="scope.row.status === '0' ? 'success' : 'info'">
            {{ scope.row.status === '0' ? '启用' : '停用' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="排序" prop="sortOrder" width="90" align="center" />
      <el-table-column label="创建时间" width="170" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="180" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="handleEdit(scope.row)" v-hasPermi="['homestay:ad:edit']">编辑</el-button>
          <el-button link type="danger" @click="handleDelete(scope.row)" v-hasPermi="['homestay:ad:remove']">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <el-dialog v-model="dialogOpen" :title="dialogTitle" width="720px" append-to-body destroy-on-close>
      <el-form ref="formRef" :model="form" :rules="rules" label-width="90px">
        <el-form-item label="轮播图片" prop="image">
          <div class="upload-box">
            <el-upload
              :action="uploadUrl"
              :headers="uploadHeaders"
              :show-file-list="false"
              :on-success="handleUploadSuccess"
              :on-error="handleUploadError"
              accept="image/*"
            >
              <el-button type="primary" plain>上传图片</el-button>
            </el-upload>
            <el-input v-model="form.image" placeholder="或直接填写图片地址" style="margin-top: 8px" />
            <el-image
              v-if="form.image"
              :src="toDisplayImage(form.image)"
              fit="cover"
              style="margin-top: 8px; width: 180px; height: 84px; border-radius: 4px"
            />
          </div>
        </el-form-item>
        <el-form-item label="跳转链接" prop="link">
          <el-input v-model="form.link" placeholder="请输入跳转链接" />
        </el-form-item>
        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="form.status">
            <el-radio value="0">启用</el-radio>
            <el-radio value="1">停用</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="排序" prop="sortOrder">
          <el-input-number v-model="form.sortOrder" :min="0" :max="9999" />
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button type="primary" @click="submitForm">确 定</el-button>
          <el-button @click="dialogOpen = false">取 消</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { computed, getCurrentInstance, onMounted, reactive, ref } from 'vue'
import { parseTime } from '@/utils/ruoyi'
import { getToken } from '@/utils/auth'
import { createAd, deleteAd, listAd, updateAd } from '@/api/homestay/ad'

const { proxy } = getCurrentInstance()
const baseApi = import.meta.env.VITE_APP_BASE_API
const uploadUrl = `${baseApi}/common/upload`
const uploadHeaders = computed(() => ({ Authorization: `Bearer ${getToken()}` }))

const loading = ref(false)
const rows = ref([])
const ids = ref([])
const multiple = ref(true)
const dialogOpen = ref(false)
const dialogTitle = ref('')
const isEdit = ref(false)

const queryParams = reactive({
  keyword: ''
})

const form = reactive({
  id: undefined,
  image: '',
  link: '',
  status: '0',
  sortOrder: 0
})

const rules = {
  image: [{ required: true, message: '请上传或填写轮播图片', trigger: 'blur' }],
  link: [{ required: true, message: '请输入跳转链接', trigger: 'blur' }]
}

const formRef = ref()

function toDisplayImage(image) {
  if (!image) return ''
  if (/^https?:\/\//i.test(image)) return image
  return `${baseApi}${image.startsWith('/') ? '' : '/'}${image}`
}

function formatDateTime(v) {
  if (!v) return '-'
  return parseTime(v, '{y}-{m}-{d} {h}:{i}:{s}')
}

function getList() {
  loading.value = true
  listAd({ keyword: queryParams.keyword }).then((res) => {
    rows.value = res.data || []
  }).finally(() => {
    loading.value = false
  })
}

function handleQuery() {
  getList()
}

function handleReset() {
  queryParams.keyword = ''
  getList()
}

function handleSelectionChange(selection) {
  ids.value = selection.map((item) => item.id)
  multiple.value = ids.value.length === 0
}

function resetForm() {
  form.id = undefined
  form.image = ''
  form.link = ''
  form.status = '0'
  form.sortOrder = 0
  proxy.resetForm('formRef')
}

function handleAdd() {
  resetForm()
  isEdit.value = false
  dialogTitle.value = '新增轮播'
  dialogOpen.value = true
}

function handleEdit(row) {
  resetForm()
  isEdit.value = true
  dialogTitle.value = '编辑轮播'
  form.id = row.id
  form.image = row.image || ''
  form.link = row.link || ''
  form.status = row.status || '0'
  form.sortOrder = Number(row.sortOrder || 0)
  dialogOpen.value = true
}

function handleDelete(row) {
  proxy.$modal.confirm(`确认删除轮播记录「${row.link || row.id}」吗？`).then(() => {
    return deleteAd({ ids: row.id })
  }).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  }).catch(() => {})
}

function handleBatchDelete() {
  if (ids.value.length === 0) return
  proxy.$modal.confirm(`确认删除已选中的 ${ids.value.length} 条轮播记录吗？`).then(() => {
    return deleteAd({ ids: ids.value.join(',') })
  }).then(() => {
    proxy.$modal.msgSuccess('删除成功')
    getList()
  }).catch(() => {})
}

function handleUploadSuccess(response) {
  if (Number(response?.code) !== 200) {
    proxy.$modal.msgError(response?.msg || '图片上传失败')
    return
  }
  form.image = response.url || ''
  proxy.$modal.msgSuccess('图片上传成功')
}

function handleUploadError() {
  proxy.$modal.msgError('图片上传失败')
}

function submitForm() {
  formRef.value.validate((valid) => {
    if (!valid) return
    const payload = {
      id: form.id,
      image: form.image,
      link: form.link,
      status: form.status,
      sortOrder: String(form.sortOrder ?? 0)
    }
    const action = isEdit.value ? updateAd : createAd
    action(payload).then(() => {
      proxy.$modal.msgSuccess(isEdit.value ? '修改成功' : '新增成功')
      dialogOpen.value = false
      getList()
    })
  })
}

onMounted(() => {
  getList()
})
</script>

<style scoped>
.upload-box {
  width: 100%;
}
</style>

