package com.neusoft.controller;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.neusoft.bean.Manager;
import com.neusoft.bean.ManagerRoleRF;
import com.neusoft.dao.ManagerMapper;
import com.neusoft.dao.ManagerRoleRFMapper;
import com.neusoft.util.ResultBean;
import com.neusoft.util.Contents;
import com.neusoft.util.poi.PoiUtil;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.util.*;

@Controller
@RequestMapping("admin/manager")
public class ManagerController {

    @Autowired
    private ManagerMapper managerMapper;


    @Autowired
    private ManagerRoleRFMapper managerRoleRFMapper;

//    @Autowired
//    private RedisTemplate redisTemplate;

    @RequestMapping("html")
    public String page(){
        return "admin/manager/list";
    }
    /**
     * 查询所有的管理员
     * @param index 当前页码
     * @param size 每页显示数量
     * @param param 模糊查询参数
     * @param phone 根据手机号查询
     * @return
     */
    @RequestMapping("list")
    @ResponseBody
    public Object findall(Integer index,Integer size,String param,String phone,String order,String prop){

        ResultBean bean =null;
        try{
            //分页
            index=index==null?1:index;
            size=size==null?10:size;
            Map map=new HashMap();
            map.put("param",param);
            map.put("phone",phone);
            map.put("orderx",order);
            map.put("prop", Contents.to_col(prop));

            PageHelper.startPage(index,size);
            List<Manager> list=managerMapper.selectAll(map);
            PageInfo<Manager> info=new PageInfo<>(list);
            bean=new ResultBean(ResultBean.Code.SUCCESS);
            bean.setObj(info);


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

            int rows=managerMapper.deleteByPrimaryKey(id);

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
     * 批量删除 前端将id以字符串传送至后台
     * @param ids
     * @return
     */
    @RequestMapping("deleteAll")
    @ResponseBody
    public Object deleteall(@RequestParam("ids") String ids){

        ResultBean bean =null;
        try{


            String[] idsx=ids.split(",");
            List<Integer> list=new ArrayList<>();
            for (String id:idsx
                 ) {
                list.add(Integer.valueOf(id));
            }

            int rows=managerMapper.deleteAll(list);
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
     * @param manager
     * @return
     */
    @RequestMapping("saveOrupdate")
    @ResponseBody
    public Object save(Manager manager){

        ResultBean bean =null;

        try{
            int rows=0;

            if(manager.getManagerId()==null)
            {

                manager.setManagerCreatetime(new Date());
                manager.setManagerLastmodify(new Date());
                manager.setManagerPassword("000000");
                rows=managerMapper.insertSelective(manager);//id为空是增加 要考虑时间是自动设置的



            }
            else
            {
               manager=managerMapper.selectByPrimaryKey(manager.getManagerId());
 //               redisTemplate.opsForValue().set(manager.getManagerPhone(),manager);//修改也要将redis里数据修改完
//                manager.setManagerLastmodify(new Date());
                rows=managerMapper.updateByPrimaryKeySelective(manager);//id不为空是修改
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


    @RequestMapping("savepower")
    @ResponseBody
    public Object savepower(String roleids,Integer managerid){//传过来的参数是角色name字符串,和对应的mangerid

        ResultBean bean =null;
        int rows=0;
        try{

            if(roleids!=""){//当前端传回的字符串不为空 进行分割字符串操作

            String[] idsx=roleids.split(",");
            List<ManagerRoleRF> list=new ArrayList<>();
            for (String id:idsx
            ) {

                ManagerRoleRF mrf=new ManagerRoleRF();
                mrf.setRfCreatetime(new Date());
                mrf.setRfLastmodify(new Date());
                mrf.setRfMangerid(managerid);
                mrf.setRfRoleid(Integer.valueOf(id));
                list.add(mrf);
            }
            rows=managerRoleRFMapper.deleteByManagerId(managerid);

                if(list.size()>0)
                {
                  rows=  managerRoleRFMapper.insertAll(list);//选择了复选框才能执行insertAll否则sql语句会插入null导致报错
                }
            }
            else
            {
                rows=managerRoleRFMapper.deleteByManagerId(managerid);
            }
            if(rows>0)
            {

                bean=new ResultBean(ResultBean.Code.SUCCESS);
            }
            else//前端传回的字符串为空 只执行删除操作
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
     * 上传头像
     * @param file
     * @return
     */
    @RequestMapping("upload")
    @ResponseBody
    public Object upload(@RequestParam(value = "file",required = true) MultipartFile file,HttpServletRequest request){//多文件用数组
        ResultBean bean =null;

        try{

            if(file!=null)
            {
                String filepath=request.getSession().getServletContext().getRealPath("/uploadfiles");//upload的绝对路径
                Calendar calendar=Calendar.getInstance();
                int year=calendar.get(Calendar.YEAR);
                int month=calendar.get(Calendar.MONTH)+1;
                int day=calendar.get(Calendar.DATE);
                String dirName="/"+year+"/"+month+"/"+day;
                File file1=new File(filepath,dirName);//file1是包含日期绝对的物理地址
                if(!file1.exists())
                {
                    file1.mkdirs();//如果不存在则创建不止一个文件夹
                }
                String orgname=file.getOriginalFilename();//得到原始文件名

                String fileName=UUID.randomUUID().toString()+orgname.substring(orgname.lastIndexOf("."));//赋予新的不会重名的文件名
               //存储在数据库中相对地址
                String dbpath="/uploadfiles"+dirName+"/"+fileName;

                //完整的物理地址
                File targetFile=new File(file1,fileName);
                file.transferTo(targetFile);
                bean=new ResultBean(ResultBean.Code.SUCCESS);
                bean.setObj(dbpath);
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
     * 批量导入excel
     * @param file
     * @param request
     * @return
     */
    @RequestMapping("import")
    @ResponseBody
    public Object importManager(@RequestParam(value = "file",required = true) MultipartFile file,HttpServletRequest request){//多文件用数组
        ResultBean bean =null;

        try{

            if(file!=null)
            {
               List<Manager> list= PoiUtil.importExcel(file,0,1,Manager.class);//已经将excel数据转成对象
                //1.循环输入 2.一句sql插入

                for (Manager manager:list
                     ) {
                    manager.setManagerCreatetime(new Date());
                    manager.setManagerLastmodify(new Date());
                    manager.setManagerPassword("000000");
                }

                managerMapper.insertAll(list);
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
}
