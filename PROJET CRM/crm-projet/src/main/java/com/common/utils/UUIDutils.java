package com.common.utils;

import java.util.UUID;

public class UUIDutils {

    public static String getUUID(){

        String uuidOriginal = UUID.randomUUID().toString();
        String uuid = uuidOriginal.replaceAll("-","");
        return uuid;
    }


}
