<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/custom.css">
<title>DREAMY CAT</title>
</head>
<body>

<c:forEach var="aCookie" items="<%=request.getCookies()%>">
	<c:if test="${aCookie.name=='idRemember'}">
		<c:set var="userId" value="${aCookie.value}"/>
	</c:if>
	<c:if test="${aCookie.name=='pwRemember'}">
		<c:set var="userPassword" value="${aCookie.value}"/>
	</c:if>
</c:forEach>

	<jsp:include page="_headNav.jsp" flush="false"/>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="/login.do">
					<h3 style="text-align: center;">로그인화면</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="userId" maxlength="20" value="${userId}">
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20" value="${userPassword}">
					</div>
					<div class="form-check">
						<input class="form-check-input" type="checkbox" value="1" name="accountRememberYn" id="accountRememberYn"
							   <c:if test="${userPassword!=null}">checked</c:if>
							   >
						<label class="form-check-label" for="accountRememberYn">
							로그인정보를 저장하시겠습니까?
						</label>
					</div>
					<input type="submit" class="btn btn-primary form-control" value="로그인">
				</form>
			</div>
		</div>
	</div>
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>