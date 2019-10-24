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
    <title>管理员列表</title>
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

                    <!--增加信息框-->

                    <el-dialog title="管理员信息" :visible.sync="dialogFormVisible" width="420px">
                        <el-form :model="manager" :rules="rules" ref="manager">
                            <div style="text-align: center">
                            <el-upload
                                    class="avatar-uploader"
                                    action="<%=basePath%>admin/manager/upload"

                                    name="file"
                                    :show-file-list="false"
                                    :on-success="handleAvatarSuccess"
                                    :before-upload="beforeAvatarUpload">
                                <img v-if="imageUrl" :src="imageUrl" class="avatar">
                                <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                            </el-upload>
                            </div>
                            <el-form-item label="姓名"   prop="managerName" :label-width="formLabelWidth">
                                <el-input v-model="manager.managerName" autocomplete="off"  ></el-input>
                            </el-form-item>
                            <el-form-item label="性别" :label-width="formLabelWidth" prop="sex">
                                <el-select v-model="manager.managerSex" placeholder="请选择性别" style="width: 100%">
                                    <el-option label="男" value="男" label-width="formLabelWidth"></el-option>
                                    <el-option label="女" value="女" label-width="formLabelWidth" checked></el-option>
                                </el-select>
                            </el-form-item>
                            <el-form-item label="手机号码"  prop="managerPhone" :label-width="formLabelWidth">
                                <el-input v-model="manager.managerPhone"  type="number"   onKeypress="return (/[\d\.]/.test(String.fromCharCode(event.keyCode)))" ></el-input>
                            </el-form-item>
                            <el-form-item label="身份证号"   prop="managerIdcard" :label-width="formLabelWidth">
                                <el-input v-model="manager.managerIdcard"  type="number"   onKeypress="return (/[\d\.]/.test(String.fromCharCode(event.keyCode)))" ></el-input>
                            </el-form-item>
                        </el-form>
                        <div slot="footer" class="dialog-footer" style="width: 70%;">
                            <el-button @click=resetForm('manager')>重置</el-button>
                            <el-button type="primary" @click="submitForm('manager')">确 定</el-button>
                        </div>
                    </el-dialog>
                    <!---->



                    <el-button type="primary" icon="el-icon-edit"></el-button>
                    <el-button type="primary" icon="el-icon-delete" @click="deleteall"></el-button>
                </el-button-group>
            </el-col >

            <el-col :span="2">
                <a href="<%=basePath%>static/template/manager.xlsx">模板下载</a>
            </el-col>

            <el-col :span="8">
                <el-upload
                        class="upload-demo"
                        action="<%=basePath%>admin/manager/import"
                        :on-success="importsuccess"
                        :on-error="importfail"
                        :show-file-list="false"
                        >
                    <el-button size="small" type="primary">批量添加</el-button>

                </el-upload>
            </el-col>

            <el-col :span="6">
                    <el-input
                            @keyup.enter.native="search"
                            v-model="param"

                            placeholder="输入关键字搜索">
                        <el-button slot="append" icon="el-icon-search" @click="search"></el-button>
                    </el-input>
            </el-col>
        </el-row>
    </div>
    <template>

        <el-table
                :data="list"
                ref="tb1"
                border
                style="width: 100%"
                :default-sort = "{prop: 'managerId', order: 'descending'}"
                    @sort-change="sort">
            <el-table-column
                    type="selection"
                    width="55">
            </el-table-column>
            <el-table-column
                    fixed
                    prop="managerId"
                    label="ID"
                    width="60"
                    sortable>
            </el-table-column>
            <el-table-column
                    label="头像"
                    prop="managerImg"
                    width="180">
                <template slot-scope="scope">
                    <img style="height: 90px" :src="'<%=basePath%>'+scope.row.managerImg" onerror="javascript:this.src='<%=basePath%>static/imgs/default.jpg'">
                </template>
            </el-table-column>
            
            <el-table-column
                    prop="managerName"
                    label="姓名"
                    width="120">
            </el-table-column>
            <el-table-column
                    prop="managerPhone"
                    label="手机号码"
                    width="120">
            </el-table-column>
            <el-table-column
                    prop="managerSex"
                    label="性别"
                    width="60"
                    sortable>
            </el-table-column>
            <el-table-column
                    prop="managerIdcard"
                    label="身份证号码"
                    width="180">
            </el-table-column>
            <el-table-column
                    prop="rolestr"
                    label="角色权限"
                    width="200">
            </el-table-column>
            <el-table-column
                    prop="managerCreatetime"
                    label="创建时间"
                    width="150">
            </el-table-column>
            <el-table-column
                    prop="managerLastmodify"
                    label="最后修改时间"
                    width="150">
            </el-table-column>

            <el-table-column
                    fixed="right"
                    label="操作"
                    width="150">

                <template slot-scope="scope">
                    <el-button @click="powerClick(scope.row)" type="text" size="small">授权</el-button>
                    <el-button @click="editClick(scope.row)" type="text" size="small">编辑</el-button>
                    <el-button @click="deleteClick(scope.row.managerId)" type="text" size="small">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
    </template>

    <!--powerClick事件-->
    <el-dialog title="角色权限管理" :visible.sync="dialogRoleVisible" width="255px">

        <el-checkbox-group v-model="checkedRoles" @change="handleCheckedRolesChange">
            <el-checkbox v-for="role in roles" :label="role.roleId" :key="role.roleId">{{role.roleName}}</el-checkbox>
        </el-checkbox-group>

    </el-dialog>

    <!--分页-->
    <el-pagination
            background
            layout="prev, pager, next,sizes,jumper"
            :total="page.total"
            :page-size="page.size"
            @current-change="pagechange"
            @pre-click="pre"
            @next-click="next"
            @size-change="sizechange"

    >
    </el-pagination>

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
                checkedRoles:[],
                roles:[],
                param:'',
                list:[],
                page:{
                    total:0,
                    index:1,
                    size:10
                },
                dialogRoleVisible:false,//授权角色
                dialogFormVisible: false,//增加信息
                manager: {},
                formLabelWidth: '100px',
                imageUrl: '',
               prop:'managerId',
                order:'asc',
                rules: {
                    managerName: [
                        {required: true, message: '请输入管理员姓名', trigger: 'blur'},
                        {min:2,max:50,message:'输入的字符最少为2个',trigger: 'blur'},

                    ],
                    managerSex: [
                        {required: true, message: '请选择性别', trigger: 'change'}
                    ],
                    managerPhone: [
                        { required: true, message: '请输入手机号', trigger: 'blur'},
                        {pattern:/^1(3|4|5|6|7|8|9)\d{9}$/,message: '请输入正确的手机号码'}

                    ],
                    managerIdcard: [
                        { required: true, message: '请输入身份证号', trigger: 'blur'},
                        {pattern:/^(^\d{15} $)|(^\d{17}([0-9]|X|x)$)$/,message: '请输入合法的身份证号码'}
                    ],
                },
                currentmanagerid:0,


            }

        },
        created:function(){
            this.getdata(this.page.index,this.page.size)
            this.getroles()
        },
        methods: {
            <!--角色权限管理选中时的触发事件-->
            handleCheckedRolesChange:function(){
                var ids=[];
              for (var i=0;i<this.checkedRoles.length;i++)
              {
                  ids.push(this.checkedRoles[i])
              }
              var data={"roleids":ids.join(","),"managerid":this.currentmanagerid}
                var self=this
                axios.post("<%=basePath%>admin/manager/savepower",Qs.stringify(data))//读取role权限
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.getdata()
                            self.$message({
                                type: 'success',
                                message: '已保存!'
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
            <!--点击“授权”触发事件-->
            powerClick(row) {
                var roles=row.roles
                this.checkedRoles=[]
                for(var i=0;i<roles.length;i++)
                {
                    this.checkedRoles.push(roles[i].roleId)
                }
                this.currentmanagerid=row.managerId
                this.dialogRoleVisible=true//弹出dialog授权角色

            },

            deleteall(){
              var rows=  this.$refs.tb1.selection //获取选中的数据
                var ids=[]
                for(var i=0;i<rows.length;i++)
                {
                    ids.push(rows[i].managerId)

                }
                console.log(ids);
                var data={"ids":ids.join(',')}
                var self=this
                if(ids.length<=0)
                {
                    self.$message({
                        type: 'error',
                        message: '请选择要删除的数据!'
                    });
                    return
                }
                axios.post("<%=basePath%>admin/manager/deleteAll", Qs.stringify(data) )
                    .then(function (response) {
                        if (response.data.code == '10000') {

                            self.getdata()
                            self.$message({
                                type: 'success',
                                message: '删除成功!'
                            });
                        }
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
            },
            <!--@keyup.enter search搜索-->
            search:function(str){
                    console.log(str)
                console.log(this.param)
                this.getdata()
            },
            <!--排序 传过来对象-->
            sort:function(e){
                this.prop=e.prop
                if(e.order=="ascending")
                {

                    this.order='asc'
                }
                else{
                    this.order='desc'
                }
                this.getdata()

            },
            <!--批量导入失败-->
            importfail:function(err,file,fileList){
                this.$message({
                    type: 'error',
                    message: '导入失败!'
                });
            },
            <!--批量导入成功-->
            importsuccess:function(response,file,fileList){

                if(response.code=="10000")
                {
                    this.$message({
                        type: 'success',
                        message: '上传成功!'
                    });
                    this.getdata()
                }
                else
                {
                    this.$message({
                        type: 'error',
                        message: '上传失败!'
                    });
                }
            },
            <!--click事件每次增加都重置manager-->
            opensave()
            {
                this.dialogFormVisible=true
                this.resetForm('manager');
                this.manager={};
            },
            <!--修改信息-->
            editClick(row){
                this.manager=row;
                this.dialogFormVisible=true
                this.imageUrl=row.managerImg

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
            save(){

                var self = this
                axios.post("<%=basePath%>admin/manager/saveOrupdate", Qs.stringify(self.manager) )
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.dialogFormVisible=false
                            self.getdata()
                            self.$message({
                                type: 'success',
                                message: '操作成功!'
                            });
                        }
                        else {
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
            handleAvatarSuccess(res, file) {
                this.imageUrl = URL.createObjectURL(file.raw);
                if(res.code=="10000")
                {
                    this.manager.managerImg=res.obj
                }
            },
            beforeAvatarUpload(file) {
                const isJPG = file.type === 'image/jpeg';
                const isLt2M = file.size / 1024 / 1024 < 2;

                if (!isJPG) {
                    this.$message.error('上传头像图片只能是 JPG 格式!');
                }
                if (!isLt2M) {
                    this.$message.error('上传头像图片大小不能超过 2MB!');
                }
                return isJPG && isLt2M;
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
                    axios.get("<%=basePath%>admin/manager/delete", {
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
            sizechange: function (size) {
                this.page.size = size
                this.getdata()
            },
            pre: function () {
                this.page.index--;
                this.getdata()
            },
            next: function () {
                this.page.index++;
                this.getdata()
            },
            pagechange: function (index) {
                this.page.index = index
                this.getdata()
            },
            getdata: function () {
                var data = {
                    'index': this.page.index,
                    'size': this.page.size,
                    'order':this.order,
                    'prop':this.prop,
                    'param':this.param
                }
                var self = this
                axios.get("<%=basePath%>admin/manager/list", {
                    params: data
                })
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.list = response.data.obj.list
                            self.page.total = response.data.obj.total
                        }
                    })
                    .catch(function (error) {
                        console.log(error);
                    });

            },

            getroles: function () {
                var self = this
                axios.get("<%=basePath%>admin/role/list")
                    .then(function (response) {
                        if (response.data.code == '10000') {
                            self.roles = response.data.obj
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
