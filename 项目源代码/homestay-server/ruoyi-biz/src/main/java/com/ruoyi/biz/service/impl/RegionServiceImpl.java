package com.ruoyi.biz.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.ruoyi.biz.domain.Region;
import com.ruoyi.biz.mapper.RegionMapper;
import com.ruoyi.biz.service.IRegionService;
import com.ruoyi.common.exception.ServiceException;
import com.ruoyi.common.utils.StringUtils;
import com.ruoyi.common.utils.bean.BeanValidators;
import jakarta.validation.Validator;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.List;

/**
 * Region service implementation.
 */
@Service
@RequiredArgsConstructor
public class RegionServiceImpl extends ServiceImpl<RegionMapper, Region> implements IRegionService {

    private static final Logger log = LoggerFactory.getLogger(RegionServiceImpl.class);

    private final RegionMapper regionMapper;
    private final Validator validator;

    @Override
    public String importRegion(List<Region> list, int titleNum, Boolean isUpdateSupport, String operName) {
        if (list == null || list.isEmpty()) {
            throw new ServiceException("import data cannot be empty");
        }

        int successNum = 0;
        int failureNum = 0;
        StringBuilder successMsg = new StringBuilder();
        StringBuilder failureMsg = new StringBuilder();

        for (int i = 0; i < list.size(); i++) {
            Region region = list.get(i);
            int excelRow = i + titleNum + 2;
            try {
                BeanValidators.validateWithException(validator, region);
                Region exists = regionMapper.selectById(region.getId());
                if (exists == null) {
                    insertRegion(region);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append(" row ").append(excelRow)
                        .append(" id=").append(region.getId()).append(" import success");
                } else if (Boolean.TRUE.equals(isUpdateSupport)) {
                    updateRegion(region);
                    successNum++;
                    successMsg.append("<br/>").append(successNum).append(" row ").append(excelRow)
                        .append(" id=").append(region.getId()).append(" update success");
                } else {
                    failureNum++;
                    failureMsg.append("<br/>").append(failureNum).append(" row ").append(excelRow)
                        .append(" id=").append(region.getId()).append(" already exists");
                }
            } catch (Exception e) {
                failureNum++;
                String msg = "<br/>" + failureNum + " row " + excelRow + " id=" + region.getId() + " import failed";
                failureMsg.append(msg).append(": ").append(e.getMessage());
                log.error(msg, e);
            }
        }

        if (failureNum > 0) {
            failureMsg.insert(0, "Import failed, total failures: " + failureNum + ". ");
            throw new ServiceException(failureMsg.toString());
        }
        successMsg.insert(0, "Import success, total: " + successNum + ". ");
        return successMsg.toString();
    }

    @Override
    public IPage<Region> pageRegion(Page<Region> page, QueryWrapper<Region> queryWrapper) {
        return regionMapper.selectPage(page, queryWrapper);
    }

    @Override
    public String idsToNames(String ids) {
        if (StringUtils.isEmpty(ids)) {
            return null;
        }
        String[] regionIds = StringUtils.split(ids, ",");
        String[] regionNames = new String[regionIds.length];
        for (int i = 0; i < regionIds.length; i++) {
            Region region = this.getById(regionIds[i]);
            if (region != null) {
                regionNames[i] = region.getName();
            }
        }
        return StringUtils.join(regionNames, "/");
    }

    @Override
    public String namesToIds(String names) {
        if (StringUtils.isEmpty(names)) {
            return null;
        }
        String[] regionNames = StringUtils.split(names, "/");
        String[] regionIds = new String[regionNames.length];
        for (int i = 0; i < regionNames.length; i++) {
            QueryWrapper<Region> queryWrapper = new QueryWrapper<>();
            queryWrapper.eq("level", i + 1);
            queryWrapper.like("name", regionNames[i]);
            if (i > 0) {
                queryWrapper.eq("parent_id", regionIds[i - 1]);
            }
            Region region = regionMapper.selectOne(queryWrapper);
            if (region != null) {
                regionIds[i] = region.getId();
            } else {
                return null;
            }
        }
        return StringUtils.join(regionIds, ",");
    }

    @Override
    public Region selectRegionById(String id) {
        return regionMapper.selectById(id);
    }

    @Override
    public List<Region> selectRegionList(Region region) {
        return regionMapper.selectRegionList(region);
    }

    @Override
    public int insertRegion(Region region) {
        return regionMapper.insert(region);
    }

    @Override
    public int updateRegion(Region region) {
        return regionMapper.updateById(region);
    }

    @Override
    public int deleteRegionByIds(String[] ids) {
        return regionMapper.deleteByIds(Arrays.asList(ids));
    }

    @Override
    public int deleteRegionById(String id) {
        return regionMapper.deleteById(id);
    }
}
