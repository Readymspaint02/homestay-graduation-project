# RegionCascader 省市区级联选择器组件

一个基于 Element Plus 的省市区三级级联选择器组件，支持懒加载和动态数据获取。

## 📋 功能特性

- ✅ **三级联动**：支持省-市-区三级选择
- ✅ **层级控制**：支持通过 level 属性控制显示层级（1-3级）
- ✅ **懒加载**：按需加载数据，提高性能
- ✅ **双向绑定**：支持 v-model 双向数据绑定
- ✅ **可配置**：支持多种配置选项
- ✅ **全局注册**：已全局注册，无需重复导入
- ✅ **响应式**：支持不同尺寸和样式
- ✅ **错误处理**：包含完整的错误处理机制

## 🚀 快速开始

### 基础用法

```vue
<template>
  <div>
    <RegionCascader v-model="selectedRegion" />
  </div>
</template>

<script setup>
import { ref } from 'vue'

const selectedRegion = ref([])
</script>
```

### 带占位符

```vue
<template>
  <RegionCascader
    v-model="selectedRegion"
    placeholder="请选择省市区"
  />
</template>

<script setup>
import { ref } from 'vue'

const selectedRegion = ref([])
</script>
```

## 📖 完整示例

### 1. 表单中使用

```vue
<template>
  <el-form :model="form" :rules="rules" ref="formRef" label-width="100px">
    <el-form-item label="项目名称" prop="projectName">
      <el-input v-model="form.projectName" placeholder="请输入项目名称" />
    </el-form-item>
    
    <el-form-item label="所在区域" prop="region">
      <RegionCascader
        v-model="form.region"
        placeholder="请选择省市区"
        :show-district="true"
      />
    </el-form-item>
    
    <el-form-item>
      <el-button type="primary" @click="submitForm">提交</el-button>
      <el-button @click="resetForm">重置</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { ref, reactive } from 'vue'

const formRef = ref()
const form = reactive({
  projectName: '',
  region: []
})

const rules = {
  projectName: [
    { required: true, message: '请输入项目名称', trigger: 'blur' }
  ],
  region: [
    { required: true, message: '请选择区域', trigger: 'change' }
  ]
}

const submitForm = () => {
  formRef.value.validate((valid) => {
    if (valid) {
      console.log('提交数据:', form)
    }
  })
}

const resetForm = () => {
  formRef.value.resetFields()
}
</script>
```

### 2. 搜索表单中使用

```vue
<template>
  <el-form :model="queryParams" ref="queryForm" :inline="true">
    <el-form-item label="项目名称" prop="projectName">
      <el-input
        v-model="queryParams.projectName"
        placeholder="请输入项目名称"
        clearable
        @keyup.enter="handleQuery"
      />
    </el-form-item>
    
    <el-form-item label="区域" prop="region">
      <RegionCascader
        v-model="queryParams.region"
        placeholder="请选择省市区"
        clearable
      />
    </el-form-item>
    
    <el-form-item>
      <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
      <el-button icon="Refresh" @click="resetQuery">重置</el-button>
    </el-form-item>
  </el-form>
</template>

<script setup>
import { ref, reactive } from 'vue'

const queryForm = ref()
const queryParams = reactive({
  projectName: '',
  region: []
})

const handleQuery = () => {
  console.log('搜索参数:', queryParams)
  // 执行搜索逻辑
}

const resetQuery = () => {
  queryForm.value.resetFields()
  handleQuery()
}
</script>
```

### 3. 不同尺寸示例

```vue
<template>
  <div class="demo-container">
    <h3>不同尺寸示例</h3>
    
    <div class="demo-item">
      <label>大尺寸 (large):</label>
      <RegionCascader
        v-model="region1"
        size="large"
        placeholder="大尺寸选择器"
        style="width: 300px"
      />
    </div>
    
    <div class="demo-item">
      <label>默认尺寸 (default):</label>
      <RegionCascader
        v-model="region2"
        size="default"
        placeholder="默认尺寸选择器"
        style="width: 250px"
      />
    </div>
    
    <div class="demo-item">
      <label>小尺寸 (small):</label>
      <RegionCascader
        v-model="region3"
        size="small"
        placeholder="小尺寸选择器"
        style="width: 200px"
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const region1 = ref([])
const region2 = ref([])
const region3 = ref([])
</script>

<style scoped>
.demo-container {
  padding: 20px;
}

.demo-item {
  margin-bottom: 20px;
}

.demo-item label {
  display: inline-block;
  width: 150px;
  font-weight: bold;
}
</style>
```

### 4. 禁用状态示例

```vue
<template>
  <div class="demo-container">
    <h3>禁用状态示例</h3>
    
    <div class="demo-item">
      <label>正常状态:</label>
      <RegionCascader
        v-model="region1"
        placeholder="请选择省市区"
      />
    </div>
    
    <div class="demo-item">
      <label>禁用状态:</label>
      <RegionCascader
        v-model="region2"
        :disabled="true"
        placeholder="禁用状态"
      />
    </div>
    
    <div class="demo-item">
      <label>动态禁用:</label>
      <RegionCascader
        v-model="region3"
        :disabled="isDisabled"
        placeholder="动态禁用状态"
      />
      <el-button @click="toggleDisabled" style="margin-left: 10px">
        {{ isDisabled ? '启用' : '禁用' }}
      </el-button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const region1 = ref([])
const region2 = ref([])
const region3 = ref([])
const isDisabled = ref(false)

const toggleDisabled = () => {
  isDisabled.value = !isDisabled.value
}
</script>
```

### 5. 事件处理示例

```vue
<template>
  <div class="demo-container">
    <h3>事件处理示例</h3>
    
    <RegionCascader
      v-model="selectedRegion"
      placeholder="请选择省市区"
      @change="handleRegionChange"
    />
    
    <div class="result">
      <h4>选择结果:</h4>
      <p>选中的值: {{ selectedRegion }}</p>
      <p>选中的文本: {{ selectedRegionText }}</p>
      <p>最后选择时间: {{ lastSelectTime }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const selectedRegion = ref([])
const selectedRegionText = ref('')
const lastSelectTime = ref('')

const handleRegionChange = (value) => {
  console.log('区域选择变化:', value)
  selectedRegionText.value = value.length > 0 ? `已选择 ${value.length} 级区域` : '未选择'
  lastSelectTime.value = new Date().toLocaleString()
}
</script>

<style scoped>
.result {
  margin-top: 20px;
  padding: 15px;
  background-color: #f5f5f5;
  border-radius: 4px;
}

.result p {
  margin: 5px 0;
}
</style>
```

### 6. 层级控制示例

```vue
<template>
  <div class="demo-container">
    <h3>层级控制示例</h3>
    
    <div class="demo-item">
      <label>只显示省份 (level=1):</label>
      <RegionCascader
        v-model="region1"
        :level="1"
        placeholder="请选择省份"
      />
      <p class="result">选中的值: {{ region1 }}</p>
    </div>
    
    <div class="demo-item">
      <label>显示省市 (level=2):</label>
      <RegionCascader
        v-model="region2"
        :level="2"
        placeholder="请选择省市"
      />
      <p class="result">选中的值: {{ region2 }}</p>
    </div>
    
    <div class="demo-item">
      <label>显示省市区 (level=3):</label>
      <RegionCascader
        v-model="region3"
        :level="3"
        placeholder="请选择省市区"
      />
      <p class="result">选中的值: {{ region3 }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const region1 = ref([])
const region2 = ref([])
const region3 = ref([])
</script>

<style scoped>
.demo-item {
  margin-bottom: 20px;
}

.demo-item label {
  display: inline-block;
  width: 200px;
  font-weight: bold;
}

.result {
  margin-top: 5px;
  color: #666;
  font-size: 14px;
}
</style>
```

### 7. 只显示省市（兼容旧版本）

```vue
<template>
  <div class="demo-container">
    <h3>只显示省市示例（兼容旧版本）</h3>
    
    <RegionCascader
      v-model="selectedRegion"
      placeholder="请选择省市"
      :show-district="false"
    />
    
    <div class="result">
      <p>选中的值: {{ selectedRegion }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const selectedRegion = ref([])
</script>
```

### 8. 自定义宽度

```vue
<template>
  <div class="demo-container">
    <h3>自定义宽度示例</h3>
    
    <div class="demo-item">
      <label>固定宽度:</label>
      <RegionCascader
        v-model="region1"
        width="300px"
        placeholder="300px 宽度"
      />
    </div>
    
    <div class="demo-item">
      <label>百分比宽度:</label>
      <RegionCascader
        v-model="region2"
        width="50%"
        placeholder="50% 宽度"
      />
    </div>
    
    <div class="demo-item">
      <label>100% 宽度:</label>
      <RegionCascader
        v-model="region3"
        width="100%"
        placeholder="100% 宽度"
      />
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const region1 = ref([])
const region2 = ref([])
const region3 = ref([])
</script>
```

## 🔧 API 文档

### Props

| 参数 | 说明 | 类型 | 可选值 | 默认值 |
|------|------|------|--------|--------|
| modelValue | 绑定值 | Array | — | [] |
| placeholder | 输入框占位文本 | String | — | '请选择省市区' |
| disabled | 是否禁用 | Boolean | — | false |
| size | 尺寸 | String | large / default / small | default |
| width | 宽度 | String | — | '100%' |
| showDistrict | 是否显示到区县级别（兼容旧版本） | Boolean | — | true |
| level | 控制显示层级 | Number | 1 / 2 / 3 | 3 |

### Events

| 事件名称 | 说明 | 回调参数 |
|----------|------|----------|
| update:modelValue | 绑定值变化时触发 | (value: Array) |
| change | 选择变化时触发 | (value: Array) |
| change-with-labels | 选择变化时触发，包含文本标签 | (data: { values: Array, labels: Array }) |

### Methods

| 方法名 | 说明 | 参数 |
|--------|------|------|
| reset | 重置选择器 | — |
| setValue | 设置值 | (value: Array) |
| getLabels | 获取选中的文本标签 | — |
| getSelectedInfo | 获取选中的完整信息 | — |

### 使用 Methods 示例

```vue
<template>
  <div>
    <RegionCascader
      ref="regionCascaderRef"
      v-model="selectedRegion"
      placeholder="请选择省市区"
      @change-with-labels="handleChangeWithLabels"
    />
    
    <div style="margin-top: 20px;">
      <el-button @click="resetRegion">重置</el-button>
      <el-button @click="setRegion">设置为北京</el-button>
      <el-button @click="getLabels">获取标签</el-button>
      <el-button @click="getInfo">获取完整信息</el-button>
    </div>
    
    <div style="margin-top: 20px;">
      <p>选中的值: {{ selectedRegion }}</p>
      <p>选中的标签: {{ selectedLabels }}</p>
      <p>完整信息: {{ selectedInfo }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const regionCascaderRef = ref()
const selectedRegion = ref([])
const selectedLabels = ref([])
const selectedInfo = ref({})

const resetRegion = () => {
  regionCascaderRef.value.reset()
}

const setRegion = () => {
  // 假设北京的数据结构为 [110000, 110100, 110101]
  regionCascaderRef.value.setValue([110000, 110100, 110101])
}

const getLabels = () => {
  selectedLabels.value = regionCascaderRef.value.getLabels()
}

const getInfo = () => {
  selectedInfo.value = regionCascaderRef.value.getSelectedInfo()
}

const handleChangeWithLabels = (data) => {
  console.log('选择变化:', data)
  selectedLabels.value = data.labels
}
</script>
```

## 🎯 最佳实践

### 1. 表单验证

```vue
<template>
  <el-form :model="form" :rules="rules" ref="formRef">
    <el-form-item label="区域" prop="region">
      <RegionCascader
        v-model="form.region"
        placeholder="请选择省市区"
      />
    </el-form-item>
  </el-form>
</template>

<script setup>
const rules = {
  region: [
    { required: true, message: '请选择区域', trigger: 'change' }
  ]
}
</script>
```

### 2. 数据回显

```vue
<script setup>
import { ref, onMounted } from 'vue'

const selectedRegion = ref([])

// 模拟从后端获取数据
onMounted(async () => {
  const data = await fetchRegionData()
  selectedRegion.value = data.region // 假设数据结构为 [110000, 110100, 110101]
})
</script>
```

### 3. 搜索功能

```vue
<script setup>
import { ref, watch } from 'vue'

const queryParams = ref({
  region: []
})

// 监听区域变化，自动触发搜索
watch(() => queryParams.value.region, (newRegion) => {
  if (newRegion.length > 0) {
    handleSearch()
  }
})

const handleSearch = () => {
  // 执行搜索逻辑
  console.log('搜索参数:', queryParams.value)
}
</script>
```

## 🐛 常见问题

### Q: 组件不显示数据？
A: 请检查后端接口是否正常返回数据，确保数据结构正确。

### Q: 如何获取选中的文本而不是值？
A: 可以通过 `change-with-labels` 事件或调用 `getLabels()` 方法获取文本标签。

### Q: 如何设置默认值？
A: 直接给 v-model 绑定的变量赋值即可，如 `region.value = [110000, 110100, 110101]`

### Q: 组件加载慢怎么办？
A: 组件采用懒加载机制，首次加载可能较慢，后续会缓存数据。

### Q: level 属性和 showDistrict 属性有什么区别？
A: `level` 属性是新增的层级控制属性，支持 1-3 级灵活控制；`showDistrict` 是兼容旧版本的属性，建议使用 `level` 属性。

### Q: 如何只显示省份？
A: 设置 `level="1"` 即可只显示省份选择。

## 📝 更新日志

### v1.1.0 (2024-01-XX)
- ✨ 新增 `level` 属性，支持灵活控制显示层级（1-3级）
- ✨ 新增 `change-with-labels` 事件，返回值和标签
- ✨ 新增 `getLabels()` 和 `getSelectedInfo()` 方法
- 🔧 优化懒加载逻辑，根据 level 属性控制数据加载
- 📝 更新文档，增加层级控制示例

### v1.0.0 (2024-01-XX)
- ✨ 初始版本发布
- ✨ 支持省市区三级联动
- ✨ 支持懒加载
- ✨ 支持全局注册
- ✨ 支持多种配置选项

## 📄 许可证

MIT License
