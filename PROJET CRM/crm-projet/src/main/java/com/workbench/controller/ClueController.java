package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.DicValue;
import com.settings.domain.User;
import com.settings.service.DicValueService;
import com.settings.service.UserService;
import com.workbench.domain.Clue;
import com.workbench.service.ClueService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class ClueController {

    @Autowired
    UserService userService;
    @Autowired
    DicValueService dicValueService;

    @Autowired
    ClueService clueService;

    //Jump to the clue main page
    @RequestMapping("/workbench/clue/index.do")
    public String index(HttpServletRequest request){

        List<User> users = userService.queryAllUsers();
        List<DicValue> dicValuesAppellation = dicValueService.queryDicValueByTypeCode("appellation");
        List<DicValue> dicValueSource = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> dicValueClueState = dicValueService.queryDicValueByTypeCode("clueState");
        request.setAttribute("users",users);
        request.setAttribute("dicValuesAppellation",dicValuesAppellation);
        request.setAttribute("dicValueSource",dicValueSource);
        request.setAttribute("dicValueClueState",dicValueClueState);
        return "workbench/clue/index";
    }

    @RequestMapping("/workbench/clue/addClue.do")
    @ResponseBody
    public Object addClue(Clue clue, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        clue.setId(UUIDutils.getUUID());
        clue.setCreateBy(user.getId());
        clue.setCreateTime(TimeFormat.dateToString(new Date()));
        clue.setEditBy(user.getId());
        clue.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int addResult = clueService.addClue(clue);
            if(addResult != 0){
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

    @RequestMapping("/workbench/clue/getClueListToPage.do")
    @ResponseBody
    public Object getClueListToPage(String fullName,String company,String phone,String mPhone,String source,
                                    String state,String owner,int pageNo,int pageSize){

        Map<String,Object> map = new HashMap<>();
        map.put("fullName",fullName);
        map.put("company",company);
        map.put("phone",phone);
        map.put("mPhone",mPhone);
        map.put("source",source);
        map.put("state",state);
        map.put("owner",owner);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);


        int countResult = clueService.clueCount(map);
        List<Clue> clueList = clueService.queryClueByCondition(map);

        map.clear();
        map.put("countResult",countResult);
        map.put("clueList",clueList);

        return map;
    }

    @RequestMapping("/workbench/clue/getClueById.do")
    @ResponseBody
    public Object getClueById(String id){

        Clue clueResult = clueService.queryOneClueById(id);
        return clueResult;
    }

    @RequestMapping("/workbench/clue/modifyClue.do")
    @ResponseBody
    public Object modifyClue(Clue clue, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        clue.setEditTime(TimeFormat.dateToString(new Date()));
        clue.setEditBy(user.getId());

        try {
            int updateResult = clueService.updateClueById(clue);
            if(updateResult == 1){
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
        Clue clueResult = clueService.queryClueById(clue.getId());
        returnObject.setReturnData(clueResult);
        return returnObject;
    }

    @RequestMapping("/workbench/clue/deleteClue.do")
    @ResponseBody
    public Object deleteClue(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = clueService.deleteClueById(id);
            if(deleteResult != 0){
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

    //jump to the transfer page
    @RequestMapping("/workbench/clue/toTransferPage.do")
    public String toTransferPage(String id,HttpServletRequest request){

        Clue clue = clueService.queryClueById(id);
        request.setAttribute("clue",clue);
        List<DicValue> dicValues = dicValueService.queryDicValueByTypeCode("stage");
        request.setAttribute("dicValues",dicValues);
        return "workbench/clue/convert";
    }
}
