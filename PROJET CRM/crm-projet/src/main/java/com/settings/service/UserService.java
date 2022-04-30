package com.settings.service;

import com.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserService {

    User queryUserByLoginActAndPwd(Map<String,Object> map);

    List<User> queryAllUsers();

    int updatePassword(Map<String,Object> map);
}
