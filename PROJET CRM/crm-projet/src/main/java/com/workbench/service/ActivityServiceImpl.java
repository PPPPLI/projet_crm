package com.workbench.service;

import com.workbench.domain.Activity;
import com.workbench.domain.Chart;
import com.workbench.mapper.ActivityMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service
public class ActivityServiceImpl implements ActivityService {

    @Autowired
    private ActivityMapper activityMapper;

    @Override
    public int addActivity(Activity activity) {

        int result = activityMapper.insertActivity(activity);
        return result;
    }


    @Override
    public List<Activity> queryActivityByCondition(Map map) {

        List<Activity> activities = activityMapper.selectActivityByConditionForPage(map);
        return activities;
    }

    @Override
    public int queryTotalCount(Map map) {

        int totalActivity = activityMapper.selectTotalCount(map);
        return totalActivity;
    }

    @Override
    public int deleteActivitiesById(String[] id) {
        int deleteCount = activityMapper.deleteActivitiesById(id);
        return deleteCount;
    }

    @Override
    public Activity infoToModifier(String id) {

        Activity returnInfo = activityMapper.infoToModifier(id);
        return returnInfo;
    }

    @Override
    public int modifierInfo(Activity activity) {
        int returnCount = activityMapper.updateActivity(activity);
        return returnCount;
    }

    @Override
    public List<Activity> queryAllActivities() {
        List<Activity> allActivities = activityMapper.selectAllActivities();
        return allActivities;
    }

    @Override
    public List<Activity> queryActivitiesById(String[] id) {
        List<Activity> selectedActivities = activityMapper.selectActivitiesById(id);
        return selectedActivities;
    }

    @Override
    public int addActivityByImport(List<Activity> activities) {
        int addResult = activityMapper.insertActivityByImport(activities);
        return addResult;
    }

    @Override
    public Activity queryDetailInfoById(String id) {
        Activity DetailInfo = activityMapper.allInfoToDetail(id);
        return DetailInfo;
    }

    @Override
    public int deleteActivityById(String id) {
        int deleteResult = activityMapper.deleteActivityById(id);
        return deleteResult;
    }

    @Override
    public List<Activity> queryActivityByName(String name) {
        List<Activity> activities = activityMapper.selectActivityByName(name);
        return activities;
    }

    @Override
    public List<Chart> queryActivityForChart() {
        List<Chart> chartList = activityMapper.selectActivityName();
        return chartList;
    }
}
