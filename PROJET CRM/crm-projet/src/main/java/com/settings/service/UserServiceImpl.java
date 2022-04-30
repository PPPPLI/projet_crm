package com.settings.service;

import com.settings.domain.User;
import com.settings.mapper.UserMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Map;

@Service("UserService")
public class UserServiceImpl implements UserService {

    @Autowired
    private UserMapper userMapper;
    @Override
    public User queryUserByLoginActAndPwd(Map<String, Object> map) {

        return userMapper.selectUserByLoginActAndPwd(map);

    }

    @Override
    public List<User> queryAllUsers() {

        List<User> userList = userMapper.selectAllUsers();
        return userList;
    }

    @Override
    public int updatePassword(Map<String,Object> map) {

        User user =(User) map.get("user");
        String actualPassword =(String)map.get("actualPassword");

        String loginPwd = userMapper.selectUserById(user.getId());

        int updateResult = 0;

        if(actualPassword.compareTo(loginPwd) == 0){

            updateResult = userMapper.updatePassword(user);

        }else{
            updateResult = -1;
        }
        return updateResult;
    }
}
