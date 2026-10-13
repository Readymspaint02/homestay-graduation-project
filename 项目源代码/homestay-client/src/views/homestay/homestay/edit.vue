<template>
  <div class="page-view">
    <a-card title="房源信息" :bordered="false">
      <a-form ref="formRef" :model="form" :rules="rules" layout="vertical">
        <a-row :gutter="24">
          <a-col :span="12">
            <a-form-item label="房源标题" name="title">
              <a-input v-model:value="form.title" placeholder="请输入房源标题（最多 60 字）" :maxlength="60" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="房型" name="roomType">
              <a-select v-model:value="form.roomType" placeholder="请选择房型">
                <a-select-option value="整套">整套房源</a-select-option>
                <a-select-option value="独立">独立房间</a-select-option>
                <a-select-option value="合租">合住房间</a-select-option>
              </a-select>
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="24">
            <a-form-item label="房源描述" name="description">
              <a-textarea v-model:value="form.description" placeholder="请输入房源描述（最多 2000 字）" :rows="4" :maxlength="2000" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="8">
            <a-form-item label="可住人数" name="maxGuests">
              <a-input-number v-model:value="form.maxGuests" :min="1" :max="20" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="卧室数" name="bedroomCount">
              <a-input-number v-model:value="form.bedroomCount" :min="1" :max="10" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="床型信息" name="bedInfo">
              <a-input v-model:value="form.bedInfo" placeholder="如：1 张大床 + 2 张单人床" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="8">
            <a-form-item label="省份" name="province">
              <a-input v-model:value="form.province" placeholder="请输入省份" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="城市" name="city">
              <a-input v-model:value="form.city" placeholder="请输入城市" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="区县" name="district">
              <a-input v-model:value="form.district" placeholder="请输入区县" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="24">
            <a-form-item label="详细地址" name="address">
              <a-input v-model:value="form.address" placeholder="请输入详细地址（最多 255 字）" :maxlength="255" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="8">
            <a-form-item label="平日价（元/晚）" name="basePrice">
              <a-input-number v-model:value="form.basePrice" :min="0" :step="10" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="周末价（元/晚）" name="weekendPrice">
              <a-input-number v-model:value="form.weekendPrice" :min="0" :step="10" style="width: 100%" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="清洁费（元）" name="cleaningFee">
              <a-input-number v-model:value="form.cleaningFee" :min="0" :step="10" style="width: 100%" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="8">
            <a-form-item label="押金（元）" name="deposit">
              <a-input-number v-model:value="form.deposit" :min="0" :step="100" style="width: 100%" />
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="24">
            <a-form-item label="设施服务" name="facilities">
              <a-checkbox-group v-model:value="form.facilities">
                <a-row>
                  <a-col :span="8" v-for="item in facilityOptions" :key="item.value">
                    <a-checkbox :value="item.value">{{ item.label }}</a-checkbox>
                  </a-col>
                </a-row>
              </a-checkbox-group>
            </a-form-item>
          </a-col>
        </a-row>

        <a-row :gutter="24">
          <a-col :span="24">
            <a-form-item label="房源图片" name="images">
              <a-upload
                list-type="picture-card"
                :file-list="imageList"
                :before-upload="beforeUpload"
                :on-remove="handleRemove"
                :on-preview="handlePreview"
                :max-count="10"
              >
                <div v-if="imageList.length < 10">
                  <plus-outlined />
                  <div style="margin-top: 8px">上传</div>
                </div>
              </a-upload>
              <a-modal v-model:open="previewVisible">
                <img alt="preview" style="width: 100%" :src="previewImage" />
              </a-modal>
            </a-form-item>
          </a-col>
        </a-row>

        <a-form-item>
          <a-space>
            <a-button type="primary" :loading="submitLoading" @click="handleSubmit">提交</a-button>
            <a-button @click="handleBack">返回</a-button>
          </a-space>
        </a-form-item>
      </a-form>
    </a-card>
  </div>
</template>

<script setup lang="ts">
  import { onMounted, reactive, ref, computed } from 'vue';
  import { message } from 'ant-design-vue';
  import { useRoute, useRouter } from 'vue-router';
  import { detailApi, createApi, updateApi, uploadApi } from '/@/api/homestay';
  import { PlusOutlined } from '@ant-design/icons-vue';

  const route = useRoute();
  const router = useRouter();

  const formRef = ref<any>();
  const submitLoading = ref(false);
  const previewVisible = ref(false);
  const previewImage = ref('');

  const form = reactive<any>({
    title: '',
    description: '',
    roomType: '',
    maxGuests: 2,
    bedroomCount: 1,
    bedInfo: '',
    province: '',
    city: '',
    district: '',
    address: '',
    basePrice: 100,
    weekendPrice: undefined,
    cleaningFee: undefined,
    deposit: undefined,
    facilities: [] as string[],
    images: [] as any[],
  });

  const rules = {
    title: [{ required: true, message: '请输入房源标题', trigger: 'blur' }],
    roomType: [{ required: true, message: '请选择房型', trigger: 'change' }],
    maxGuests: [{ required: true, message: '请输入可住人数', trigger: 'change' }],
    basePrice: [{ required: true, message: '请输入平日价', trigger: 'change' }],
  };

  const facilityOptions = [
    { label: 'WiFi', value: 'wifi' },
    { label: '空调', value: 'air_conditioning' },
    { label: '热水壶', value: 'kettle' },
    { label: '吹风机', value: 'hair_dryer' },
    { label: '电视机', value: 'tv' },
    { label: '冰箱', value: 'fridge' },
    { label: '洗衣机', value: 'washer' },
    { label: '微波炉', value: 'microwave' },
    { label: '厨房可做饭', value: 'kitchen' },
    { label: '免费停车', value: 'parking' },
    { label: '电梯', value: 'elevator' },
    { label: '门禁安全', value: 'security' },
  ];

  const imageList = computed(() => {
    return form.images.map((img: any, index: number) => ({
      uid: img.uid || index,
      name: img.fileName || '图片',
      status: 'done',
      url: img.imageUrl,
      thumbUrl: img.imageUrl,
    }));
  });

  const isEdit = computed(() => {
    return !!route.params.id;
  });

  const beforeUpload = async (file: File) => {
    const isImage = file.type.startsWith('image/');
    if (!isImage) {
      message.error('只能上传图片文件！');
      return false;
    }
    const isLt5M = file.size / 1024 / 1024 < 5;
    if (!isLt5M) {
      message.error('图片大小不能超过 5MB！');
      return false;
    }

    try {
      const res = await uploadApi(file);
      const imageData = {
        uid: file.uid,
        fileName: file.name,
        imageUrl: res.data?.imageUrl,
        sortOrder: form.images.length,
        isCover: form.images.length === 0 ? '1' : '0',
      };
      form.images.push(imageData);
      message.success('上传成功');
    } catch (e: any) {
      message.error(e.message || '上传失败');
    }
    return false;
  };

  const handleRemove = (file: any) => {
    const index = form.images.findIndex((img: any) => img.uid === file.uid);
    if (index > -1) {
      form.images.splice(index, 1);
    }
  };

  const handlePreview = (file: any) => {
    previewImage.value = file.url || file.thumbUrl;
    previewVisible.value = true;
  };

  const handleSubmit = async () => {
    if (!formRef.value) return;
    try {
      await formRef.value.validate();
      submitLoading.value = true;

      const facilities = form.facilities.map((code: string) => {
        const option = facilityOptions.find((o) => o.value === code);
        return {
          facilityCode: code,
          facilityName: option?.label || code,
        };
      });

      const payload = {
        ...form,
        facilities,
        images: form.images.map((img: any, index: number) => ({
          imageUrl: img.imageUrl,
          sortOrder: index,
          isCover: index === 0 ? '1' : '0',
        })),
      };

      if (isEdit.value) {
        payload.id = route.params.id;
        await updateApi(payload);
        message.success('更新成功，房源将重新进入审核状态');
      } else {
        await createApi(payload);
        message.success('创建成功，房源已提交审核');
      }
      router.push('/homestay/homestay/list');
    } catch (e: any) {
      if (e.message !== 'validation failed') {
        message.error(e.message || (isEdit.value ? '更新失败' : '创建失败'));
      }
    } finally {
      submitLoading.value = false;
    }
  };

  const handleBack = () => {
    router.back();
  };

  const loadDetail = async () => {
    if (!isEdit.value) return;
    try {
      const res = await detailApi(Number(route.params.id));
      const data = res.data;
      if (data) {
        form.title = data.title || '';
        form.description = data.description || '';
        form.roomType = data.roomType || '';
        form.maxGuests = data.maxGuests || 2;
        form.bedroomCount = data.bedroomCount || 1;
        form.bedInfo = data.bedInfo || '';
        form.province = data.province || '';
        form.city = data.city || '';
        form.district = data.district || '';
        form.address = data.address || '';
        form.basePrice = data.basePrice || 100;
        form.weekendPrice = data.weekendPrice;
        form.cleaningFee = data.cleaningFee;
        form.deposit = data.deposit;
        form.facilities = (data.facilities || []).map((f: any) => f.facilityCode);
        form.images = (data.images || []).map((img: any, index: number) => ({
          uid: index,
          fileName: `图片${index + 1}`,
          imageUrl: img.imageUrl,
          sortOrder: img.sortOrder,
          isCover: img.isCover,
        }));
      }
    } catch (e: any) {
      message.error(e.message || '加载详情失败');
    }
  };

  onMounted(() => {
    loadDetail();
  });
</script>

<style scoped lang="less">
  .page-view {
    padding: 24px;
  }
</style>
