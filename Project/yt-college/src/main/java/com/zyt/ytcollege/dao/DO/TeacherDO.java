package com.zyt.ytcollege.dao.DO;

import lombok.Data;

/**
 * create by lwj on 2020/3/14
 */
@Data
public class TeacherDO {
    private Integer id;
    private String name;
    private Integer sex;    //0-女 1-男
    private Integer age;
    private String phone;
    private String password;    //登录密码
    private Integer post;   //岗级 enum YTPost
    private Integer level;  //职级 enum YTLevel
    private Integer totalHours; //当前学期总课时
    private Integer numbers;    //当前学期学生总数
    private Double score;  //教学质量评分
    private Double renewalRate; //续保率
    private Integer isDelete;   //是否在职 0-在职 1-离职
}
