// 修复分类翻译
const categoryLabelMap = {
  Boutique: '精品民宿',
  SeaView: '海景房',
  Apartment: '公寓整租'
}

const tagLabelMap = {
  NearMetro: '近地铁',
  Kitchen: '可做饭',
  Parking: '可停车'
}

// 修复图片路径
const resolveCover = (cover) => {
  if (!cover) return '/images/demo.jpg'
  if (cover.startsWith('http://') || cover.startsWith('https://') || cover.startsWith('/')) {
    return cover
  }
  // 如果是相对路径，添加后端 API 地址
  return BASE_URL + '/' + cover
}
