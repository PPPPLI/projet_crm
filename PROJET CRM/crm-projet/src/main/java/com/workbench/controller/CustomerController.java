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
import com.workbench.domain.Customer;
import com.workbench.domain.CustomerRemark;
import com.workbench.domain.Tran;
import com.workbench.service.ContactsService;
import com.workbench.service.CustomerRemarkService;
import com.workbench.service.CustomerService;
import com.workbench.service.TranService;
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
public class CustomerController {

    @Autowired
    UserService userService;
    @Autowired
    CustomerService customerService;
    @Autowired
    CustomerRemarkService customerRemarkService;
    @Autowired
    TranService tranService;
    @Autowired
    ContactsService contactsService;
    @Autowired
    DicValueService dicValueService;

    @RequestMapping("/workbench/customer/index.do")
    public String customerIndex(HttpServletRequest request){

        List<User> users = userService.queryAllUsers();

        request.setAttribute("users",users);

        return "workbench/customer/index";
    }

    @RequestMapping("workbench/customer/queryCustomerList.do")
    @ResponseBody
    public Object queryCustomerList(String name,String owner,String phone,String website,int pageNo, int pageSize){

        Map<String,Object> map = new HashMap<>();
        map.put("owner",owner);
        map.put("phone",phone);
        map.put("website",website);
        map.put("pageNo",(pageNo-1)*pageSize);
        map.put("pageSize",pageSize);
        map.put("name",name);

        List<Customer> customerList = customerService.queryCustomerByCondition(map);
        int countResult = customerService.queryCountByCondition(map);

        map.clear();
        map.put("customerList",customerList);
        map.put("countResult",countResult);

        return map;

    }

    @RequestMapping("/workbench/customer/addCustomer.do")
    @ResponseBody
    public Object addCustomer(Customer customer, HttpSession session){

        ReturnObject returnObject = new ReturnObject();
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        customer.setId(UUIDutils.getUUID());
        customer.setCreateBy(user.getId());
        customer.setCreateTime(TimeFormat.dateToString(new Date()));
        customer.setEditTime(TimeFormat.dateToString(new Date()));
        customer.setEditBy(user.getId());

        try {
            int addResult = customerService.addCustomer(customer);
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

    @RequestMapping("/workbench/customer/queryCustomerById.do")
    @ResponseBody
    public Object queryCustomerById(String id){

        Customer customer = customerService.queryCustomerById(id);

        return customer;
    }

    @RequestMapping("/workbench/customer/updateCustomerById.do")
    @ResponseBody
    public Object updateCustomerById(Customer customer,HttpSession session){

        User user = (User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();
        customer.setEditBy(user.getId());
        customer.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int updateResult = customerService.modifyCustomerById(customer);
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

        return returnObject;
    }

    @RequestMapping("/workbench/customer/deleteCustomerById.do")
    @ResponseBody
    public Object deleteCustomerById(String[] id){

        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = customerService.deleteCustomerById(id);
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

    @RequestMapping("/workbench/customer/customerDetailPage.do")
    public String customerDetailPage(String id,HttpServletRequest request){

        Customer customer = customerService.queryCustomerDetailById(id);
        List<CustomerRemark> customerRemarkList = customerRemarkService.queryCustomerRemarkById(id);
        List<Tran> tranList = tranService.queryTranById(id);
        List<Contacts> contactsList = contactsService.queryContactsByCustomerId(id);
        List<DicValue> sourceList = dicValueService.queryDicValueByTypeCode("source");
        List<DicValue> appellationList = dicValueService.queryDicValueByTypeCode("appellation");
        List<User> userList = userService.queryAllUsers();

        request.setAttribute("sourceList",sourceList);
        request.setAttribute("appellationList",appellationList);
        request.setAttribute("userList",userList);
        request.setAttribute("customer",customer);
        request.setAttribute("customerRemarkList",customerRemarkList);
        request.setAttribute("tranList",tranList);
        request.setAttribute("contactsList",contactsList);

        return "workbench/customer/detail";
    }

    @RequestMapping("/workbench/customer/addCustomerRemark.do")
    @ResponseBody
    public Object addCustomerRemark(CustomerRemark customerRemark,HttpSession session){
        User user = (User) session.getAttribute(Constance.SESSION_USER);
        ReturnObject returnObject = new ReturnObject();

        customerRemark.setId(UUIDutils.getUUID());
        customerRemark.setCreateBy(user.getId());
        customerRemark.setCreateTime(TimeFormat.dateToString(new Date()));
        customerRemark.setEditFlag("0");
        customerRemark.setEditTime(TimeFormat.dateToString(new Date()));
        customerRemark.setEditBy(user.getId());

        try {
            int addResult = customerRemarkService.addCustomerRemark(customerRemark);
            if(addResult == 1){
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

        CustomerRemark customerRemark1 = customerRemarkService.queryCustomerRemarkByRemarkId(customerRemark.getId());
        returnObject.setReturnData(customerRemark1);
        return returnObject;
    }

    @RequestMapping("workbench/customer/deleteRemarkById.do")
    @ResponseBody
    public Object deleteRemarkById(String id){
        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = customerRemarkService.deleteCustomerRemarkById(id);
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

    @RequestMapping("/workbench/customer/updateRemarkById.do")
    @ResponseBody
    public Object updateRemarkById(CustomerRemark customerRemark,HttpSession session){
        ReturnObject returnObject = new ReturnObject();
        User user =(User) session.getAttribute(Constance.SESSION_USER);

        customerRemark.setEditBy(user.getId());
        customerRemark.setEditFlag("1");
        customerRemark.setEditTime(TimeFormat.dateToString(new Date()));

        try {
            int updateResult = customerRemarkService.updateRemarkById(customerRemark);
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

        CustomerRemark customerRemark1 = customerRemarkService.queryCustomerRemarkByRemarkId(customerRemark.getId());
        returnObject.setReturnData(customerRemark1);
        return returnObject;
    }

    @RequestMapping("/workbench/customer/addContact.do")
    @ResponseBody
    public Object addContact(Contacts contacts,HttpSession session){
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

    @RequestMapping("/workbench/customer/deleteContact.do")
    @ResponseBody
    public Object deleteContact(String id){

        ReturnObject returnObject = new ReturnObject();

        try {
            int deleteResult = contactsService.deleteContactById(id);
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

    @RequestMapping("/workbench/customer/queryOriginalCustomer.do")
    @ResponseBody
    public Object queryOriginalCustomer(String id){

        Customer customer = customerService.queryOriginalCustomerById(id);
        return customer;
    }
}
