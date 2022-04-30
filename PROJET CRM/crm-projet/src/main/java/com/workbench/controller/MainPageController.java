package com.workbench.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainPageController {

    @RequestMapping("/workbench/index.do")

    public String index(){

        return "workbench/index";
    }
}
