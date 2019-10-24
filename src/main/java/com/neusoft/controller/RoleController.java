package com.neusoft.controller;


import com.neusoft.bean.Role;
import com.neusoft.bean.RoleMenuRF;
import com.neusoft.dao.RoleMapper;
import com.neusoft.dao.RoleMenuRFMapper;
import com.neusoft.util.ResultBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

@Controller
@RequestMapping("admin/role")
public class RoleController {

    @Autowired
  private RoleMapper roleMapper;

    @Autowired
    private RoleMenuRFMapper rfMapper;

    @RequestMapping("html")
    public String page(){
        return "admin/role/list";
    }

    @RequestMapping("list")
    @ResponseBody
    public Object findall(){

        ResultBean bean =null;
        try{

            List<Role> list=roleMapper.selectAll();
            bean=new ResultBean(ResultBean.Code.SUCCESS);
            bean.setObj(list);


        }catch (Exception e)
        {
            e.printStackTrace();
            bean=new ResultBean(ResultBean.Code.EXCEPTION);
            bean.setMsg(e.getMessage());
        }
        return  bean;
    }

    /**
     * 删除一行
     * @param id
     * @return
     */
    @RequestMapping("delete")
    @ResponseBody
    public Object delete(Integer id){

        ResultBean bean =null;
        try{

            int rows=roleMapper.deleteByPrimaryKey(id);

            if(rows>0)
            {

                bean=new ResultBean(ResultBean.Code.SUCCESS);
            }
            else
            {
                bean=new ResultBean(ResultBean.Code.FAIL);
            }


        }catch (Exception e)
        {
            e.printStackTrace();
            bean=new ResultBean(ResultBean.Code.EXCEPTION);
            bean.setMsg(e.getMessage());
        }
        return  bean;
    }
    /**
     * 添加和修改
     * @param role
     * @return
     */
    @RequestMapping("saveOrupdate")
    @ResponseBody
    public Object save(Role role){

        ResultBean bean =null;

        try{
            int rows=0;

            if(role.getRoleId()!=null)
            {
                role.setRoleLastmodify(new Date());
                rows=roleMapper.updateByPrimaryKeySelective(role);//id不为空是修改

            }
            else
            {

                role.setRoleCreatetime(new Date());
                role.setRoleLastmodify(new Date());
                rows=roleMapper.insertSelective(role);//id为空是增加 要考虑时间是自动设置的
            }

            if(rows>0)
            {

                bean=new ResultBean(ResultBean.Code.SUCCESS);
            }
            else
            {
                bean=new ResultBean(ResultBean.Code.FAIL);
            }


        }catch (Exception e)
        {
            e.printStackTrace();
            bean=new ResultBean(ResultBean.Code.EXCEPTION);
            bean.setMsg(e.getMessage());
        }
        return  bean;
    }

    /**
     * 某个角色拥有的菜单
     * @param menus
     * @param roleid
     * @return
     */
    @RequestMapping("power")
    @ResponseBody
    public Object power(String menus,Integer roleid){

        ResultBean bean =null;

        try{
            int rows=0;

           rows= rfMapper.deletebyroleid(roleid);//删除roleid对应的全部menu

            if(menus!=null&&menus.length()>0){//当后台传过来的值不为空时

            String[] ids=menus.split("[,]");//将前台传过来的字符串转成数组
            List<RoleMenuRF> list=new ArrayList<>();
            for (String id:ids
                 ) {
                RoleMenuRF rf=new RoleMenuRF();
                rf.setRmrfMenuid(Integer.valueOf(id));//主外键约束关系
                rf.setRmrfRoleid(roleid);
                rf.setRmrfCreatetime(new Date());
                rf.setRmrfLastmodify(new Date());
                list.add(rf);

            }
                rows=rfMapper.insertAll(list);
            }
            if(rows>0)
            {

                bean=new ResultBean(ResultBean.Code.SUCCESS);
            }
            else
            {
                bean=new ResultBean(ResultBean.Code.FAIL);
            }


        }catch (Exception e)
        {
            e.printStackTrace();
            bean=new ResultBean(ResultBean.Code.EXCEPTION);
            bean.setMsg(e.getMessage());
        }
        return  bean;
    }


    @RequestMapping("powerlist")
    @ResponseBody
    public Object powerlist(Integer roleid){

        ResultBean bean =null;
        try{

            List<RoleMenuRF> list=rfMapper.selectByRoldeid(roleid);
            bean=new ResultBean(ResultBean.Code.SUCCESS);
            bean.setObj(list);


        }catch (Exception e)
        {
            e.printStackTrace();
            bean=new ResultBean(ResultBean.Code.EXCEPTION);
            bean.setMsg(e.getMessage());
        }
        return  bean;
    }
}
