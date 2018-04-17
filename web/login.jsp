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
<%
	Cookie[] cookies = request.getCookies();
	String idRemember=null;
	String pwRemember=null;

	for(int i=0; i<cookies.length; i++){
		if("idRemember".equals(cookies[i].getName())) idRemember=cookies[i].getValue();
		if("pwRemember".equals(cookies[i].getName())) pwRemember=cookies[i].getValue();
	}
%>
	<jsp:include page="_headNav.jsp" flush="false"/>
	<div class="container">
		<div class="col-lg-4"></div>
		<div class="col-lg-4">
			<div class="jumbotron" style="padding-top: 20px;">
				<form method="post" action="/login.do">
					<h3 style="text-align: center;">로그인화면</h3>
					<div class="form-group">
						<input type="text" class="form-control" placeholder="아이디" name="userId" maxlength="20" <%if(idRemember!=null){%>value="<%=idRemember%>"<%}%>>
					</div>
					<div class="form-group">
						<input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20" <%if(pwRemember!=null){%>value="<%=pwRemember%>"<%}%>>
					</div>
					<div class="form-check">
						<input class="form-check-input" type="checkbox" value="1" name="accountRememberYn" id="accountRememberYn"<%if(pwRemember!=null){%>checked<%}%>>
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