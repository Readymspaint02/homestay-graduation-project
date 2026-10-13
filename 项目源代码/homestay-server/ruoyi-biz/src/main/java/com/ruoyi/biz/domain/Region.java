package com.ruoyi.biz.domain;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.OrderBy;
import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import com.ruoyi.common.annotation.Excel;

import java.io.Serializable;

/**
 * Region entity for table biz_region.
 */
@TableName("biz_region")
public class Region implements Serializable {

    private static final long serialVersionUID = 1L;

    @TableId(type = IdType.AUTO)
    @OrderBy(asc = true, sort = 1)
    private String id;

    @Excel(name = "parent_code")
    @TableField("parent_id")
    private String parentId;

    @Excel(name = "name")
    @TableField("name")
    private String name;

    @Excel(name = "level")
    @TableField("level")
    private Integer level;

    @Excel(name = "upper_case")
    @TableField("upper_case")
    private String upperCase;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getParentId() {
        return parentId;
    }

    public void setParentId(String parentId) {
        this.parentId = parentId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public String getUpperCase() {
        return upperCase;
    }

    public void setUpperCase(String upperCase) {
        this.upperCase = upperCase;
    }
}
