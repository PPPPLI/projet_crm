package com.workbench.service;

import com.workbench.domain.ActivityRemark;
import com.workbench.domain.Chart;

import java.util.List;

public interface ActivityRemarkService {

    List<ActivityRemark> queryActivityRemarkById(String id);

    int insertActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemark(String id);

    int updateActivityRemark(ActivityRemark activityRemark);

    int deleteActivityRemarkByActivityId(String id);


}
