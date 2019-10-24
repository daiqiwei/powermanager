package com.neusoft.controller;

import com.neusoft.bean.Manager;
import com.neusoft.bean.SystemMenu;
import com.neusoft.dao.SystemMenuMapper;
import com.neusoft.util.ResultBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpSession;
import java.util.*;

@Controller
@RequestMapping("admin/menu")
public class MenuController extends BaseController{

    @Autowired
    private SystemMenuMapper systemMenuMapper;

    @RequestMapping("tree")
    public String page(){
        return "admin/menu/tree";
    }

    @RequestMapping("list")
    @ResponseBody
    public Object findall(){

        ResultBean bean =null;
        try{

            List<SystemMenu> list=systemMenuMapper.selectAll();
            //将获取的数据转成树状结构
            List<SystemMenu> temp=new ArrayList<>();

            for (SystemMenu m:list
                 ) {
                for (SystemMenu m2:list//双重循环
                ) {
                        if(m.getMenuId().intValue()==m2.getMenuPid().intValue())//如果m2是m的子类
                        {
                            m.getList().add(m2);//将m2加入m的子目录
                            temp.add(m2);//同时将m2加入temp,因为已经是子类了，多余需要删除m2
                        }
                }
            }
            list.removeAll(temp);//从list里删除temp

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
     * 对菜单数据添加/修改
     * @param menu
     * @return
     */
    @RequestMapping("saveOrupdate")
    @ResponseBody
    public Object save(SystemMenu menu){

        ResultBean bean =null;

        try{
            int rows=0;

            if(menu.getMenuId()==null)
            {

                menu.setMenuCreatetime(new Date());
                menu.setMenuLastmodify(new Date());
                rows=systemMenuMapper.insertSelective(menu);//id为空是增加 要考虑时间是自动设置的

            }
            else
            {
                menu.setMenuLastmodify(new Date());
                rows=systemMenuMapper.updateByPrimaryKeySelective(menu);//id不为空是修改
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
     * 登录根据用户权限显示菜单
     *
     * @return
     */
    @RequestMapping("manager")
    @ResponseBody
    public Object findbymanagerid(){

        ResultBean bean =null;
        try{

            Manager manager=getLoginManager();
            List<SystemMenu> list=systemMenuMapper.selectByManagerid(manager.getManagerId());
            //将获取的数据转成树状结构
            List<SystemMenu> temp=new ArrayList<>();

            for (SystemMenu m:list
            ) {
                for (SystemMenu m2:list//双重循环
                ) {
                    if(m.getMenuId().intValue()==m2.getMenuPid().intValue())//如果m2是m的子类
                    {
                        m.getList().add(m2);//将m2加入m的子目录
                        temp.add(m2);//同时将m2加入temp,因为已经是子类了，多余需要删除m2
                    }
                }
            }
            list.removeAll(temp);//从list里删除temp

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
