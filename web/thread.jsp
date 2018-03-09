<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="threadMaster.ThreadMasterDAO"%>
<%@ page import="threadMaster.ThreadMaster"%>
<%@ page import="java.util.ArrayList"%>



<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DREAMY CAT</title>
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String)session.getAttribute("userID");
		}
		int pageNumber = 1;
		if(request.getParameter("pageNumber") != null){
			pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
		}
	%>


	<jsp:include page="_headNav.jsp" flush="false" />

	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
				<thead>
					<tr>
						<th style="background-color: #eeeeee; text-align: center;">댓글</th>
						<th style="background-color: #eeeeee; text-align: center;">제목</th>
						<th style="background-color: #eeeeee; text-align: center;">작성자</th>
						<th style="background-color: #eeeeee; text-align: center;">작성일</th>
					</tr>
				</thead>

				<tbody>
					<%
					ThreadMasterDAO threadMasterDAO = new ThreadMasterDAO();
					if(userID==null) userID="null";
					ArrayList<ThreadMaster> list = threadMasterDAO.getList(pageNumber, userID);
					if("null".equals(userID)) userID = null;

					for(int i=0; i<list.size(); i++){
						int replyCnt=threadMasterDAO.getReplyCnt(list.get(i).getThreadNo()); 
						int replyColorFlag = threadMasterDAO.getReplyColor(list.get(i).getThreadNo());
								
				%>
					<tr>
						<td <%
							if(replyColorFlag==1){%> style="color: #873286;" <%}
							else if(replyColorFlag==2){%> style="color:#DE2A45;" <%}
							else if(replyColorFlag==3){%> style="color:#F5762C;" <%}
							else if(replyColorFlag==4){%> style="color:#10BF00;" <%}
							else if(replyColorFlag==5){%> style="color:#2865BF;" <%}
							else if(replyColorFlag==6){%> style="color:black;" <%}
						%>>
							<%if(replyCnt!=0){%><%=replyCnt%>
							<%}%>
						</td>
						<td>
						<%
							if(list.get(i).getThreadAuthorize()==2){
						%><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
								}
								%>
						<a href="threadView.jsp?threadNo=<%= list.get(i).getThreadNo() %>"><%= list.get(i).getThreadTitle() %></a>
						</td>
						<td><%= list.get(i).getThreadMakeUser() %></td>
						<td><%= list.get(i).getThreadMakeDt().substring(0,11)+list.get(i).getThreadMakeDt().substring(11,13)+"시"+list.get(i).getThreadMakeDt().substring(14,16)+"분" %></td>
					</tr>
					<%
					}				
				%>
				</tbody>
			</table>

			<%
				if(pageNumber!= 1){
			%>
			<a href="thread.jsp?pageNumber=<%=pageNumber-1%>" class="btn btn-successs btn-arrow-left">이전</a>
			<%
				} if(threadMasterDAO.nextPage(pageNumber+1)) {
			%>
			<a href="thread.jsp?pageNumber=<%=pageNumber+1%>" class="btn btn-successs btn-arrow-right">다음</a>
			<%
				}
			%>

			<a href="threadWrite.jsp" class="btn btn-primary pull-right">글쓰기</a>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
</body>
</html>