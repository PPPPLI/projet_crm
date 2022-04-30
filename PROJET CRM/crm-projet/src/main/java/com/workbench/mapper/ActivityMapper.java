package com.workbench.mapper;

import com.workbench.domain.Activity;
import com.workbench.domain.Chart;

import java.util.List;
import java.util.Map;

public interface ActivityMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    int insert(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    int insertSelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    Activity selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    int updateByPrimaryKeySelective(Activity record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_activity
     *
     * @mbggenerated Mon Apr 18 11:08:57 CEST 2022
     */
    int updateByPrimaryKey(Activity record);

    int insertActivity(Activity activity);

    List<Activity> selectActivityByConditionForPage(Map<String,Object> map);

    int selectTotalCount(Map<String,Object> map);

    int deleteActivitiesById(String[] id);

    Activity infoToModifier(String id);

    int updateActivity(Activity activity);

    List<Activity> selectAllActivities();

    List<Activity> selectActivitiesById(String[] id);

    int insertActivityByImport(List<Activity> activities);

    Activity allInfoToDetail(String id);

    int deleteActivityById(String id);

    List<Activity> selectActivityByName(String name);

    List<Chart> selectActivityName();
}