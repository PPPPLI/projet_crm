package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.DicValue;
import com.settings.domain.User;
import com.settings.service.DicValueService;
import com.settings.service.UserService;
import com.workbench.domain.*;
import com.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
public class TransactionController {

    @Autowired
    DicValueService dicValueService;
    @Autowired
    TranService tranService;
    @Autowired
    UserService userService;
    @Autowired
    ContactsService contactsService;
    @Autowired
    CustomerService customerService;
    @Autowired
    ActivityService activityService;
    @Autowired
    TranRemarkService tranRemarkService;
    @Autowired
    TranHistoryService tranHistoryService;

    @RequestMapping("/workbench/transaction/index.do")
    public String tranIndex(HttpServletRequest request){
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        request.setAttribute("sourceList",sourceList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("stageList",stageList);
        return "workbench/transaction/index";
    }

    @RequestMapping("/workbench/transaction/queryTransListByCondition.do")
    @ResponseBody
    public Object queryTransListByCondition(String contactsId,String source,String type,String stage,String customerId,String name,
                                            String owner,int pageNo,int pageSize){

        Map<String,Object> map = new HashMap<>();
        map.put("contactsId",contactsId);
        map.put("source",source);
        map.put("type",type);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        map.put("stage",stage);
        map.put("customerId",customerId);
        map.put("name",name);
        map.put("owner",owner);

        List<Tran> tranList = tranService.queryTransByCondition(map);
        int tranCount = tranService.queryCount(map);

        map.clear();
        map.put("tranList",tranList);
        map.put("tranCount",tranCount);
        return map;

    }

    @RequestMapping("/workbench/transaction/toCreatePage.do")
    public String toCreatePage(HttpServletRequest request){

        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<User> userList = userService.queryAllUsers();


        request.setAttribute("sourceList",sourceList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("userList",userList);

        return "workbench/transaction/save";
    }

    @RequestMapping("/workbench/transaction/toModifyPage.do")
    public String toModifyPage(HttpServletRequest request,String id){

        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> typeList = dicValueService.queryDicValueByTypeCode("transactionType");
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");
        List<User> userList = userService.queryAllUsers();
        Tran tran = tranService.queryTranByTranId(id);
        Customer customer = customerService.queryCustomerDetailById(tran.getCustomerId());
        Contacts contacts = contactsService.queryContactById(tran.getContactsId());
        Activity activity = activityService.queryDetailInfoById(tran.getActivityId());

        request.setAttribute("sourceList",sourceList);
        request.setAttribute("typeList",typeList);
        request.setAttribute("stageList",stageList);
        request.setAttribute("userList",userList);
        request.setAttribute("tran",tran);
        request.setAttribute("customer",customer);
        request.setAttribute("contacts",contacts);
        request.setAttribute("activity",activity);

        return "workbench/transaction/edit";
    }

    @RequestMapping("/workbench/transaction/queryContactForTrans.do")
    @ResponseBody
    public Object queryContactForTrans(String customerId){

       List<Contacts> contactsList =  contactsService.queryForTransSearch(customerId);
       return  contactsList;
    }

    @RequestMapping("/workbench/transaction/getPossibilityByStage.do")
    @ResponseBody
    public Object getPossibilityByStage(String stageValue){

        ResourceBundle rb = ResourceBundle.getBundle("possibility");
        stageValue = stageValue.replaceAll(" ","");
        String possibility = rb.getString(stageValue);
        return possibility;
    }

    @RequestMapping("/workbench/transaction/queryCustomerNameByName.do")
    @ResponseBody
    public Object queryCustomerNameByName(){

        List<Customer> customerList = customerService.queryCustomerNameByName();
        return customerList;
    }

    @RequestMapping("/workbench/transaction/queryCustomerIdByName.do")
    @ResponseBody
    public Object queryCustomerIdByName(String customerName){
        Customer customer = customerService.queryCustomerByName(customerName);
        return customer;
    }

    @RequestMapping("/workbench/transaction/addTran.do")
    @ResponseBody
    public Object addTran(Tran tran, HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);

        tran.setCreateTime(TimeFormat.dateToString(new Date()));
        tran.setCreateBy(user.getId());
        tran.setEditTime(TimeFormat.dateToString(new Date()));
        tran.setEditBy(user.getId());
        tran.setId(UUIDutils.getUUID());

        try {
            int addResult = tranService.addTran(tran);
            if(addResult == 1){
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

    @RequestMapping("/workbench/transaction/updateTran.do")
    @ResponseBody
    public Object updateTran(Tran tran,HttpSession session){
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        tran.setEditBy(user.getId());
        tran.setEditTime(TimeFormat.dateToString(new Date()));
        Map<String,Object> map = new HashMap<>();
        map.put("user",user);
        map.put("tran",tran);

        try {
            int updateResult = tranService.updateTran(map);
            if(updateResult == 2){
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

    @RequestMapping("/workbench/transaction/deleteTranById.do")
    @ResponseBody
    public Object deleteTranById(String id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = tranService.deleteTran(id);
            if(deleteResult > 0){
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

    @RequestMapping("/workbench/transaction/toDetailPage.do")
    public String toDetailPage(String id,HttpServletRequest request){
        Tran tranList = tranService.queryTranForDetail(id);
        List<TranRemark> tranRemarkList = tranRemarkService.queryRemarkByTranId(id);
        List<TranHistory> historyList = tranHistoryService.queryAllHistoryByTranId(id);
        List<DicValue> stageList = dicValueService.queryDicValueByTypeCode("stage");

        request.setAttribute("tran",tranList);
        request.setAttribute("remarkList",tranRemarkList);
        request.setAttribute("historyList",historyList);
        request.setAttribute("stageList",stageList);

        return "workbench/transaction/detail";
    }
}
