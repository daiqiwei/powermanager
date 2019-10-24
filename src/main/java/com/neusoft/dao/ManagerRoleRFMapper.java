package com.neusoft.dao;


import com.neusoft.bean.ManagerRoleRF;

import java.util.List;

public interface ManagerRoleRFMapper {
    int deleteByPrimaryKey(Integer rfId);

    int insert(ManagerRoleRF record);

    int insertSelective(ManagerRoleRF record);

    ManagerRoleRF selectByPrimaryKey(Integer rfId);

    int updateByPrimaryKeySelective(ManagerRoleRF record);

    int updateByPrimaryKey(ManagerRoleRF record);

   int  deleteByManagerId(Integer managerid);
   int insertAll(List<ManagerRoleRF> manager);
}