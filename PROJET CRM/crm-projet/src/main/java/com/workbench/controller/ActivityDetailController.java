package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.User;
import com.settings.service.UserService;
import com.workbench.domain.Activity;
import com.workbench.domain.ActivityRemark;
import com.workbench.service.ActivityRemarkService;
import com.workbench.service.ActivityService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.List;

@Controller
public class ActivityDetailController {

    @Autowired
    ActivityService activityService;
    @Autowired
    ActivityRemarkService activityRemarkService;
    @Autowired
    UserService userService;

    //Detail for the activity detail page
    @RequestMapping("/workbench/activity/detailInfoById.do")
    public String detailInfoById(String id, HttpServletRequest request){

        Activity detailActivityResult = activityService.queryDetailInfoById(id);
        List<ActivityRemark> listDetailRemarkResult = activityRemarkService.queryActivityRemarkById(id);
        List<User> ids = userService.queryAllUsers();

        request.setAttribute("detailActivityResult",detailActivityResult);
        request.setAttribute("detailRemarkResult",listDetailRemarkResult);
        request.setAttribute("ids",ids);
        return "workbench/activity/detail";
    }

    //Insert the activity remark
    @RequestMapping("/workbench/activity/insertActivityRemark.do")
    @ResponseBody
    public Object insertActivityRemark(String noteContent, String id, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setNoteContent(noteContent);
        activityRemark.setActivityId(id);
        activityRemark.setCreateTime(TimeFormat.dateToString(new Date()));
        activityRemark.setEditTime(TimeFormat.dateToString(new Date()));
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        activityRemark.setCreateBy(user.getId());
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag("0");
        activityRemark.setId(UUIDutils.getUUID());

        try {
            int insertResult = activityRemarkService.insertActivityRemark(activityRemark);
            if(insertResult != 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){

            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        returnObject.setReturnData(activityRemark);
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityRemark.do")
    @ResponseBody
    public Object deleteActivityRemark(String id){

        ReturnObject returnObject = new ReturnObject();
        try {
            int deleteResult = activityRemarkService.deleteActivityRemark(id);
            if(deleteResult != 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return returnObject;
    }

    @RequestMapping("/workbench/activity/updateActivityRemark.do")
    @ResponseBody
    public Object updateActivityRemark(String noteContent,String id,HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        ActivityRemark activityRemark = new ActivityRemark();
        activityRemark.setNoteContent(noteContent);
        activityRemark.setId(id);
        activityRemark.setEditTime(TimeFormat.dateToString(new Date()));
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        activityRemark.setEditBy(user.getId());
        activityRemark.setEditFlag("1");

        try {
            int resultUpdateActivityRemark = activityRemarkService.updateActivityRemark(activityRemark);
            if (resultUpdateActivityRemark != 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }
        returnObject.setReturnData(activityRemark);
        return returnObject;
    }

    @RequestMapping("/workbench/activity/deleteActivityAndRemark.do")
    @ResponseBody
    public Object deleteActivityAndRemark(String id){

        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteRemarkResult = activityRemarkService.deleteActivityRemarkByActivityId(id);
            int deleteActivityResult = activityService.deleteActivityById(id);

            if(deleteActivityResult != 0 || deleteRemarkResult !=0){

                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }
        return returnObject;
    }
}
