<template>
   <div class="app-container">
      <el-tabs v-model="activeTab" type="border-card">
         <el-tab-pane label="系统参数" name="system">
            <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
               <el-form-item label="参数名称" prop="configName">
                  <el-input
                     v-model="queryParams.configName"
                     placeholder="请输入参数名称"
                     clearable
                     style="width: 240px"
                     @keyup.enter="handleQuery"
                  />
               </el-form-item>
               <el-form-item label="参数键名" prop="configKey">
                  <el-input
                     v-model="queryParams.configKey"
                     placeholder="请输入参数键名"
                     clearable
                     style="width: 240px"
                     @keyup.enter="handleQuery"
                  />
               </el-form-item>
               <el-form-item label="系统内置" prop="configType">
                  <el-select v-model="queryParams.configType" placeholder="系统内置" clearable style="width: 240px">
                     <el-option
                        v-for="dict in sys_yes_no"
                        :key="dict.value"
                        :label="dict.label"
                        :value="dict.value"
                     />
                  </el-select>
               </el-form-item>
               <el-form-item label="创建时间" style="width: 308px;">
                  <el-date-picker
                     v-model="dateRange"
                     value-format="YYYY-MM-DD"
                     type="daterange"
                     range-separator="-"
                     start-placeholder="开始日期"
                     end-placeholder="结束日期"
                  ></el-date-picker>
               </el-form-item>
               <el-form-item>
                  <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                  <el-button icon="Refresh" @click="resetQuery">重置</el-button>
               </el-form-item>
            </el-form>

            <el-row :gutter="10" class="mb8">
               <el-col :span="1.5">
                  <el-button
                     type="primary"
                     plain
                     icon="Plus"
                     @click="handleAdd"
                     v-hasPermi="['system:config:add']"
                  >新增</el-button>
               </el-col>
               <el-col :span="1.5">
                  <el-button
                     type="success"
                     plain
                     icon="Edit"
                     :disabled="single"
                     @click="handleUpdate"
                     v-hasPermi="['system:config:edit']"
                  >修改</el-button>
               </el-col>
               <el-col :span="1.5">
                  <el-button
                     type="danger"
                     plain
                     icon="Delete"
                     :disabled="multiple"
                     @click="handleDelete"
                     v-hasPermi="['system:config:remove']"
                  >删除</el-button>
               </el-col>
               <el-col :span="1.5">
                  <el-button
                     type="warning"
                     plain
                     icon="Download"
                     @click="handleExport"
                     v-hasPermi="['system:config:export']"
                  >导出</el-button>
               </el-col>
               <el-col :span="1.5">
                  <el-button
                     type="danger"
                     plain
                     icon="Refresh"
                     @click="handleRefreshCache"
                     v-hasPermi="['system:config:remove']"
                  >刷新缓存</el-button>
               </el-col>
               <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
            </el-row>

            <el-table v-loading="loading" :data="configList" @selection-change="handleSelectionChange">
               <el-table-column type="selection" width="55" align="center" />
               <el-table-column label="参数主键" align="center" prop="configId" />
               <el-table-column label="参数名称" align="center" prop="configName" :show-overflow-tooltip="true" />
               <el-table-column label="参数键名" align="center" prop="configKey" :show-overflow-tooltip="true" />
               <el-table-column label="参数键值" align="center" prop="configValue" :show-overflow-tooltip="true" />
               <el-table-column label="系统内置" align="center" prop="configType">
                  <template #default="scope">
                     <dict-tag :options="sys_yes_no" :value="scope.row.configType" />
                  </template>
               </el-table-column>
               <el-table-column label="备注" align="center" prop="remark" :show-overflow-tooltip="true" />
               <el-table-column label="创建时间" align="center" prop="createTime" width="180">
                  <template #default="scope">
                     <span>{{ parseTime(scope.row.createTime) }}</span>
                  </template>
               </el-table-column>
               <el-table-column label="操作" align="center" width="150" class-name="small-padding fixed-width">
                  <template #default="scope">
                     <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)" v-hasPermi="['system:config:edit']" >修改</el-button>
                     <el-button link type="primary" icon="Delete" @click="handleDelete(scope.row)" v-hasPermi="['system:config:remove']">删除</el-button>
                  </template>
               </el-table-column>
            </el-table>

            <pagination
               v-show="total > 0"
               :total="total"
               v-model:page="queryParams.pageNum"
               v-model:limit="queryParams.pageSize"
               @pagination="getList"
            />

            <!-- 添加或修改参数配置对话框 -->
            <el-dialog :title="title" v-model="open" width="500px" append-to-body>
               <el-form ref="configRef" :model="form" :rules="rules" label-width="80px">
                  <el-form-item label="参数名称" prop="configName">
                     <el-input v-model="form.configName" placeholder="请输入参数名称" />
                  </el-form-item>
                  <el-form-item label="参数键名" prop="configKey">
                     <el-input v-model="form.configKey" placeholder="请输入参数键名" />
                  </el-form-item>
                  <el-form-item label="参数键值" prop="configValue">
                     <el-input v-model="form.configValue" type="textarea" placeholder="请输入参数键值" />
                  </el-form-item>
                  <el-form-item label="系统内置" prop="configType">
                     <el-radio-group v-model="form.configType">
                        <el-radio
                           v-for="dict in sys_yes_no"
                           :key="dict.value"
                           :value="dict.value"
                        >{{ dict.label }}</el-radio>
                     </el-radio-group>
                  </el-form-item>
                  <el-form-item label="备注" prop="remark">
                     <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
                  </el-form-item>
               </el-form>
               <template #footer>
                  <div class="dialog-footer">
                     <el-button type="primary" @click="submitForm">确 定</el-button>
                     <el-button @click="cancel">取 消</el-button>
                  </div>
               </template>
            </el-dialog>
         </el-tab-pane>

<el-tab-pane label="AI配置" name="ai">
             <el-card shadow="never">
                <template #header>
                   <span>AI助手配置</span>
                </template>
                <el-form ref="aiConfigRef" :model="aiConfig" :rules="aiConfigRules" label-width="100px" style="max-width: 600px;">
                   <el-form-item label="API提供商" prop="provider">
                      <el-select v-model="aiConfig.provider" placeholder="请选择API提供商" @change="handleProviderChange" style="width: 100%;">
                         <el-option label="DeepSeek" value="deepseek" />
                         <el-option label="阿里云百炼" value="qwen" />
                         <el-option label="自定义" value="custom" />
                      </el-select>
                   </el-form-item>
                   <el-form-item label="API Key" prop="apiKey">
                      <el-input v-model="aiConfig.apiKey" placeholder="请输入API Key" show-password>
                         <template #append>
                            <el-button @click="loadApiKeyFromYml" :loading="apiKeyLoading">从配置加载</el-button>
                         </template>
                      </el-input>
                       <div v-if="aiConfig.provider === 'deepseek'" class="key-hint">DeepSeek API Key 格式：sk-xxxxxxxx，获取地址：<a href="https://platform.deepseek.com/api_keys" target="_blank">DeepSeek控制台</a></div>
                      <div v-if="aiConfig.provider === 'qwen'" class="key-hint">阿里云百炼 API Key 格式：sk-xxxxxxxx，获取地址：<a href="https://bailian.console.aliyun.com/cn-beijing?tab=app#/api-key" target="_blank">百炼控制台</a></div>
                   </el-form-item>
                   <el-form-item label="API地址" prop="baseUrl">
                      <el-input v-model="aiConfig.baseUrl" placeholder="请输入API地址" :disabled="aiConfig.provider !== 'custom'" />
                      <div v-if="aiConfig.provider !== 'custom'" class="key-hint">预设地址，如需修改请选择"自定义"</div>
                   </el-form-item>
                   <el-form-item label="模型名称" prop="model">
                      <el-select v-model="aiConfig.model" placeholder="请选择模型" :disabled="aiConfig.provider !== 'custom'" style="width: 100%;">
                         <el-option v-for="item in modelOptions" :key="item.value" :label="item.label" :value="item.value" />
                      </el-select>
                      <div v-if="aiConfig.provider !== 'custom'" class="key-hint">预设模型，如需修改请选择"自定义"</div>
                   </el-form-item>
                   <el-form-item>
                      <el-button type="primary" @click="saveAiConfig" :loading="aiSaving">保存配置</el-button>
                      <el-button type="success" @click="testAiConfig" :loading="aiTesting">测试连接</el-button>
                      <el-button @click="resetAiConfig">重置</el-button>
                   </el-form-item>
                </el-form>
                <el-divider content-position="left">对话测试</el-divider>
                <el-card shadow="hover" style="max-width: 600px;">
                   <el-form :inline="true" style="margin-bottom: 16px;">
                      <el-form-item style="width: 100%;">
                         <el-input v-model="testMessage" placeholder="输入测试消息，如：你是谁？你的功能是啥？" style="width: 400px;" clearable />
                         <el-button type="primary" @click="testAiChat" :loading="chatTesting" style="margin-left: 8px;">发送</el-button>
                      </el-form-item>
                   </el-form>
                   <div v-if="chatTestResult" class="chat-result">
                      <div class="chat-message user-message">
                         <span class="role-tag">我</span>
                         <span class="content">{{ chatTestResult.question }}</span>
                      </div>
                      <div class="chat-message ai-message">
                         <span class="role-tag ai">AI</span>
                         <span class="content">{{ chatTestResult.answer }}</span>
                      </div>
                   </div>
                   <div v-if="chatTesting" class="chat-loading">
                      <el-icon class="is-loading"><Loading /></el-icon>
                      <span>AI正在思考...</span>
                   </div>
                </el-card>
                <el-divider />
                <div v-if="aiTestResult">
                   <el-alert :title="aiTestResult.success ? '连接测试成功' : '连接测试失败'" :type="aiTestResult.success ? 'success' : 'error'" show-icon closable @close="aiTestResult = null">
                      <template #default>
                         <div>{{ aiTestResult.message }}</div>
                         <div v-if="aiTestResult.reply" style="margin-top: 8px;">
                           <strong>AI回复：</strong>{{ aiTestResult.reply }}
                         </div>
                      </template>
                   </el-alert>
                </div>
             </el-card>
          </el-tab-pane>
      </el-tabs>
   </div>
</template>

<script setup name="Config">
import { listConfig, getConfig, delConfig, addConfig, updateConfig, refreshCache } from "@/api/system/config";
import request from "@/utils/request";
import { Loading } from '@element-plus/icons-vue';

const { proxy } = getCurrentInstance();
const { sys_yes_no } = proxy.useDict("sys_yes_no");

const activeTab = ref("ai");
const configList = ref([]);
const open = ref(false);
const loading = ref(true);
const showSearch = ref(true);
const ids = ref([]);
const single = ref(true);
const multiple = ref(true);
const total = ref(0);
const title = ref("");
const dateRange = ref([]);

const aiConfig = ref({
  provider: "deepseek",
  apiKey: "",
  baseUrl: "",
  model: ""
});
const aiSaving = ref(false);
const aiTesting = ref(false);
const aiTestResult = ref(null);
const apiKeyLoading = ref(false);
const testMessage = ref("你是谁？你的功能是啥？");
const chatTesting = ref(false);
const chatTestResult = ref(null);

const providerPresets = {
  deepseek: {
    baseUrl: "https://api.deepseek.com/v1",
    model: "deepseek-chat",
    defaultKey: "sk-67fa82cfcb9b483fb9c6bac0cb41e15d"
  },
  qwen: {
    baseUrl: "https://dashscope.aliyuncs.com/compatible-mode/v1",
    model: "qwen-plus",
    defaultKey: "sk-17fde29477c84150a70fb0244dd2ffc7"
  },
  custom: {
    baseUrl: "",
    model: "",
    defaultKey: ""
  }
};

const modelOptions = computed(() => {
  const provider = aiConfig.value.provider;
  if (provider === "deepseek") {
    return [
      { label: "DeepSeek Chat", value: "deepseek-chat" },
      { label: "DeepSeek Coder", value: "deepseek-coder" }
    ];
  } else if (provider === "qwen") {
    return [
      { label: "Qwen-Plus", value: "qwen-plus" },
      { label: "Qwen-Turbo", value: "qwen-turbo" },
      { label: "Qwen-Max", value: "qwen-max" }
    ];
  }
  return [
    { label: "自定义模型", value: "" }
  ];
});

const aiConfigRules = {
  provider: [{ required: true, message: "请选择API提供商", trigger: "change" }],
  baseUrl: [{ required: true, message: "API地址不能为空", trigger: "blur" }],
  model: [{ required: true, message: "模型名称不能为空", trigger: "change" }]
};

const data = reactive({
  form: {},
  queryParams: {
    pageNum: 1,
    pageSize: 10,
    configName: undefined,
    configKey: undefined,
    configType: undefined
  },
  rules: {
    configName: [{ required: true, message: "参数名称不能为空", trigger: "blur" }],
    configKey: [{ required: true, message: "参数键名不能为空", trigger: "blur" }],
    configValue: [{ required: true, message: "参数键值不能为空", trigger: "blur" }]
  }
});

const { queryParams, form, rules } = toRefs(data);

/** 查询参数列表 */
function getList() {
  loading.value = true;
  listConfig(proxy.addDateRange(queryParams.value, dateRange.value)).then(response => {
    configList.value = response.rows;
    total.value = response.total;
    loading.value = false;
  });
}

/** 取消按钮 */
function cancel() {
  open.value = false;
  reset();
}

/** 表单重置 */
function reset() {
  form.value = {
    configId: undefined,
    configName: undefined,
    configKey: undefined,
    configValue: undefined,
    configType: "Y",
    remark: undefined
  };
  proxy.resetForm("configRef");
}

/** 搜索按钮操作 */
function handleQuery() {
  queryParams.value.pageNum = 1;
  getList();
}

/** 重置按钮操作 */
function resetQuery() {
  dateRange.value = [];
  proxy.resetForm("queryRef");
  handleQuery();
}

/** 多选框选中数据 */
function handleSelectionChange(selection) {
  ids.value = selection.map(item => item.configId);
  single.value = selection.length != 1;
  multiple.value = !selection.length;
}

/** 新增按钮操作 */
function handleAdd() {
  reset();
  open.value = true;
  title.value = "添加参数";
}

/** 修改按钮操作 */
function handleUpdate(row) {
  reset();
  const configId = row.configId || ids.value;
  getConfig(configId).then(response => {
    form.value = response.data;
    open.value = true;
    title.value = "修改参数";
  });
}

/** 提交按钮 */
function submitForm() {
  proxy.$refs["configRef"].validate(valid => {
    if (valid) {
      if (form.value.configId != undefined) {
        updateConfig(form.value).then(response => {
          proxy.$modal.msgSuccess("修改成功");
          open.value = false;
          getList();
        });
      } else {
        addConfig(form.value).then(response => {
          proxy.$modal.msgSuccess("新增成功");
          open.value = false;
          getList();
        });
      }
    }
  });
}

/** 删除按钮操作 */
function handleDelete(row) {
  const configIds = row.configId || ids.value;
  proxy.$modal.confirm('是否确认删除参数编号为"' + configIds + '"的数据项？').then(function () {
    return delConfig(configIds);
  }).then(() => {
    getList();
    proxy.$modal.msgSuccess("删除成功");
  }).catch(() => {});
}

/** 导出按钮操作 */
function handleExport() {
  proxy.download("system/config/export", {
    ...queryParams.value
  }, `config_${new Date().getTime()}.xlsx`);
}

/** 刷新缓存按钮操作 */
function handleRefreshCache() {
  refreshCache().then(() => {
    proxy.$modal.msgSuccess("刷新缓存成功");
  });
}

function loadAiConfig() {
  request({
    url: "/api/ai/config",
    method: "get"
  }).then(res => {
    if (res.code === 200) {
      const data = res.data || {};
      aiConfig.value.baseUrl = data.baseUrl || providerPresets.deepseek.baseUrl;
      aiConfig.value.model = data.model || providerPresets.deepseek.model;
      aiConfig.value.apiKey = "";
      aiConfig.value.provider = data.provider || "deepseek";
    }
  }).catch(() => {
    aiConfig.value.baseUrl = providerPresets.deepseek.baseUrl;
    aiConfig.value.model = providerPresets.deepseek.model;
    aiConfig.value.provider = "deepseek";
  });
}

function handleProviderChange(provider) {
  const preset = providerPresets[provider] || providerPresets.custom;
  aiConfig.value.baseUrl = preset.baseUrl;
  aiConfig.value.model = preset.model;
  if (preset.defaultKey && !aiConfig.value.apiKey) {
    aiConfig.value.apiKey = preset.defaultKey;
  }
}

function loadApiKeyFromYml() {
  apiKeyLoading.value = true;
  request({
    url: "/api/ai/config/yml",
    method: "get"
  }).then(res => {
    apiKeyLoading.value = false;
    if (res.code === 200 && res.data) {
      if (res.data.apiKey) {
        aiConfig.value.apiKey = res.data.apiKey;
        proxy.$modal.msgSuccess("已从配置文件加载API Key");
      }
      if (res.data.baseUrl) {
        aiConfig.value.baseUrl = res.data.baseUrl;
      }
      if (res.data.model) {
        aiConfig.value.model = res.data.model;
      }
      if (res.data.provider) {
        aiConfig.value.provider = res.data.provider;
      }
    }
  }).catch(() => {
    apiKeyLoading.value = false;
    const preset = providerPresets[aiConfig.value.provider];
    if (preset && preset.defaultKey) {
      aiConfig.value.apiKey = preset.defaultKey;
      proxy.$modal.msgSuccess("已加载预设API Key");
    }
  });
}

function resetAiConfig() {
  aiConfig.value.provider = "deepseek";
  handleProviderChange("deepseek");
  aiTestResult.value = null;
}

function saveAiConfig() {
  proxy.$refs["aiConfigRef"].validate(valid => {
    if (valid) {
      aiSaving.value = true;
      const savePromises = [];
      
      if (aiConfig.value.apiKey) {
        savePromises.push(
          request({
            url: "/system/config/updateByKey",
            method: "post",
            data: { configName: "AI API Key", configKey: "ai.apiKey", configValue: aiConfig.value.apiKey, remark: "AI助手API密钥" }
          })
        );
      }
      
      savePromises.push(
        request({
          url: "/system/config/updateByKey",
          method: "post",
          data: { configKey: "ai.provider", configValue: aiConfig.value.provider }
        })
      );
      
      savePromises.push(
        request({
          url: "/system/config/updateByKey",
          method: "post",
          data: { configKey: "ai.baseUrl", configValue: aiConfig.value.baseUrl }
        })
      );
      
      savePromises.push(
        request({
          url: "/system/config/updateByKey",
          method: "post",
          data: { configKey: "ai.model", configValue: aiConfig.value.model }
        })
      );
      
      Promise.all(savePromises).then(() => {
        proxy.$modal.msgSuccess("保存成功");
        aiSaving.value = false;
        loadAiConfig();
      }).catch(() => {
        aiSaving.value = false;
      });
    }
  });
}



function testAiConfig() {
  if (!aiConfig.value.apiKey && !aiConfig.value.baseUrl) {
    proxy.$modal.msgWarning("请先填写API配置");
    return;
  }
  
  aiTesting.value = true;
  aiTestResult.value = null;
  
  request({
    url: "/api/ai/config/test",
    method: "post",
    data: {
      apiKey: aiConfig.value.apiKey || undefined,
      baseUrl: aiConfig.value.baseUrl,
      model: aiConfig.value.model
    }
  }).then(res => {
    aiTesting.value = false;
    if (res.code === 200) {
      aiTestResult.value = { success: true, message: "AI连接测试成功", reply: res.data?.reply };
    } else {
      aiTestResult.value = { success: false, message: res.msg || "测试失败" };
    }
  }).catch(err => {
    aiTesting.value = false;
    aiTestResult.value = { success: false, message: err.message || "网络错误" };
  });
}

function testAiChat() {
  if (!testMessage.value.trim()) {
    proxy.$modal.msgWarning("请输入测试消息");
    return;
  }
  if (!aiConfig.value.apiKey && !aiConfig.value.baseUrl) {
    proxy.$modal.msgWarning("请先填写API配置");
    return;
  }
  
  chatTesting.value = true;
  const question = testMessage.value.trim();
  
  request({
    url: "/api/ai/config/test/chat",
    method: "post",
    data: {
      apiKey: aiConfig.value.apiKey || undefined,
      baseUrl: aiConfig.value.baseUrl,
      model: aiConfig.value.model,
      message: question
    },
    timeout: 60000
  }).then(res => {
    chatTesting.value = false;
    if (res.code === 200) {
      chatTestResult.value = { question: question, answer: res.data?.reply || res.msg };
    } else {
      chatTestResult.value = { question: question, answer: "错误: " + (res.msg || "请求失败") };
    }
  }).catch(err => {
    chatTesting.value = false;
    chatTestResult.value = { question: question, answer: "错误: " + (err.message || "网络错误") };
  });
}

watch(activeTab, (val) => {
  if (val === "ai") {
    loadAiConfig();
  }
});

getList();
loadAiConfig();
</script>

<style scoped>
.key-hint {
  font-size: 12px;
  color: #909399;
  margin-top: 4px;
}
.key-hint a {
  color: #409eff;
}
.chat-result {
  margin-top: 16px;
}
.chat-message {
  display: flex;
  align-items: flex-start;
  margin-bottom: 12px;
  padding: 12px;
  border-radius: 8px;
}
.user-message {
  background: #f0f9ff;
}
.ai-message {
  background: #f6f6f6;
}
.role-tag {
  display: inline-block;
  min-width: 32px;
  padding: 2px 8px;
  border-radius: 4px;
  font-size: 12px;
  font-weight: bold;
  margin-right: 12px;
  background: #409eff;
  color: #fff;
}
.role-tag.ai {
  background: #67c23a;
}
.chat-message .content {
  flex: 1;
  line-height: 1.6;
  white-space: pre-wrap;
  word-break: break-word;
}
.chat-loading {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 16px;
  color: #909399;
}
</style>
