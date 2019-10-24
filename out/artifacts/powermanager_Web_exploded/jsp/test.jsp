<%--
  Created by IntelliJ IDEA.
  User: 14908
  Date: 2019/10/8
  Time: 11:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
    <%
        String path = request.getContextPath();
        String basePath = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + path + "/";
    %>
</head>
<body>
this is test.jsp
</body>
</html>
