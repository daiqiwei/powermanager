<%--
  Created by IntelliJ IDEA.
  User: 14908
  Date: 2019/10/9
  Time: 11:23
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>角色列表</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
    <link rel="stylesheet" href="<%=basePath%>static/element/css/theme/index.css">

    <style>
        body{
            padding: 0px;
            margin: 0px;
        }
        .avatar-uploader .el-upload {
            border: 1px dashed #d9d9d9;
            border-radius: 6px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            margin-bottom: 25px;

        }
        .avatar-uploader .el-upload:hover {
            border-color: #409EFF;

        }
        .avatar-uploader-icon {
            font-size: 20px;
            color: #8c939d;
            width: 150px;
            height: 150px;
            line-height: 150px;
        }
        .avatar {
            width: 150px;
            height: 150px;
            display: block;
        }

    </style>
</head>
<body>

<div id="app">
    <div>
        <el-row style="margin: 10px;">
            <el-col :span="6">
                <el-button-group>
                    <el-button type="primary" icon="el-icon-plus" @click="opensave"></el-button>



                    <!--opensave添加/修改角色-->
                    <el-dialog title="添加/修改角色" :visible.sync="dialogFormVisible" width="420px">
                        <el-form :model="role" :rules="rules" ref="role">
                            <el-form-item label="角色名"   prop="roleName" :label-width="formLabelWidth">
                                <el-input v-model="role.roleName" autocomplete="off"  ></el-input>
                            </el-form-item>
                        </el-form>
                        <div slot="footer" class="dialog-footer" style="width: 70%;">
                            <el-button @click=resetForm('role')>重置</el-button>
                            <el-button type="primary" @click="submitForm('role')">确 定</el-button>
                        </div>
                    </el-dialog>
                    <!---->

                    <el-button type="primary" icon="el-icon-edit"></el-button>
                </el-button-group>
            </el-col >


        </el-row>
    </div>
    <template>

        <el-table
                :data="list"
                ref="tb1"
                border
                style="width: 100%"
                   >
            <el-table-column
                    type="selection"
                    width="55">
            </el-table-column>
            <el-table-column
                    fixed
                    prop="roleId"
                    label="ID"
                    width="60"
                    sortable>
            </el-table-column>

            
            <el-table-column
                    prop="roleName"
                    label="角色名"
                    width="120">
            </el-table-column>

            <el-table-column
                    prop="roleCreatetime"
                    label="创建时间"
                    width="200">
            </el-table-column>
            <el-table-column
                    prop="roleLastmodify"
                    label="最后修改时间"
                    width="200">
            </el-table-column>
            <el-table-column
                    fixed="right"
                    label="操作"
                   >
                <template slot-scope="scope">
                    <el-button @click="powerClick(scope.row.roleId)" type="text" size="small">授权</el-button>
                    <el-button @click="editClick(scope.row)" type="text" size="small">编辑</el-button>
                    <el-button @click="deleteClick(scope.row.roleId)" type="text" size="small">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
    </template>
    <!--powerClick授权信息框-->
    <el-dialog title="权限管理" :visible.sync="dialogPowerVisible" width="255px">

            <el-tree
                    ref="tree"
                    :data="data"
                    :check-on-click-node=false
                    show-checkbox

                    @check="savepower"
                    :default-expand-all=true
                    :props="defaultProps"
                    node-key="menuId"
                    :default-checked-keys="ckarray"
                    >
            </el-tree>


    </el-dialog>
    <!---->
</div>
<script src="<%=basePath%>static/element/js/vue.js"></script>
<script src="<%=basePath%>static/element/js/element-ui.js"></script>

<script src="<%=basePath%>static/element/js/axios.js"></script>
<script src="<%=basePath%>static/element/js/qs.js"></script>

<script>

    new Vue({
        el: '#app',
        data: function () {

            return {
                ckarray:[],//默认选中的授权
                data: [],
                list: [],
                defaultProps: {
                    children: 'list',
                    label: 'menuTitle',
                },
                dialogFormVisible: false,
                dialogPowerVisible: false,
                role: {},
                power: {},
                formLabelWidth: '100px',

                rules: {
                    roleName: [
                        {required: true, message: '请输入角色名', trigger: 'blur'},
                        {min: 2, max: 50, message: '输入的字符最少为2个', trigger: 'blur'}
                    ]
                },
                currentid:0

            }

        },
        created: function () {
            this.getdata()

        },
        methods: {
            <!--change事件-->
            savepower(){
               var nodes= this.$refs.tree.getCheckedNodes(false,false);//获取当前tree上选中的节点,返回的是数组
               console.log(nodes)
                var ids=[]
                for(var i=0;i<nodes.length;i++)
                {
                    ids.push(nodes[i].menuId);
                }
                var data={//传两个参数给后台
                    'menus':ids.join(','),
                    'roleid':this.currentid
                }
                var self = this
                axios.get("<%=basePath%>admin/role/power",{params: data})
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.$message({
                                type: 'success',
                                message: '操作成功!'
                            });
                        } else {
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
            <!--授权管理-->
            powerClick(id) {
                this.currentid=id;
                var self=this
                axios.get("<%=basePath%>admin/role/powerlist",{params:{'roleid':id}})//读取role权限
                    .then(function (response) {
                        self.ckarray=[]
                        if (response.data.code == '10000') {

                            var list=response.data.obj;

                            for(var i=0;i<list.length;i++)
                            {
                                self.ckarray.push(list[i].rmrfMenuid);
                            }
                            self.inittree();//权限获取成功后加载tree
                            self.dialogPowerVisible = true;
                        } else {
                            self.$message({
                                type: 'error',
                                message: '读取权限失败!'
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
            inittree() {
                var self = this
                axios.get("<%=basePath%>admin/menu/list")
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.data = response.data.obj
                        } else {
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
        <!--click事件每次增加都重置role-->
        opensave() {
            this.dialogFormVisible = true
            this.resetForm('role');
            this.role = {};
        },
        <!--修改信息-->
        editClick(row) {
            this.role = row;
            this.dialogFormVisible = true

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

        <!--添加/修改信息-->
        save() {

            var self = this
            axios.post("<%=basePath%>admin/role/saveOrupdate", Qs.stringify(self.role))
                .then(function (response) {
                    if (response.data.code == '10000') {
                        self.dialogFormVisible = false
                        self.getdata()
                        self.$message({
                            type: 'success',
                            message: '操作成功!'
                        });
                    } else {
                        self.$message({
                            type: 'error',
                            message: '操作失败!'
                        });
                    }
                })
                .catch(function (error) {
                    console.log(error);
                });
        },

        deleteClick(id) {

            this.$confirm('此操作将永久删除该数据, 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {<!--确定删除-->

                var data = {
                    'id': id,
                }
                var self = this
                axios.get("<%=basePath%>admin/role/delete", {
                    params: data
                })
                    .then(function (response) {
                        <!--删除成功-->
                        if (response.data.code == '10000') {
                            self.getdata()

                            self.$message({
                                type: 'success',
                                message: '删除成功!'
                            });
                        }
                        <!--删除失败-->
                        else {
                            self.$message({
                                type: 'error',
                                message: '删除失败!'
                            });
                        }
                    })
                    .catch(function (error) {
                        console.log(error);
                    });


            }).catch(() => {<!--取消删除-->
                this.$message({
                    type: 'info',
                    message: '已取消删除'
                });
            });

        },

        getdata: function () {
            var self = this
            axios.get("<%=basePath%>admin/role/list")
                .then(function (response) {
                    if (response.data.code == '10000') {
                        self.list = response.data.obj
                    }
                })
                .catch(function (error) {
                    console.log(error);
                });
            },
         }
    })
</script>
</body>
</html>
