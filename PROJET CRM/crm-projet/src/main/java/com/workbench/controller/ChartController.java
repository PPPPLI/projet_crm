package com.workbench.controller;

import com.workbench.domain.Chart;
import com.workbench.service.ActivityService;
import com.workbench.service.TranService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.List;

@Controller
public class ChartController {

    @Autowired
    TranService tranService;
    @Autowired
    ActivityService activityService;

    @RequestMapping("/workbench/chart/transaction/index.do")
    public String index(){

        return "workbench/chart/transaction/index";
    }

    @RequestMapping("/workbench/transaction/getCharts.do")
    @ResponseBody
    public Object getCharts(){

        List<Chart> chartList = tranService.queryTranStage();
        return chartList;
    }

    @RequestMapping("/workbench/chart/transaction/activityChartIndex.do")
    public String activityChartIndex(){

        return "workbench/chart/activity/index";
    }

    @RequestMapping("/workbench/transaction/getActivityCharts.do")
    @ResponseBody
    public Object getActivityCharts(){

        List<Chart> chartList = activityService.queryActivityForChart();
        return chartList;
    }
}
