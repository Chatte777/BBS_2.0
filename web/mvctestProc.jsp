  Created by IntelliJ IDEA.
  User: IMTSOFT
  Date: 2018-04-15
  Time: 오후 2:44
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<center>
    <h2>결과보기</h2>
    <%
        String exp2 = request.getParameter("exp2");

        int result;


        if(exp2.equals("+")){
            %>
    결과는 ${param.exp1 +  param.exp3}
    <%
        }
    %>

</center>

</body>
</html>
