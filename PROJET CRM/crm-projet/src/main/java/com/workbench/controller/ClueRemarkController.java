package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.DicValue;
import com.settings.domain.User;
import com.settings.service.DicValueService;
import com.settings.service.UserService;
import com.workbench.domain.Activity;
import com.workbench.domain.Clue;
import com.workbench.domain.ClueActivityRelation;
import com.workbench.domain.ClueRemark;
import com.workbench.service.ClueActivityRelationService;
import com.workbench.service.ClueRemarkService;
import com.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueRemarkController {

    @Autowired
    ClueService clueService;
    @Autowired
    ClueRemarkService clueRemarkService;
    @Autowired
    UserService userService;
    @Autowired
    DicValueService dicValueService;
    @Autowired
    ClueActivityRelationService clueActivityRelationService;

    @RequestMapping("/workbench/clue/detail.do")
    public String getToDetailPage(String id, HttpServletRequest request) {

        List<ClueRemark> clueRemarks = clueRemarkService.queryClueRemarkById(id);
        Clue clue = clueService.queryClueById(id);
        request.setAttribute("clueRemarks", clueRemarks);
        request.setAttribute("clue", clue);
        List<User> users = userService.queryAllUsers();
        List<Activity> activities = clueService.queryActivityByRelation(id);
        List<DicValue> dicValuesAppellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> dicValueClueState = dicValueService.queryDicValueByTypeCode("clueState");
        request.setAttribute("users",users);
        request.setAttribute("dicValuesAppellation",dicValuesAppellation);
        request.setAttribute("dicValueSource",dicValueSource);
        request.setAttribute("dicValueClueState",dicValueClueState);
        request.setAttribute("activities",activities);

        return "workbench/clue/detail";
    }

    @RequestMapping("/workbench/clue/addClueRemark.do")
    @ResponseBody
    public Object addClueRemark(ClueRemark clueRemark, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        clueRemark.setId(UUIDutils.getUUID());
        clueRemark.setCreateBy(user.getId());
        clueRemark.setCreateTime(TimeFormat.dateToString(new Date()));
        clueRemark.setEditBy(user.getId());
        clueRemark.setEditFlag("0");
        clueRemark.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int insertResult = clueRemarkService.insertClueRemark(clueRemark);
            if(insertResult == 1){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }
        ClueRemark remarkResult = clueRemarkService.queryClueRemarkByRid(clueRemark.getId());
        returnObject.setReturnData(remarkResult);
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueRemark.do")
    @ResponseBody
    public Object deleteClueRemark(String id){

        ReturnObject returnObject = new ReturnObject();
        try {
           int deleteResult =  clueRemarkService.deleteClueRemarkById(id);
           if(deleteResult == 1){
               returnObject.setReturnCode(Constance.RESULT_SUCCES);
           }else{
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

    @RequestMapping("/workbench/clue/updateClueRemark.do")
    @ResponseBody
    public Object updateClueRemark(ClueRemark clueRemark,HttpSession session){
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        clueRemark.setEditTime(TimeFormat.dateToString(new Date()));
        clueRemark.setEditFlag("1");
        clueRemark.setEditBy(user.getId());

        try {
            int updateResult = clueRemarkService.updateClueRemarkById(clueRemark);
            if(updateResult == 1){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){

            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        returnObject.setReturnData(clueRemark);

        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClueAndRemark.do")
    @ResponseBody
    public Object deleteClueAndRemark(String id){
        ReturnObject returnObject = new ReturnObject();
        try {
           int deleteRemarkResult =  clueRemarkService.deleteClueRemarkByClueId(id);
           int deleteClueResult = clueService.deleteClue(id);
           if(deleteClueResult == 1){
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
        return  returnObject;
    }

    @RequestMapping("/workbench/clue/addRelation.do")
    @ResponseBody
    public Object addRelation(String[] id,String clueId){

        ReturnObject returnObject = new ReturnObject();
        List<ClueActivityRelation> clueActivityRelations = new ArrayList<>();
        for (int i = 0; i < id.length;i++){

            ClueActivityRelation clueActivityRelation = new ClueActivityRelation();
            clueActivityRelation.setId(UUIDutils.getUUID());
            clueActivityRelation.setActivityId(id[i]);
            clueActivityRelation.setClueId(clueId);
            clueActivityRelations.add(clueActivityRelation);
        }
        try {
            int addResult = clueActivityRelationService.addRelations(clueActivityRelations);
            if(addResult > 0){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
                List<Activity> activities = clueService.queryActivityByRelation(clueId);
                returnObject.setReturnData(activities);
            }else{
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

    @RequestMapping("/workbench/clue/deleteRelation.do")
    @ResponseBody
    public Object deleteRelation(ClueActivityRelation clueActivityRelation){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = clueActivityRelationService.deleteRelation(clueActivityRelation);
            if(deleteResult == 1){
                returnObject.setReturnCode(Constance.RESULT_SUCCES);
            }else{
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return  returnObject;
    }

    @RequestMapping("/workbench/clue/transferClue.do")
    @ResponseBody
    public Object transferClue(String isCreate,String expectedDate,String money,String name,String stage,String activityId, String clueId,HttpSession session){

        Map<String,Object> map = new HashMap();
        map.put("isCreate",isCreate);
        map.put("expectedDate",expectedDate);
        map.put("money",money);
        map.put("name",name);
        map.put("stage",stage);
        map.put("activityId",activityId);
        map.put("clueId",clueId);
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        map.put(Constance.SESSION_USER,user);
        ReturnObject returnObject = new ReturnObject();

        try {
            clueService.transferClue(map);
            returnObject.setReturnCode(Constance.RESULT_SUCCES);
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong please try later");
        }

        return returnObject;
    }
}
