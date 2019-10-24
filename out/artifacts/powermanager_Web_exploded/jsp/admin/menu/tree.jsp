<%--
  Created by IntelliJ IDEA.
  User: 14908
  Date: 2019/10/14
  Time: 11:22
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>菜单管理</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <link rel="stylesheet" href="<%=basePath%>static/element/css/theme/index.css">
</head>
<body>

    <div id="app">
    <el-row>
    <el-col :span="6">
      <el-tree :data="data" :props="defaultProps" @node-click="handleNodeClick" :highlight-current="true" :default-expand-all="true">
            <span class="custom-tree-node" slot-scope="{node,data}">
                  <span>
                   <i :class="data.menuIco"></i>
                    {{node.label}}
                </span>
            </span>
    </el-tree>
    </el-col>
    <el-col :span="10">
                <el-form :model="menu" :rules="rules" ref="menu" label-width="100px" class="demo-ruleForm">
                <el-form-item label="菜单名称" prop="menuTitle">
                <el-input v-model="menu.menuTitle"></el-input>
                </el-form-item>
                <el-form-item label="菜单链接" prop="menuLink">
                <el-input v-model="menu.menuLink"></el-input>
                </el-form-item>
                <el-form-item label="菜单图标" prop="menuIco">
                <el-input v-model="menu.menuIco"></el-input>
                </el-form-item>
                 <el-form-item label="父级菜单" prop="pmenutitle">
                      <el-input v-model="menu.pmenutitle" :disabled="true"></el-input>
                <input type="text" v-model="menu.menuPid" style="display: none">
                  </el-form-item>
                <el-form-item label="菜单描述" prop="menuAlt">
                    <el-input v-model="menu.menuAlt"></el-input>
                </el-form-item>
                <el-form-item label="菜单排序" prop="menu_order">
                    <el-input v-model="menu.menu_order"></el-input>
                </el-form-item>
                <el-form-item label="是否顶级目录" prop="istop" @change="istop">
                   <el-switch v-model="menu.istop"></el-switch>
                </el-form-item>
                    <el-form-item label="添加/修改" prop="isnew">
                    <el-select v-model="menu.isnew" placeholder="请选择" @change="changesave">
                    <el-option label="增加" value="insert"></el-option>
                    <el-option label="修改" value="update"></el-option>
                    </el-select>
                    </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="submitForm('menu')">立即保存</el-button>
                    <el-button @click="resetForm('menu')">重置</el-button>
                </el-form-item>
                </el-form>
    </el-col>
    </el-row>
    </div>


    <script src="<%=basePath%>static/element/js/vue.js"></script>
    <script src="<%=basePath%>static/element/js/element-ui.js"></script>

    <script src="<%=basePath%>static/element/js/axios.js"></script>
    <script src="<%=basePath%>static/element/js/qs.js"></script>

    <script>

    new Vue({
    el:'#app',
    data:function () {
        return{
                data: [],
             defaultProps: {
                children: 'list',
                label: 'menuTitle',
                },
            backmenu:{},//防止撤回
            menu:{

    },
            rules: {
            menuTitle: [
            { required: true, message: '请输入菜单名称', trigger: 'blur' },
            { min: 3, max: 5, message: '长度在 2 到 5 个字符', trigger: 'blur' }
            ],
            menuLink: [
            { required: true, message: '请输入菜单链接', trigger: 'blur' }
            ],

            },
        }
      },
    created:function() {
        this.inittree()
    },
    methods: {
        <!--是否是顶级菜单 默认true-->
    istop(value){
        if(value)
    {
        this.backmenu=this.menu
        this.menu={}
        this.menu.pmenutitle='顶级目录'
        this.menu.isnew='insert'

    }
        else
    {
        this.menu=this.backmenu
       this.menu.isnew='update'
    }
    },
        <!--是增加还是修改-->
    changesave(){
            <!--新增-->
     if(this.menu.isnew=='insert')
    {
        var pid=this.menu.menuPid
       var pmenutitle=this.menu.pmenutitle
       this.backmenu=this.menu;//备份一遍
       this.menu={};
        this.menu.menuPid=pid;
        this.menu.pmenutitle=pmenutitle
        this.menu.isnew='insert'
    }
     else{
        this.menu=this.backmenu;
        this.menu.isnew='update'
    }
    },
        <!--提交表单保存-->
        submitForm(formName) {
            this.$refs[formName].validate((valid) => {
            if (valid) {
            this.save();
            } else {
            console.log('error submit!!');
            return false;
            }
            });
        },
        <!--重置表单-->
        resetForm(formName) {
            this.$refs[formName].resetFields();
     },
     <!--保存表单信息-->
        save(){
                    var self = this
                    axios.get("<%=basePath%>admin/menu/saveOrupdate",{params:self.menu})
                    .then(function (response) {
                    if (response.data.code == '10000') {
                         self.inittree()
                            self.$message({
                            type: 'success',
                            message: '操作成功!'
                            });
                    }
                    else
                    {
                    self.$message({
                    type: 'error',
                    message: '操作失败!'
                    });
                    }
                    })
                    .catch(function (error) {
                    self.$message({
                    type: 'error',
                    message: '异常!'
                    });
                    });
        },
        <!--初始化菜单结构-->
        inittree(){
            var self = this
            axios.get("<%=basePath%>admin/menu/list")
            .then(function (response) {
            if (response.data.code == '10000') {
                self.data=response.data.obj
            }
            else
                {
                    self.$message({
                    type: 'error',
                    message: '操作失败!'
                    });
                }
            })
            .catch(function (error) {
                    self.$message({
                    type: 'error',
                    message: '异常!'
                    });
            });
        },
    <!--点击菜单触发事件 三个参数-->
            handleNodeClick(data,node,dom) {
            console.log(data);
            this.menu=data
             if(this.menu.menuPid==0)

             {
                 this.menu.pmenutitle="顶级目录"
             }
             else
                {
                    this.menu.pmenutitle=node.parent.label
                }

            }


        },
    })
    </script>
</body>
</html>