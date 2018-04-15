<%--
  Created by IntelliJ IDEA.
  User: IMTSOFT
  Date: 2018-04-15
  Time: 오후 2:40
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
    <title>Title</title>
</head>
<body>
<h2>계산기</h2>
<form action="mvctestProc.jsp" method="post">
    <table>
        <tr>
            <td><input type="text" name="exp1"></td>
            <td>
                <select name="exp2">
                    <option values="+">+</option>
                    <option values="-">-</option>
                    <option values="X">X</option>
                    <option values="/">/</option>
                </select>
            </td>
            <td><input type="text" name="exp3"></td>
            <td><input type="submit" name="exp4" values="결과보기"></td>
        </tr>
    </table>
</form>

</body>
</html>
