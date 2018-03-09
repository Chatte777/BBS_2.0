<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="threadMaster.ThreadMaster" %>
<%@ page import="threadMaster.ThreadMasterDAO" %>




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
		int threadNo = 0;
		if(request.getParameter("threadNo") != null){
			threadNo = Integer.parseInt(request.getParameter("threadNo"));
		}
		
		if(threadNo == 0){
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'thread.jsp'");
			script.println("</script>"); 
		}
		
		ThreadMaster threadMaster = new ThreadMasterDAO().getThreadMaster(threadNo);
		if(!userID.equals(threadMaster.getThreadMakeUser())){
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
			<form method="post" action="threadUpdateAction.jsp?threadNo=<%=threadNo%>" enctype="multipart/form-data">
				<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2" style="background-color: #eeeeee; text-align: center;">게시판 글 수정 양식</th>
						</tr>
					</thead>
					
					<tbody>
						<tr>
							<tr>
								<td><input type="text" class="form-control" placeholder="글 제목" name="threadTitle" maxlength="50" value="<%=threadMaster.getThreadTitle()%>"></td>
								<td><select class="form-control" name="threadAuthorize"><option value="1" <%if (threadMaster.getThreadAuthorize()==1){ %>selected <%}%>>전체공개</option><option value="2"  <%if (threadMaster.getThreadAuthorize()==2){ %>selected <%}%>>나만보기</option></select></td>
							</tr>
							<tr>
								<td colspan="2"><textarea type="text" class="form-control" placeholder="글 내용" name="threadContent" maxlength="2048" style="height: 350px;"><%=threadMaster.getThreadContent()%></textarea></td>
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