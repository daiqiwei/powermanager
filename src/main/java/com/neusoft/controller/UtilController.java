package com.neusoft.controller;

import com.neusoft.bean.Manager;
import com.neusoft.dao.ManagerMapper;
import com.neusoft.util.ResultBean;
import com.neusoft.util.VerifyCodeUtils;
import com.sun.deploy.net.HttpResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.jms.Session;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("util")
public class UtilController {

    @Autowired
    private ManagerMapper managerMapper;


//    @Autowired
//    private RedisTemplate redisTemplate;
    @RequestMapping("login")
    public String tologin()
    {
        return "/login/index";
    }

    @RequestMapping("login/do")
    @ResponseBody
    public Object login(String password,String username,String code,HttpSession session){

        ResultBean bean=null;

        try {

            String mycode = (String) session.getAttribute("code");
            if (mycode.equalsIgnoreCase(code)) {
                session.removeAttribute("code");//一旦验证码用完就释放
                Map map = new HashMap();
                map.put("username", username);
                map.put("password", password);

//                Object object=redisTemplate.opsForValue().get(username);
//
//                if(object!=null)
//                {
//                    session.setAttribute(Manager.CURRENT_MANAGER, (Manager)object);
//                    bean = new ResultBean(ResultBean.Code.SUCCESS);
//                }
               List<Manager> list = managerMapper.login(map);
// 原本直接读取数据库数据，如果大量并发会导致读死
                if (list != null && list.size() > 0) {
                    session.setAttribute(Manager.CURRENT_MANAGER, list.get(0));
                    bean = new ResultBean(ResultBean.Code.SUCCESS);
                }
                else {
                    bean = new ResultBean(ResultBean.Code.FAIL);
                    bean.setMsg("账号或密码错误");
                }
            }
            else
            {
                bean = new ResultBean(ResultBean.Code.FAIL);
                bean.setMsg("验证码错误");
            }
            }catch(Exception e)
            {
                e.printStackTrace();
                bean = new ResultBean(ResultBean.Code.EXCEPTION);
            }

            return bean;

    }

    @RequestMapping("code")
    public void showcodeimg(HttpSession session, HttpServletResponse response)
    {
        try {
            String code = VerifyCodeUtils.generateVerifyCode(4);
            session.setAttribute("code",code);
            VerifyCodeUtils.outputImage(100, 44, response.getOutputStream(), code);//宽 高 输出流 生成码

            response.getOutputStream().close();
        }catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}
