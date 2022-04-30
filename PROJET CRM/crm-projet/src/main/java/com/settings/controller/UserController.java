package com.settings.controller;

import com.common.constance.Constance;
import com.common.domain.ReturnObject;
import com.common.utils.TimeFormat;
import com.settings.domain.User;
import com.settings.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Controller
public class UserController {

    @Autowired
    private UserService userService;

    @RequestMapping("/tologin.do")
    public String toLogin(HttpServletRequest request){

        String currentTime = TimeFormat.dateToString2(new Date());
        request.setAttribute("currentTime",currentTime);
        return "login";
    }

    @RequestMapping("/login.do")
    @ResponseBody
    public Object login(String loginAct, String loginPwd, String isRemPwd, HttpServletRequest request, HttpServletResponse response, HttpSession session){
        Map map = new HashMap();
        map.put("loginAct",loginAct);
        map.put("loginPwd",loginPwd);
        User user = userService.queryUserByLoginActAndPwd(map);
        ReturnObject returnObject = new ReturnObject();

        //Check the identity of user
        if (user == null){

            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Please check the password");

        }else {

            //Check the expireTime
            if(TimeFormat.dateToString(new Date()).compareTo(user.getExpireTime()) > 0){

                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Sorry,your account is expired");


            //Check the expireTime
            }else if("0".equals(user.getLocksTate())){

                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Sorry,your account is locked");


            //Check the user's IP
            }else if(!user.getAllowIps().contains(request.getRemoteAddr())) {

                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Sorry,the illegal ip address");

            }else{

                returnObject.setReturnCode(Constance.RESULT_SUCCES);

                session.setAttribute(Constance.SESSION_USER,user);

                if ("true".equals(isRemPwd)){
                    Cookie cookie1 = new Cookie("loginAct",loginAct);
                    cookie1.setMaxAge(10*24*60*60);
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie("loginPwd",loginPwd);
                    cookie2.setMaxAge(10*24*60*60);
                    response.addCookie(cookie2);
                }else{

                    Cookie cookie1 = new Cookie("loginAct","");
                    cookie1.setMaxAge(0);
                    response.addCookie(cookie1);
                    Cookie cookie2 = new Cookie("loginPwd","");
                    cookie2.setMaxAge(0);
                    response.addCookie(cookie2);
                }
            }
        }

        return returnObject;
    }

    @RequestMapping("/logOut.do")
    public String logOut(HttpServletResponse response,HttpSession session){

        //clear the cookies
        Cookie cookie1 = new Cookie("loginAct","");
        cookie1.setMaxAge(0);
        response.addCookie(cookie1);
        Cookie cookie2 = new Cookie("loginPwd","");
        cookie2.setMaxAge(0);
        response.addCookie(cookie2);

        //clear the session data
        session.invalidate();

        return "redirect:/";
    }

    @RequestMapping("/workbench/updatePassword.do")
    @ResponseBody
    public Object updatePassword(String actualPassword,String newPassword,String id){

        Map<String,Object> map = new HashMap<>();
        User user = new User();
        ReturnObject returnObject = new ReturnObject();

        user.setId(id);
        user.setLoginPwd(newPassword);
        map.put("actualPassword",actualPassword);
        map.put("user",user);

        try {
            int updateResult = userService.updatePassword(map);
            if(updateResult == 1){

                returnObject.setReturnCode(Constance.RESULT_SUCCES);
                returnObject.setMessage("Success");
            }else if(updateResult == -1){
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Please check your password");
            }else {
                returnObject.setReturnCode(Constance.RESULT_FAIL);
                returnObject.setMessage("Something went wrong,please try later");
            }
        }catch (Exception e){
            e.printStackTrace();
            returnObject.setReturnCode(Constance.RESULT_FAIL);
            returnObject.setMessage("Something went wrong,please try later");
        }
        return returnObject;
    }
}
