package com.neusoft.util;

import com.neusoft.bean.SystemMenu;
import org.apache.log4j.Logger;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.*;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;

import java.text.SimpleDateFormat;
import java.util.Date;


//使用aop需要在 spring配置文件里加入<aop:aspectj-autoproxy/>同时，maven中需要加入依赖的jar包：
//@Pointcut  用于定义切面的匹配规则，如果想要同事匹配多个的话，可以使用 || 把两个规则连接起来，具体可以参照上面的代码
//@Before  目标方法执行前调用
//@After  目标方法执行后调用
//@AfterReturning  目标方法执行后调用，可以拿到返回结果，执行顺序在 @After 之后
//@AfterThrowing  目标方法执行异常时调用
//@Around  调用实际的目标方法，可以在目标方法调用前做一些操作，也可以在目标方法调用后做一些操作。使用场景有：事物管理、权限控制，日志打印、性能分析等等

//  执行目标方法前： 先进入 around ，再进入 before
//        目标方法执行完成后： 先进入 around ，再进入 after ，最后进入 afterreturning
@Component//这个类被Spring当做bean管理
@Aspect//这个类是一个切面对象类
public class AopDemo {

    Logger logger=Logger.getLogger(AopDemo.class);
    SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    //@Pointcut定义切面的匹配规则，决定哪些地方用到这个切面
    @Pointcut("execution(public * com.neusoft.controller.*.*(..))")//controller包下的任何一个方法
    public void pointCut(){

    }
    @Before("pointCut()")
    public void bobefore(JoinPoint point)
    {
        String methodName=point.getSignature().getName();//得到调用的方法名
        System.out.println("方法调用前");
        System.out.println("methodName:"+methodName+"\n类型"+point.getTarget().getClass().getName());

        //logger.debug()
        //logger.info()
        //logger.warn()
        //logger.error()生产模式

    }
    @After("pointCut()")
    public void after(JoinPoint point)
    {
        String methodName=point.getSignature().getName();//得到调用的方法名
        System.out.println("方法调用后");
        System.out.println("methodName:"+methodName+"\n类型"+point.getTarget().getClass().getName());
    }
    @AfterReturning(pointcut = "pointCut()",returning = "result")
    public void afterReturn(JoinPoint point, Object result) {
        String methodName=point.getSignature().getName();//得到调用的方法名
        System.out.println("返回");
        System.out.println("methodName:"+methodName+"\n类型"+point.getTarget().getClass().getName());
        System.out.println("***:"+result.getClass().getName());

    }

    @Around("pointCut()")
    public Object  around(ProceedingJoinPoint point )
    {
        String methodName=point.getSignature().getName();//得到调用的方法名
        System.out.println("methodName:"+methodName+"\n类型"+point.getTarget().getClass().getName());
        long startime= System.currentTimeMillis();
        Object obj= null;
        try {

            obj = point.proceed();//执行

        } catch (Throwable throwable) {
            throwable.printStackTrace();
        }
        long endtime=System.currentTimeMillis();//执行结束
        System.out.println("耗时"+(endtime-startime));

        logger.info(sdf.format(new Date()));
        logger.info(point.getTarget().getClass().getName()+"."+point.getSignature().getName());
        logger.info("耗时"+(endtime-startime));
        return obj;

    }
}
