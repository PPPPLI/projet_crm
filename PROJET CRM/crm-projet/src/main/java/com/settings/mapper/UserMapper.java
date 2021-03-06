package com.settings.mapper;

import com.settings.domain.User;

import java.util.List;
import java.util.Map;

public interface UserMapper {
    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    int deleteByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    int insert(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    int insertSelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    User selectByPrimaryKey(String id);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    int updateByPrimaryKeySelective(User record);

    /**
     * This method was generated by MyBatis Generator.
     * This method corresponds to the database table tbl_user
     *
     * @mbggenerated Sat Apr 09 22:09:21 CEST 2022
     */
    int updateByPrimaryKey(User record);

    /**
     *  Chercher l'utilisateur selon l'identifiant et mots de pass
     * @param map
     * @return
     */
    User selectUserByLoginActAndPwd(Map<String,Object> map);

    List<User> selectAllUsers();

    int updatePassword(User user);

    String selectUserById(String id);
}