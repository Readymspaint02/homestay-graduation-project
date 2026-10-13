<template>
  <div class="page-view">
    <div class="page-header">
      <h2>{{ isEdit ? '编辑房源' : '发布新房源' }}</h2>
      <p>填写房源信息，提交后等待平台审核</p>
    </div>
    
    <a-form :model="form" layout="vertical" @finish="handleSubmit" class="modern-form">
      <a-card class="modern-card" title="基本信息" :bordered="false">
        <template #extra><span class="card-tip">* 为必填项</span></template>
        <a-row :gutter="24">
          <a-col :span="12">
            <a-form-item label="房源标题" name="title" :rules="[{ required: true, message: '请输入标题' }]">
              <a-input v-model:value="form.title" placeholder="例如：温馨海景两居室" allow-clear />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="房型" name="roomType">
              <a-select v-model:value="form.roomType" placeholder="请选择或输入房型" mode="combobox" :options="roomTypeOptions" allow-clear />
            </a-form-item>
          </a-col>
        </a-row>
        <a-row :gutter="24">
          <a-col :span="8">
            <a-form-item label="卧室数" name="bedroomCount">
              <a-input-number v-model:value="form.bedroomCount" :min="1" :max="10" style="width: 100%" addon-after="间" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="可住人数" name="maxGuests">
              <a-input-number v-model:value="form.maxGuests" :min="1" :max="20" style="width: 100%" addon-after="人" />
            </a-form-item>
          </a-col>
          <a-col :span="8">
            <a-form-item label="床型信息" name="bedInfo">
              <a-select v-model:value="form.bedInfo" placeholder="请选择或输入" mode="combobox" :options="bedInfoOptions" allow-clear />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="房源描述" name="description">
          <a-textarea v-model:value="form.description" :rows="4" placeholder="描述房源特色、周边配套、交通情况等..." show-count :maxlength="500" />
        </a-form-item>
      </a-card>

      <a-card class="modern-card" title="价格设置" :bordered="false">
        <template #extra><span class="card-tip">建议参考周边市场定价</span></template>
        <a-row :gutter="24">
          <a-col :span="6">
            <a-form-item label="平日价" name="basePrice" :rules="[{ required: true, message: '请输入价格' }]">
              <a-input-number v-model:value="form.basePrice" :min="0" :precision="0" style="width: 100%" addon-before="¥" @change="handleBasePriceChange" />
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="周末价" name="weekendPrice">
              <a-input-number v-model:value="form.weekendPrice" :min="0" :precision="0" style="width: 100%" addon-before="¥" />
              <div class="price-tip">建议: 平日价×1.3 ≈ ¥{{ calculatedWeekendPrice }}</div>
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="清洁费" name="cleaningFee">
              <a-input-number v-model:value="form.cleaningFee" :min="0" :precision="0" style="width: 100%" addon-before="¥" />
              <div class="price-tip">建议: 平日价×0.2 ≈ ¥{{ calculatedCleaningFee }}</div>
            </a-form-item>
          </a-col>
          <a-col :span="6">
            <a-form-item label="押金" name="deposit">
              <a-input-number v-model:value="form.deposit" :min="0" :precision="0" style="width: 100%" addon-before="¥" />
              <div class="price-tip">建议: 平日价×0.4 ≈ ¥{{ calculatedDeposit }}</div>
            </a-form-item>
          </a-col>
        </a-row>
      </a-card>

      <a-card class="modern-card" title="地址信息" :bordered="false">
        <template #extra>
          <a-button type="link" size="small" @click="handleAutoLocation" :loading="locating">
            <EnvironmentOutlined /> 自动定位
          </a-button>
        </template>
        <a-row :gutter="24">
          <a-col :span="24">
            <a-form-item label="所在地区" name="region" :rules="[{ required: true, message: '请选择地区' }]">
              <a-cascader
                v-model:value="form.region"
                :options="regionOptions"
                :load-data="lazyLoadRegion"
                placeholder="请选择省/市/区县"
                :field-names="{ label: 'label', value: 'value', children: 'children' }"
                @change="handleRegionChange"
                style="width: 100%"
              />
            </a-form-item>
          </a-col>
        </a-row>
        <a-form-item label="详细地址" name="address" :rules="[{ required: true, message: '请输入详细地址' }]">
          <a-input 
            v-model:value="form.address" 
            placeholder="例如：XX路XX号XX小区XX栋XX室" 
            allow-clear 
            @blur="handleAddressBlur"
          />
        </a-form-item>
        <a-row :gutter="24">
          <a-col :span="12">
            <a-form-item label="经度">
              <a-input-number v-model:value="form.longitude" :precision="7" style="width: 100%" placeholder="自动获取或手动输入" />
            </a-form-item>
          </a-col>
          <a-col :span="12">
            <a-form-item label="纬度">
              <a-input-number v-model:value="form.latitude" :precision="7" style="width: 100%" placeholder="自动获取或手动输入" />
            </a-form-item>
          </a-col>
        </a-row>
        <div v-if="form.longitude && form.latitude" class="map-preview">
          <div id="location-map" style="width: 100%; height: 200px;"></div>
          <div class="map-tip">地图预览（点击地图可调整位置）</div>
        </div>
      </a-card>

      <a-card class="modern-card" title="房源封面" :bordered="false">
        <template #extra><span class="card-tip">建议尺寸: 800x600，支持jpg/png</span></template>
        <div class="upload-wrapper">
          <a-upload
            :action="qiniuUploadUrl"
            :data="qiniuUploadData"
            list-type="picture-card"
            :file-list="fileList"
            :before-upload="beforeQiniuUpload"
            @preview="handlePreview"
            @change="handleQiniuUploadChange"
            :max-count="1"
            accept="image/*"
          >
            <div v-if="fileList.length < 1" class="upload-btn">
              <plus-outlined />
              <div>上传封面</div>
            </div>
          </a-upload>
          <div v-if="uploading" class="upload-loading">
            <a-spin />
            <span>上传中...</span>
          </div>
        </div>
        <a-modal :open="previewVisible" :footer="null" @cancel="previewVisible = false">
          <img alt="preview" style="width: 100%" :src="previewImage" />
        </a-modal>
      </a-card>

      <div class="form-actions">
        <a-button size="large" @click="handleCancel">取消</a-button>
        <a-button type="primary" size="large" html-type="submit" :loading="submitting">{{ isEdit ? '保存修改' : '提交审核' }}</a-button>
      </div>
    </a-form>
  </div>
</template>

<script setup lang="ts">
import { onMounted, onUnmounted, reactive, ref, computed, nextTick } from 'vue';
import { message } from 'ant-design-vue';
import { PlusOutlined, EnvironmentOutlined } from '@ant-design/icons-vue';
import { useRouter, useRoute } from 'vue-router';
import { createApi, updateApi, detailApi } from '/@/api/homestay';
import { get } from '/@/utils/http/axios';
import REGION_DATA from 'china-area-data';
import AMapLoader from '@amap/amap-jsapi-loader';
import { AMAP_CONFIG } from '/@/config/index';

declare const AMap: any;

const router = useRouter();
const route = useRoute();
const isEdit = ref(false);
const submitting = ref(false);
const uploading = ref(false);
const locating = ref(false);

const regionOptions = ref<any[]>([]);
const fileList = ref<any[]>([]);
const previewVisible = ref(false);
const previewImage = ref('');
let mapInstance: any = null;
let markerInstance: any = null;
let geocoderInstance: any = null;

const qiniuUploadUrl = ref('https://homestay-02.s3.cn-south-1.qiniucs.com');
const qiniuUploadData = ref<{ token: string; key: string }>({ token: '', key: '' });
const qiniuDomain = ref('');

const roomTypeOptions = [
  { value: '整套公寓', label: '整套公寓' },
  { value: '整套别墅', label: '整套别墅' },
  { value: '整套民宿', label: '整套民宿' },
  { value: '独立单间', label: '独立单间' },
  { value: '标准间', label: '标准间' },
  { value: '大床房', label: '大床房' },
  { value: '双床房', label: '双床房' },
  { value: '套房', label: '套房' },
  { value: 'LOFT', label: 'LOFT' },
  { value: '合租房', label: '合租房' },
  { value: '床位房', label: '床位房' },
];

const bedInfoOptions = [
  { value: '1.8m大床×1', label: '1.8m大床×1' },
  { value: '1.8m大床×2', label: '1.8m大床×2' },
  { value: '1.5m双人床×1', label: '1.5m双人床×1' },
  { value: '1.5m双人床×2', label: '1.5m双人床×2' },
  { value: '1.2m单人床×1', label: '1.2m单人床×1' },
  { value: '1.2m单人床×2', label: '1.2m单人床×2' },
  { value: '1.0m单人床×2', label: '1.0m单人床×2' },
  { value: '1.0m单人床×3', label: '1.0m单人床×3' },
  { value: '上下铺×1', label: '上下铺×1' },
  { value: '上下铺×2', label: '上下铺×2' },
  { value: '榻榻米×1', label: '榻榻米×1' },
];

const form = reactive({
  id: null as number | null,
  title: '',
  description: '',
  roomType: '整套公寓',
  bedroomCount: 1,
  bedInfo: '',
  province: '',
  city: '',
  district: '',
  address: '',
  basePrice: 199,
  weekendPrice: null as number | null,
  cleaningFee: null as number | null,
  deposit: null as number | null,
  maxGuests: 2,
  coverImage: null as string | null,
  longitude: null as number | null,
  latitude: null as number | null,
  region: [] as string[],
});

const calculatedWeekendPrice = computed(() => Math.round(form.basePrice * 1.3));
const calculatedCleaningFee = computed(() => Math.round(form.basePrice * 0.2));
const calculatedDeposit = computed(() => Math.round(form.basePrice * 0.4));

const handleBasePriceChange = () => {
  if (!form.weekendPrice) form.weekendPrice = calculatedWeekendPrice.value;
  if (!form.cleaningFee) form.cleaningFee = calculatedCleaningFee.value;
  if (!form.deposit) form.deposit = calculatedDeposit.value;
};

const lazyLoadRegion = (selectedOptions: any[]) => {
  const targetOption = selectedOptions[selectedOptions.length - 1];
  targetOption.loading = true;
  
  setTimeout(() => {
    targetOption.loading = false;
    const code = targetOption.value;
    const children = REGION_DATA[code];
    if (children) {
      targetOption.children = Object.entries(children).map(([childCode, childName]) => ({
        value: childCode,
        label: childName,
        isLeaf: !REGION_DATA[childCode] || Object.keys(REGION_DATA[childCode] || {}).length === 0,
      }));
    }
    regionOptions.value = [...regionOptions.value];
  }, 0);
};

const buildRootOptions = () => {
  const provinces = REGION_DATA['86'] || {};
  regionOptions.value = Object.entries(provinces).map(([code, name]) => ({
    value: code,
    label: name,
    isLeaf: false,
  }));
};

const handleRegionChange = (value: string[], selectedOptions: any[]) => {
  if (selectedOptions && selectedOptions.length >= 1) {
    form.province = selectedOptions[0].label;
  }
  if (selectedOptions && selectedOptions.length >= 2) {
    form.city = selectedOptions[1].label;
  }
  if (selectedOptions && selectedOptions.length >= 3) {
    form.district = selectedOptions[2].label;
  }
};

const initMap = () => {
  if (!document.getElementById('location-map')) return;
  if (typeof AMap === 'undefined') {
    console.warn('高德地图JS API未加载');
    return;
  }
  
  if (!mapInstance) {
    mapInstance = new AMap.Map('location-map', {
      zoom: 15,
      center: form.longitude && form.latitude ? [form.longitude, form.latitude] : [116.397428, 39.90923],
    });
    
    markerInstance = new AMap.Marker({
      position: mapInstance.getCenter(),
      draggable: true,
    });
    mapInstance.add(markerInstance);
    
    geocoderInstance = new AMap.Geocoder();
    
    markerInstance.on('dragend', (e: any) => {
      const pos = markerInstance.getPosition();
      form.longitude = parseFloat(pos.lng.toFixed(7));
      form.latitude = parseFloat(pos.lat.toFixed(7));
    });
    
    mapInstance.on('click', (e: any) => {
      markerInstance.setPosition([e.lnglat.lng, e.lnglat.lat]);
      form.longitude = parseFloat(e.lnglat.lng.toFixed(7));
      form.latitude = parseFloat(e.lnglat.lat.toFixed(7));
    });
  } else {
    if (form.longitude && form.latitude) {
      mapInstance.setCenter([form.longitude, form.latitude]);
      markerInstance.setPosition([form.longitude, form.latitude]);
    }
  }
};

const updateMapMarker = (lng: number, lat: number) => {
  if (mapInstance && markerInstance) {
    mapInstance.setCenter([lng, lat]);
    markerInstance.setPosition([lng, lat]);
  }
};

const geocodeAddress = async (address: string): Promise<{ lng: number; lat: number } | null> => {
  if (typeof AMap === 'undefined') {
    console.warn('高德地图JS API未加载');
    return null;
  }
  
  return new Promise((resolve) => {
    const geocoder = new AMap.Geocoder();
    geocoder.getLocation(address, (status: string, result: any) => {
      if (status === 'complete' && result.geocodes && result.geocodes.length > 0) {
        const location = result.geocodes[0].location;
        resolve({ lng: location.lng, lat: location.lat });
      } else {
        resolve(null);
      }
    });
  });
};

const handleAddressBlur = async () => {
  if (!form.address || !form.province) return;
  
  const fullAddress = `${form.province}${form.city || ''}${form.district || ''}${form.address}`;
  const result = await geocodeAddress(fullAddress);
  
  if (result) {
    form.longitude = parseFloat(result.lng.toFixed(7));
    form.latitude = parseFloat(result.lat.toFixed(7));
    await nextTick();
    initMap();
    updateMapMarker(result.lng, result.lat);
    message.success('已根据地址获取经纬度');
  }
};

const handleAutoLocation = () => {
  if (typeof AMap === 'undefined') {
    message.error('高德地图加载失败，请刷新页面重试');
    return;
  }
  
  locating.value = true;
  
  AMap.plugin('AMap.Geolocation', () => {
    const geolocation = new AMap.Geolocation({
      enableHighAccuracy: true,
      timeout: 10000,
      maximumAge: 0,
    });
    
    geolocation.getCurrentPosition(async (status: string, result: any) => {
      locating.value = false;
      
      if (status === 'complete') {
        const { lng, lat } = result.position;
        form.longitude = parseFloat(lng.toFixed(7));
        form.latitude = parseFloat(lat.toFixed(7));
        
        if (result.addressComponent) {
          const { province, city, district, street, streetNumber } = result.addressComponent;
          form.province = province || '';
          form.city = city || '';
          form.district = district || '';
          form.address = (street || '') + (streetNumber || '');
          
          if (form.province) {
            form.region = findRegionValue(form.province, form.city, form.district);
          }
        }
        
        await nextTick();
        initMap();
        updateMapMarker(lng, lat);
        message.success('定位成功');
      } else {
        message.error('定位失败，请检查浏览器定位权限');
      }
    });
  });
};

const loadQiniuToken = async () => {
  try {
    const res = await get<any>({ url: '/api/homestay/image/qiniu/token', params: {} });
    if (res && res.data) {
      qiniuUploadData.value.token = res.data.token;
      qiniuDomain.value = res.data.domain;
      if (res.data.uploadUrl) {
        qiniuUploadUrl.value = res.data.uploadUrl;
      }
    }
  } catch (e: any) {
    console.error('获取七牛云token失败', e);
  }
};

const beforeQiniuUpload = async (file: File) => {
  const isImage = file.type.startsWith('image/');
  if (!isImage) {
    message.error('只能上传图片文件');
    return false;
  }
  if (!qiniuUploadData.value.token) {
    await loadQiniuToken();
  }
  const key = `homestay/${Date.now()}_${Math.random().toString(36).substr(2, 9)}.${file.name.split('.').pop()}`;
  qiniuUploadData.value.key = key;
  uploading.value = true;
  return true;
};

const handleQiniuUploadChange = ({ fileList: newFileList, file }: any) => {
  fileList.value = newFileList;
  if (file && file.status === 'done' && file.response) {
    uploading.value = false;
    if (file.response && file.response.key) {
      const domain = qiniuDomain.value || 'https://js.ccnccn.cn/';
      const url = domain + file.response.key;
      form.coverImage = url;
      fileList.value = [{
        uid: file.uid,
        name: file.name,
        status: 'done',
        url: url,
      }];
      message.success('封面上传成功');
    } else {
      message.error('上传失败');
    }
  } else if (file && file.status === 'error') {
    uploading.value = false;
    message.error('上传失败，请重试');
  }
};

const handlePreview = async (file: any) => {
  previewImage.value = file.url || file.thumbUrl;
  previewVisible.value = true;
};

const handleSubmit = async () => {
  submitting.value = true;
  try {
    const payload = { ...form };
    delete (payload as any).region;
    
    if (isEdit.value && form.id) {
      await updateApi(payload);
      message.success('更新成功');
    } else {
      await createApi(payload);
      message.success('创建成功，等待审核');
    }
    router.push({ name: 'landlordHomestay' });
  } catch (e: any) {
    message.error(e.message || '操作失败');
  } finally {
    submitting.value = false;
  }
};

const handleCancel = () => {
  router.push({ name: 'landlordHomestay' });
};

const findRegionValue = (province: string, city: string, district: string): string[] => {
  const result: string[] = [];
  const provinces = REGION_DATA['86'] || {};
  for (const [code, name] of Object.entries(provinces)) {
    if (name === province) {
      result.push(code);
      const cities = REGION_DATA[code] || {};
      for (const [cityCode, cityName] of Object.entries(cities)) {
        if (cityName === city) {
          result.push(cityCode);
          const districts = REGION_DATA[cityCode] || {};
          for (const [distCode, distName] of Object.entries(districts)) {
            if (distName === district) {
              result.push(distCode);
              break;
            }
          }
          break;
        }
      }
      break;
    }
  }
  return result;
};

const loadDetail = async (id: number) => {
  try {
    const res = await detailApi(id);
    if (res.data) {
      Object.assign(form, res.data);
      if (form.coverImage) {
        fileList.value = [{ uid: '-1', name: 'cover', url: form.coverImage }];
      }
      if (form.province) {
        form.region = findRegionValue(form.province, form.city, form.district);
      }
      if (form.longitude && form.latitude) {
        await nextTick();
        initMap();
      }
    }
  } catch (e: any) {
    message.error(e.message || '加载失败');
  }
};

const loadAMapScript = (): Promise<void> => {
  return new Promise((resolve, reject) => {
    if (typeof AMap !== 'undefined') {
      resolve();
      return;
    }
    
    (window as any)._AMapSecurityConfig = {
      securityJsCode: AMAP_CONFIG.securityJsCode,
    };
    
    AMapLoader.load({
      key: AMAP_CONFIG.key,
      version: AMAP_CONFIG.version,
      plugins: ['AMap.Geocoder', 'AMap.Geolocation'],
    }).then(() => {
      resolve();
    }).catch((e: any) => {
      console.error('高德地图加载失败', e);
      resolve();
    });
  });
};

onMounted(async () => {
  buildRootOptions();
  await loadQiniuToken();
  await loadAMapScript();
  
  const id = route.params.id;
  if (id) {
    isEdit.value = true;
    loadDetail(Number(id));
  } else {
    handleBasePriceChange();
  }
});

onUnmounted(() => {
  if (mapInstance) {
    mapInstance.destroy();
    mapInstance = null;
    markerInstance = null;
    geocoderInstance = null;
  }
});
</script>

<style scoped lang="less">
.page-view {
  padding: 24px;
  background: #f5f7fa;
  min-height: calc(100vh - 64px);
}

.page-header {
  margin-bottom: 24px;
  
  h2 {
    font-size: 24px;
    font-weight: 600;
    color: #1a1a1a;
    margin: 0 0 8px 0;
  }
  
  p {
    color: #666;
    margin: 0;
  }
}

.modern-form {
  max-width: 1200px;
}

.modern-card {
  margin-bottom: 16px;
  border-radius: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  
  :deep(.ant-card-head) {
    border-bottom: 1px solid #f0f0f0;
    padding: 16px 24px;
    
    .ant-card-head-title {
      font-weight: 600;
      font-size: 16px;
    }
  }
  
  :deep(.ant-card-body) {
    padding: 24px;
  }
}

.card-tip {
  font-size: 12px;
  color: #999;
  font-weight: normal;
}

.price-tip {
  font-size: 12px;
  color: #999;
  margin-top: 4px;
}

.upload-wrapper {
  display: flex;
  align-items: center;
  gap: 16px;
}

.upload-btn {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  color: #666;
}

.upload-loading {
  display: flex;
  align-items: center;
  gap: 8px;
  color: #1677ff;
}

.map-preview {
  margin-top: 16px;
  border: 1px solid #e8e8e8;
  border-radius: 8px;
  overflow: hidden;
}

.map-tip {
  padding: 8px 12px;
  background: #f5f5f5;
  font-size: 12px;
  color: #666;
}

.form-actions {
  margin-top: 24px;
  padding: 24px;
  background: white;
  border-radius: 8px;
  display: flex;
  justify-content: center;
  gap: 16px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
}

:deep(.ant-form-item-label > label) {
  font-weight: 500;
  color: #333;
}

:deep(.ant-input), :deep(.ant-select-selector), :deep(.ant-input-number), :deep(.ant-cascader) {
  border-radius: 6px;
}

:deep(.ant-input:hover), :deep(.ant-select-selector:hover), :deep(.ant-input-number:hover) {
  border-color: #40a9ff;
}
</style>
