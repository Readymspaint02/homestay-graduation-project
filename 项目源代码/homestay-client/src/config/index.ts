/**
 * 应用配置
 */

// 高德地图配置
export const AMAP_CONFIG = {
  // 高德地图 Key（需要在高德开放平台申请）
  // https://console.amap.com/dev/key/app
  key: 'your-amap-key',
  // 安全密钥（在高德控制台设置）
  securityJsCode: 'your-amap-security-code',
  // API版本
  version: '2.0',
};

// 七牛云配置
export const QINIU_CONFIG = {
  // 上传地址
  uploadUrl: 'https://upload.qiniup.com',
  // 默认域名
  defaultDomain: 'https://your-qiniu-domain/',
};
