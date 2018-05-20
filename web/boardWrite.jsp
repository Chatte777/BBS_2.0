<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="viewport" content="width=device-width" , initial-scale="1">
	<link rel="stylesheet" href="css/bootstrap.css">
	<title>DREAMY KAT</title>
	<script src = 'js/errorAlert.js'></script>
</head>
<body>
	<c:if test="${param.boardName==null}">
		<script>errorAlert('12')</script>
	</c:if>
	<c:if test="${sessionScope.userId==null}">
		<script>errorAlert('1')</script>
	</c:if>

	<jsp:include page="_headNav.jsp" flush="false" />
	<jsp:include page="_boardWrite.jsp" flush="false" />
</body>
</html>