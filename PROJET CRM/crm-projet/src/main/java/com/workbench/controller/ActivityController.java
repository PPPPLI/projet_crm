package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.ExcelSheet;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.mysql.cj.Session;
import com.settings.domain.User;
import com.settings.service.UserService;
import com.workbench.domain.Activity;
import com.workbench.service.ActivityService;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.*;

@Controller
public class ActivityController {

    @Autowired
    UserService userService;

    @RequestMapping("/workbench/activity/index.do")
    public String index(HttpServletRequest request){
        List<User> resultList = userService.queryAllUsers();
        request.setAttribute("resultList",resultList);
        return "workbench/activity/index";
    }

    @Autowired
    private ActivityService activityService;

    @RequestMapping("/workbench/activity/addActivity.do")
    @ResponseBody
    public Object addActivity(Activity activity, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        activity.setId(UUIDutils.getUUID());
        activity.setCreateTime(TimeFormat.dateToString(new Date()));
        User getUser = (User)session.getAttribute(Constance.SESSION_USER);
        activity.setCreateBy(getUser.getId());

        try {
            int result = activityService.addActivity(activity);

            if (result == 1){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else {

                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/queryActivityByCondition.do")
    @ResponseBody
    public Object queryActivityByCondition(String owner,String name,String startDate,String endDate,int pageNo,
                                           int pageSize){

        Map<String,Object> map = new HashMap();
        map.put("owner",owner);
        map.put("name",name);
        map.put("startDate",startDate);
        map.put("endDate",endDate);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);

        List<Activity> retList = activityService.queryActivityByCondition(map);
        int retCount = activityService.queryTotalCount(map);

        map.clear();
        map.put("activityList",retList);
        map.put("activityCount",retCount);

        return map;
    }

    @RequestMapping("/workbench/activity/deleteActivitiesById.do")
    @ResponseBody
    public Object deleteActivitiesById(String[] id){

        ReturnObject returnObject = new ReturnObject();
        try {
            int resultDelete = activityService.deleteActivitiesById(id);
            if(resultDelete > 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else {
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){

            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/infoToModify.do")
    @ResponseBody
    public Object infoToModify(String id){
        Activity returnInfo = activityService.infoToModifier(id);
        return returnInfo;
    }

    @RequestMapping("/workbench/activity/modifyActivity.do")
    @ResponseBody
    public Object modifyActivity(Activity activity,HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        activity.setEditTime(TimeFormat.dateToString(new Date()));
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        activity.setEditBy(user.getId());
        Activity activityReturn = null;

        try {
            int resultModify = activityService.modifierInfo(activity);
            activityReturn = activityService.queryDetailInfoById(activity.getId());
            if(resultModify == 1){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else {
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        returnObject.setReturnData(activityReturn);
        return returnObject;
    }

    @RequestMapping("/workbench/activity/exportAllActivities.do")
    public void exportAllActivities(HttpServletResponse response) throws IOException {
        List<String> headRows = new ArrayList<>();
        headRows.add("id");
        headRows.add("owner");
        headRows.add("name");
        headRows.add("startDate");
        headRows.add("endDate");
        headRows.add("cost");
        headRows.add("createTime");
        headRows.add("creatBy");
        headRows.add("editTime");
        headRows.add("editBy");

        List<Activity> allActivities = activityService.queryAllActivities();

        HSSFWorkbook wk = ExcelSheet.createExcelSheet(headRows,allActivities);
        response.setContentType("application/octet-stream;charset=utf-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream os = response.getOutputStream();
        wk.write(os);

        os.flush();
        wk.close();
    }

    @RequestMapping("/workbench/activity/exportActivitiesById.do")
    public void exportActivitiesById(HttpServletResponse response,String[] id) throws IOException {
        List<String> headRows = new ArrayList<>();

        headRows.add("id");
        headRows.add("owner");
        headRows.add("name");
        headRows.add("startDate");
        headRows.add("endDate");
        headRows.add("cost");
        headRows.add("createTime");
        headRows.add("creatBy");
        headRows.add("editTime");
        headRows.add("editBy");

        List<Activity> allActivities = activityService.queryActivitiesById(id);

        HSSFWorkbook wk = ExcelSheet.createExcelSheet(headRows,allActivities);
        response.setContentType("application/octet-stream;charset=utf-8");
        response.addHeader("Content-Disposition","attachment;filename=activityList.xls");
        OutputStream os = response.getOutputStream();
        wk.write(os);

        os.flush();
        wk.close();
    }

    @RequestMapping("/workbench/activity/addActivityByImport.do")
    @ResponseBody
    public Object addActivityByImport(MultipartFile activityFile,HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        List<Activity> list = new ArrayList<>();
        Activity activity = null;
        try {
            HSSFRow row = null;
            HSSFCell cell = null;
            HSSFWorkbook wb = new HSSFWorkbook(activityFile.getInputStream());
            HSSFSheet sheet = wb.getSheetAt(0);
            for(int i = 1;i<=sheet.getLastRowNum();i++){

                activity = new Activity();
                row = sheet.getRow(i);
                activity.setId(UUIDutils.getUUID());
                User user = (User) session.getAttribute(Constance.SESSION_USER);
                activity.setOwner(user.getId());
                activity.setCreateTime(TimeFormat.dateToString(new Date()));
                activity.setCreateBy(user.getId());
                for (int k = 0; k<row.getLastCellNum();k++){

                    cell = row.getCell(k);
                    if(k == 0){
                        activity.setName(ExcelSheet.parseExcelToString(cell));
                    }else if(k == 1){
                        activity.setStartDate(ExcelSheet.parseExcelToString(cell));
                    }else if(k == 2){
                        activity.setEndDate(ExcelSheet.parseExcelToString(cell));
                    }else if(k == 3){
                        activity.setCost(ExcelSheet.parseExcelToString(cell));
                    }else if (k == 4){
                        activity.setDescription(ExcelSheet.parseExcelToString(cell));
                    }
                }
                list.add(activity);

            };
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            int insertResult =activityService.addActivityByImport(list);
            if(insertResult > 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
                String returnMessage = (insertResult == 1? "activity been registered":"activities has been registered");
                returnObject.setMessage(insertResult + returnMessage);
            }else {
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/clue/queryAllActivities.do")
    @ResponseBody
    public Object queryAllActivities(){

        List<Activity> activities = activityService.queryAllActivities();
        return activities;
    }

    @RequestMapping("/workbench/clue/queryActivityByName.do")
    @ResponseBody
    public Object queryActivityByName(String name){

        List<Activity> activities = activityService.queryActivityByName(name);
        return  activities;
    }
}
