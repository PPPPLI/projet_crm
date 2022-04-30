package com.workbench.service;

import com.workbench.domain.Activity;
import com.workbench.domain.Chart;

import java.util.List;
import java.util.Map;

public interface ActivityService {

    int addActivity(Activity activity);


    List<Activity> queryActivityByCondition(Map map);

    int queryTotalCount(Map map);

    int deleteActivitiesById(String[] id);

    Activity infoToModifier(String id);

    int modifierInfo(Activity activity);

    List<Activity> queryAllActivities();

    List<Activity> queryActivitiesById(String[] id);

    int addActivityByImport(List<Activity> activities);

    Activity queryDetailInfoById(String id);

    int deleteActivityById(String id);

    List<Activity> queryActivityByName(String name);

    List<Chart> queryActivityForChart();
}
