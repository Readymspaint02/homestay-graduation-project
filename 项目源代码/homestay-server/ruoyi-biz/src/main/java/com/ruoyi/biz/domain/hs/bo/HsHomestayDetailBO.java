package com.ruoyi.biz.domain.hs.bo;

import com.ruoyi.biz.domain.hs.HsHomestay;
import com.ruoyi.biz.domain.hs.HsHomestayFacility;
import com.ruoyi.biz.domain.hs.HsHomestayImage;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serial;
import java.util.List;

/**
 * 房源详情 BO - 包含基本信息、设施、图片
 * 
 * 优化点：
 * 1. 独立类文件，便于序列化缓存
 * 2. 使用 Lombok 减少样板代码
 */
@Data
@EqualsAndHashCode(callSuper = true)
public class HsHomestayDetailBO extends HsHomestay {

    @Serial
    private static final long serialVersionUID = 1L;

    private List<HsHomestayFacility> facilities;
    
    private List<HsHomestayImage> images;
    
    private String landlordName;
}
