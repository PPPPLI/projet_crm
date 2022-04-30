package com.workbench.mapper;

import com.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {

    //comment info to the page detail
    List<ActivityRemark> selectActivityRemarkById(String id);

    int insertActivityRemarkById(ActivityRemark activityRemark);

    int deleteActivityRemark(String id);

    int updateActivityRemark(ActivityRemark activityRemark);

    int deleteAllActivityRemarkByActivity(String id);
}