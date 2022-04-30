package com.workbench.service;

import com.workbench.domain.ActivityRemark;
import com.workbench.domain.Chart;
import com.workbench.mapper.ActivityMapper;
import com.workbench.mapper.ActivityRemarkMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class ActivityRemarkServiceImpl implements ActivityRemarkService {

    @Autowired
    ActivityRemarkMapper activityRemarkMapper;

    @Override
    public List<ActivityRemark> queryActivityRemarkById(String id) {

        List<ActivityRemark> activityRemark = activityRemarkMapper.selectActivityRemarkById(id);
        return activityRemark;
    }

    @Override
    public int insertActivityRemark(ActivityRemark activityRemark) {

        int resultInsertActivityRemark = activityRemarkMapper.insertActivityRemarkById(activityRemark);
        return resultInsertActivityRemark;
    }

    @Override
    public int deleteActivityRemark(String id) {

        int resultDeleteActivityRemark = activityRemarkMapper.deleteActivityRemark(id);
        return resultDeleteActivityRemark;
    }

    @Override
    public int updateActivityRemark(ActivityRemark activityRemark) {

        int resultUpdateRemark = activityRemarkMapper.updateActivityRemark(activityRemark);
        return resultUpdateRemark;
    }

    @Override
    public int deleteActivityRemarkByActivityId(String id) {

        int resultDeleteRemarks = activityRemarkMapper.deleteAllActivityRemarkByActivity(id);
        return resultDeleteRemarks;
    }

}
