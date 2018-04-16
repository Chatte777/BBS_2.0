<%--
  Created by IntelliJ IDEA.
  User: IMTSOFT
  Date: 2018-04-15
  Time: 오후 2:15
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <center>
        <h2> 로그인 </h2>
        <form action="LoginProc.do" method="post">
            <table width="300" border="1">
                <tr>
                    <td width="120"> id </td>
                    <td width="180"><input type="text" name="id">id</td>
                </tr>
                <tr>
                    <td width="120"> pw </td>
                    <td width="180"><input type="password" name="password">password</td>
                </tr>
                <tr>
                    <td align="center" colspan="2">
                        <input type="submit" values="로그인">
                    </td>
                </tr>
            </table>
        </form>
    </center>

</body>
</html>
