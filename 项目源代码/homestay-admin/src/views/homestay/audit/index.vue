<template>
  <div class="app-container">
    <el-alert type="info" :closable="false" class="mb12">
      <template #title>房源审核说明</template>
      <div class="alert-line">审核通过的房源才能上架销售；拒绝时需要填写拒绝原因。</div>
    </el-alert>

    <el-form :model="queryParams" :inline="true" class="mb12">
      <el-form-item label="房源标题">
        <el-input v-model="queryParams.title" placeholder="请输入标题" clearable style="width: 200px" @keyup.enter="handleQuery" />
      </el-form-item>
      <el-form-item label="审核状态">
        <el-select v-model="queryParams.auditStatus" clearable style="width: 130px">
          <el-option label="待审核" value="0" />
          <el-option label="已通过" value="1" />
          <el-option label="已拒绝" value="2" />
        </el-select>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" icon="Search" @click="handleQuery">查询</el-button>
        <el-button icon="Refresh" @click="handleReset">重置</el-button>
      </el-form-item>
    </el-form>

    <el-table :data="rows" v-loading="loading">
      <el-table-column label="ID" prop="id" width="70" align="center" />
      <el-table-column label="封面" width="100" align="center">
        <template #default="scope">
          <el-image 
            v-if="scope.row.coverImage" 
            :src="scope.row.coverImage" 
            :preview-src-list="[scope.row.coverImage]"
            style="width: 60px; height: 60px;"
            fit="cover"
          />
          <span v-else>-</span>
        </template>
      </el-table-column>
      <el-table-column label="房源编号" prop="homestayNo" width="160" />
      <el-table-column label="标题" prop="title" min-width="200" show-overflow-tooltip />
      <el-table-column label="城市" prop="city" width="100" />
      <el-table-column label="价格" prop="basePrice" width="90" align="center" />
      <el-table-column label="可住人数" prop="maxGuests" width="90" align="center" />
      <el-table-column label="房东" prop="landlordName" width="120" />
      <el-table-column label="审核状态" width="100" align="center">
        <template #default="scope">
          <el-tag :type="auditTagType(scope.row.auditStatus)">{{ auditText(scope.row.auditStatus) }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="创建时间" width="170" align="center">
        <template #default="scope">{{ formatDateTime(scope.row.createTime) }}</template>
      </el-table-column>
      <el-table-column label="操作" width="200" align="center" fixed="right">
        <template #default="scope">
          <el-button link type="primary" @click="handleView(scope.row)">详情</el-button>
          <template v-if="scope.row.auditStatus === '0'">
            <el-divider direction="vertical" />
            <el-button link type="success" @click="handleAudit(scope.row, '1', '')">通过</el-button>
            <el-divider direction="vertical" />
            <el-button link type="danger" @click="handleAudit(scope.row, '2', '')">拒绝</el-button>
          </template>
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

    <el-dialog v-model="viewDialog.visible" title="房源详情" width="800px">
      <el-descriptions :column="2" border>
        <el-descriptions-item label="房源编号">{{ viewData.homestayNo }}</el-descriptions-item>
        <el-descriptions-item label="标题">{{ viewData.title }}</el-descriptions-item>
        <el-descriptions-item label="城市">{{ viewData.city }} {{ viewData.district }}</el-descriptions-item>
        <el-descriptions-item label="地址">{{ viewData.address }}</el-descriptions-item>
        <el-descriptions-item label="房型">{{ viewData.roomType || '-' }}</el-descriptions-item>
        <el-descriptions-item label="可住人数">{{ viewData.maxGuests }}人</el-descriptions-item>
<el-descriptions-item label="平日价"> {{ viewData.basePrice }}</el-descriptions-item>

        <el-descriptions-item label="周末价"> {{ viewData.weekendPrice || '-' }}</el-descriptions-item>

        <el-descriptions-item label="清洁费"> {{ viewData.cleaningFee || '-' }}</el-descriptions-item>

        <el-descriptions-item label="押金"> {{ viewData.deposit || '-' }}</el-descriptions-item>
        <el-descriptions-item label="审核状态">
          <el-tag :type="auditTagType(viewData.auditStatus)">{{ auditText(viewData.auditStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="发布状态">
          <el-tag :type="publishTagType(viewData.publishStatus)">{{ publishText(viewData.publishStatus) }}</el-tag>
        </el-descriptions-item>
        <el-descriptions-item label="描述" :span="2">{{ viewData.description || '-' }}</el-descriptions-item>
      </el-descriptions>
      <template #footer>
        <el-button @click="viewDialog.visible = false">关闭</el-button>
      </template>
    </el-dialog>

    <el-dialog v-model="auditDialog.visible" :title="auditDialog.type === '1' ? '通过审核' : '拒绝审核'" width="500px">
      <el-form :model="auditForm" label-width="80px">
        <el-form-item label="审核结果">
          <el-tag :type="auditDialog.type === '1' ? 'success' : 'danger'">
            {{ auditDialog.type === '1' ? '通过' : '拒绝' }}
          </el-tag>
        </el-form-item>
        <el-form-item label="备注原因" v-if="auditDialog.type === '2'">
          <el-input v-model="auditForm.remark" type="textarea" :rows="4" placeholder="请输入拒绝原因" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="auditDialog.visible = false">取消</el-button>
        <el-button type="primary" @click="submitAudit">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup name="HomestayAudit">
import { ref, reactive, onMounted } from 'vue'
import { ElMessage } from 'element-plus'
import request from '@/utils/request'

const loading = ref(false)
const rows = ref([])
const total = ref(0)

const queryParams = reactive({
  pageNum: 1,
  pageSize: 10,
  title: '',
  auditStatus: '0'  // 默认显示待审核
})

const viewDialog = reactive({ visible: false })
const viewData = ref({})

const auditDialog = reactive({ visible: false, type: '' })
const auditForm = reactive({ id: '', auditStatus: '', remark: '' })

const auditTagType = (status) => {
  const map = { '0': 'warning', '1': 'success', '2': 'danger' }
  return map[status] || 'info'
}

const auditText = (status) => {
  const map = { '0': '待审核', '1': '已通过', '2': '已拒绝' }
  return map[status] || status
}

const publishTagType = (status) => {
  const map = { '0': 'info', '1': 'success', '2': 'info' }
  return map[status] || 'info'
}

const publishText = (status) => {
  const map = { '0': '草稿', '1': '已上架', '2': '已下架' }
  return map[status] || status
}

const formatDateTime = (date) => {
  if (!date) return '--'
  return new Date(date).toLocaleString('zh-CN')
}

const loadData = async () => {
  loading.value = true
  try {
    const res = await request({
      url: '/api/homestay/admin/list',
      method: 'get',
      params: queryParams
    })
    if (res.code === 200) {
      rows.value = res.rows || []
      total.value = res.total || 0
    }
  } catch (error) {
    ElMessage.error('加载失败')
  } finally {
    loading.value = false
  }
}

const handleQuery = () => {
  queryParams.pageNum = 1
  loadData()
}

const handleReset = () => {
  queryParams.title = ''
  queryParams.auditStatus = ''
  handleQuery()
}

const handleView = (row) => {
  viewData.value = { ...row }
  viewDialog.visible = true
}

const handleAudit = (row, type, remark) => {
  auditForm.id = row.id
  auditForm.auditStatus = type
  auditForm.remark = remark || ''
  auditDialog.type = type
  auditDialog.visible = true
}

const submitAudit = async () => {
  try {
    await request({
      url: '/api/homestay/audit',
      method: 'post',
      data: {
        id: auditForm.id,
        auditStatus: auditForm.auditStatus,
        remark: auditForm.remark,
        publishStatus: auditForm.auditStatus === '1' ? '1' : '2'
      }
    })
    ElMessage.success(auditDialog.type === '1' ? '审核通过' : '审核拒绝')
    auditDialog.visible = false
    loadData()
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
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
