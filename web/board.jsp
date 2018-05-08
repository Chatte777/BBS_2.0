<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width", initial-scale="1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>DREAMKY KAT</title>
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
    <script src="js/errorAlert.js"></script>
</head>
<body>
<c:if test="${param.boardName==null}">
    <script>errorAlert('11')</script>
</c:if>
<jsp:include page="_headNav.jsp" flush="false"/>
<jsp:include page="_board.jsp" flush="false" />

<script src="js/bootstrap.js"></script>
</body>
</html>