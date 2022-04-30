package com.common.utils;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeFormat {

    //transform the current time to String
    public static String dateToString(Date date){

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String time = simpleDateFormat.format(date);
        return time;
    }

    public static String dateToString2(Date date){

        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String time = simpleDateFormat.format(date);
        return time;
    }
}
