package com.workbench.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.common.utils.UUIDutils;
import com.settings.domain.DicValue;
import com.settings.domain.User;
import com.settings.service.DicValueService;
import com.settings.service.UserService;
import com.workbench.domain.Contacts;
import com.workbench.domain.ContactsRemark;
import com.workbench.domain.Customer;
import com.workbench.domain.Tran;
import com.workbench.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
public class ContactController {

    @Autowired
    UserService userService;
    @Autowired
    DicValueService dicValueService;
    @Autowired
    ContactsService contactsService;
    @Autowired
    CustomerService customerService;
    @Autowired
    ContactRemarkService contactRemarkService;
    @Autowired
    TranService tranService;


    @RequestMapping("/workbench/contacts/index.do")
    public String contactsIndex(HttpServletRequest request){

        List<User> users = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<Customer> customerList = customerService.queryAllCustomer();


        request.setAttribute("users",users);
        request.setAttribute("source",sourceList);
        request.setAttribute("appellation",appellationList);
        request.setAttribute("customerList",customerList);

        return "workbench/contacts/index";
    }

    @RequestMapping("/workbench/contacts/queryContactList.do")
    @ResponseBody
    public Object queryContactList(String owner,String birth,String source,String customerId,String fullName,int pageNo, int pageSize){

        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("birth",birth);
        map.put("source",source);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        map.put("customerId",customerId);
        map.put("fullName",fullName);

        List<Contacts> contactsList = contactsService.queryContactByCondition(map);
        int countResult = contactsService.queryCountByCondition(map);

        map.clear();
        map.put("contactsList",contactsList);
        map.put("countResult",countResult);

        return map;

    }

    @RequestMapping("/workbench/contacts/insertContact.do")
    @ResponseBody
    public Object insertContact(Contacts contacts, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);

        contacts.setId(UUIDutils.getUUID());
        contacts.setCreateBy(user.getId());
        contacts.setCreateTime(TimeFormat.dateToString(new Date()));
        contacts.setEditBy(user.getId());
        contacts.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int addResult = contactsService.addContact(contacts);
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

        Contacts contacts1 = contactsService.queryContactById(contacts.getId());
        returnObject.setReturnData(contacts1);
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactById.do")
    @ResponseBody
    public Object queryContactById(String id){

        Contacts contacts = contactsService.queryOriginalContact(id);
        return contacts;
    }

    @RequestMapping("/workbench/contacts/updateContactById.do")
    @ResponseBody
    public Object updateContactById(Contacts contacts,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user =(User) session.getAttribute(Constance.SESSION_USER);

        contacts.setEditTime(TimeFormat.dateToString(new Date()));
        contacts.setEditBy(user.getId());

        try {
           int updateResult =  contactsService.updateContactById(contacts);
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

        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteContactByIds.do")
    @ResponseBody
    public Object deleteContactByIds(String[] id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = contactsService.deleteContactByIds(id);
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

    @RequestMapping("/workbench/contacts/toDetailPage.do")
    public String toDetailPage(String id,HttpServletRequest request){

        Contacts contacts = contactsService.queryContactById(id);
        List<ContactsRemark> contactsRemarkList = contactRemarkService.queryContactRemarkByContactId(id);
        List<User> users = userService.queryAllUsers();
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<Customer> customerList = customerService.queryAllCustomer();
        List<Tran> tranList = tranService.queryTransByContactId(id);

        request.setAttribute("users",users);
        request.setAttribute("source",sourceList);
        request.setAttribute("appellation",appellationList);
        request.setAttribute("contacts",contacts);
        request.setAttribute("contactsRemarkList",contactsRemarkList);
        request.setAttribute("customerList",customerList);
        request.setAttribute("tranList",tranList);

        return "workbench/contacts/detail";
    }

    @RequestMapping("/workbench/contacts/addRemark.do")
    @ResponseBody
    public Object addRemark(ContactsRemark contactsRemark,HttpSession session){
        User user =(User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        contactsRemark.setEditFlag("0");
        contactsRemark.setCreateTime(TimeFormat.dateToString(new Date()));
        contactsRemark.setId(UUIDutils.getUUID());
        contactsRemark.setCreateBy(user.getId());
        contactsRemark.setEditBy(user.getId());
        contactsRemark.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int addResult =contactRemarkService.addRemarkByContactId(contactsRemark);
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
        ContactsRemark contactsRemark1 = contactRemarkService.queryContactRemarkById(contactsRemark.getId());
        returnObject.setReturnData(contactsRemark1);
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/deleteRemarkById.do")
    @ResponseBody
    public Object deleteRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = contactRemarkService.deleteRemarkById(id);
            if(deleteResult == 1){
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

    @RequestMapping("/workbench/contacts/updateRemarkById.do")
    @ResponseBody
    public Object updateRemarkById(ContactsRemark contactsRemark,HttpSession session){
        User user =(User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        contactsRemark.setEditTime(TimeFormat.dateToString(new Date()));
        contactsRemark.setEditBy(user.getId());
        contactsRemark.setEditFlag("1");

        try {
            int updateResult = contactRemarkService.updateRemarkById(contactsRemark);
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

        ContactsRemark contactsRemark1 =  contactRemarkService.queryContactRemarkById(contactsRemark.getId());
        returnObject.setReturnData(contactsRemark1);
        return returnObject;
    }

    @RequestMapping("/workbench/contacts/queryContactForModify.do")
    @ResponseBody
    public Object queryContactForModify(String id){

        Contacts contacts = contactsService.queryOriginalContact(id);
        return contacts;
    }
}
