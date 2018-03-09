<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="mountainMaster.MountainMaster" %>
<%@ page import="mountainMaster.MountainMasterDAO" %>




<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width", initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DREAMY CAT</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		if (userID==null){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>"); 
		}
		int mountainNo = 0;
		if(request.getParameter("mountainNo") != null){
			mountainNo = Integer.parseInt(request.getParameter("mountainNo"));
		}
		
		if(mountainNo == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'mountain.jsp'");
			script.println("</script>"); 
		}
		
		MountainMaster mountainMaster = new MountainMasterDAO().getMountainMaster(mountainNo);
		if(!userID.equals(mountainMaster.getMountainMakeUser())){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>"); 
		}
	%>
	
	
	<jsp:include page="_headNav.jsp" flush="false"/>
	
	<div class="container">
		<div class="row">
			<form method="post" action="mountainUpdateAction.jsp?mountainNo=<%=mountainNo%>" enctype="multipart/form-data">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<tr>
								<td><input type="text" class="form-control" placeholder="글 제목" name="mountainTitle" maxlength="50" value="<%=mountainMaster.getMountainTitle()%>"></td>
							</tr>
							<tr>
								<td><textarea type="text" class="form-control" placeholder="글 내용" name="mountainContent" maxlength="2048" style="height: 350px;"><%=mountainMaster.getMountainContent()%></textarea></td>
							</tr>
							<jsp:include page="_fileUpload.jsp" flush="false"/>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>
			
		</div>
	</div>
	
	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>