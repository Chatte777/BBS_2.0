<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="threadMaster.ThreadMaster"%>
<%@ page import="threadMaster.ThreadMasterDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="threadReply.ThreadReply"%>
<%@ page import="threadReply.ThreadReplyDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="threadFile.ThreadFile"%>
<%@ page import="threadFile.ThreadFileDAO"%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DREAMY CAT</title>
</head>
<body>
	<%
		String userID = null;
		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}

		int threadNo = 0;
		if (request.getParameter("threadNo") != null) {
			threadNo = Integer.parseInt(request.getParameter("threadNo"));
		}

		if (threadNo == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'thread.jsp'");
			script.println("</script>");
		}
		ThreadMaster threadMaster = new ThreadMasterDAO().getThreadMaster(threadNo);
	%>


	<jsp:include page="_headNav.jsp" flush="false" />

	<div class="container">
		<div class="row">
			<table class="table table-striped" style="text-align: center; border: 1px solid #dddddd; word-break: break-all;">
				<thead>
					<tr>
						<th colspan="4" style="background-color: #eeeeee; text-align: center;">게시판 글</th>
					</tr>
				</thead>

				<tbody>
					<tr>
						<td style="width: 20%;">글제목</td>
						<td colspan="3">
						<%
							if(threadMaster.getThreadAuthorize()==2){
						%><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
								}
								%>
						<%=threadMaster.getThreadTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
					.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
					</td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="3"><%=threadMaster.getThreadMakeUser()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="3"><%=threadMaster.getThreadMakeDt().substring(0, 11) + threadMaster.getThreadMakeDt().substring(11, 13)
					+ "시" + threadMaster.getThreadMakeDt().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="3" style="min-height: 200px; text-align: center;">
							<%
								ArrayList<ThreadFile> fileList = new ThreadFileDAO().getList(threadMaster.getThreadNo());

								for (ThreadFile file : fileList) {
									%>
							<div style="width: 100%; text-algin: center;">
								<%
									out.write("<img src=\"images/uploadFile/threadFile/" 
											+ java.net.URLEncoder.encode(file.getFileServerName(), "UTF-8") + "\" style=\"width:100%; max-width:760px; vertical-align:middle\">"
											+ "</a><br><br>");						
								%>

							</div> <%
								}
							%>

							<p class="text-left">
								<%=threadMaster.getThreadContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
					.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></p>
						</td>
					</tr>
				</tbody>
			</table>

			<table class="table table-striped">
				<tbody>
					<%
						ThreadReplyDAO threadReplyDAO = new ThreadReplyDAO();
						ArrayList<ThreadReply> list = threadReplyDAO.getList(threadNo);

						for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td align="center"><%=list.get(i).getReplyNo()%></td>
						<td align="left" style="word-break: break-all;"><%=list.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
						<td align="center" style="width: 5%;">
						<%
							if (userID != null && userID.equals(list.get(i).getReplyMakeUser())) {
						%>
							<a onclick="myFunction('<%=list.get(i).getReplyContent()%>', '<%=list.get(i).getReplyNo()%>')" type="button" class="glyphicon glyphicon-pencil" style="color:#cccccc"/>
							<a onclick="return confirm('정말로 삭제하시겠습니까?')" a href="threadReplyDeleteAction.jsp?threadNo=<%=threadNo%>&replyNo=<%=list.get(i).getReplyNo()%>" type="button" class="close" aria-label="close"/> <span aria-hidden="true">&times;</span>
						 <%
							}
						%>
						</td>
						<td style="width: 10%;"><%=list.get(i).getReplyMakeUser()%></td>
						<td style="width: 15%;"><%=list.get(i).getReplyMakeDt().substring(0, 11) + list.get(i).getReplyMakeDt().substring(11, 13)
						+ "시" + list.get(i).getReplyMakeDt().substring(14, 16) + "분"%></td>
					</tr>
					<%
						}
					%>
				</tbody>
			</table>
		</div>
		<form name="replyForm">
				<table class="table table-condensed">
					<tbody>
						<tr>
							<td style="width: 90%;"><textarea class="form-control" placeholder="댓글" name="replyContent" id="replyContent" maxlength="2048" style="height: 150px;"></textarea></td>
							<td style="width: 10%; vertical-align: bottom;" align="center"><input type="button" onclick="replySubmit()" class="btn btn-primary pull-right" value="댓글작성"></td>
						</tr>		
					</tbody>
				</table>
			<input type="hidden" name="threadNo" value="<%=threadMaster.getThreadNo()%>">
		</form>
		<a href="thread.jsp" class="btn btn-primary">목록</a>
		<%
			if (userID != null && userID.equals(threadMaster.getThreadMakeUser())) {
		%>
		<a href="threadUpdate.jsp?threadNo=<%=threadNo%>" class="btn btn-priamry">수정</a> <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="threadDeleteAction.jsp?threadNo=<%=threadNo%>" class="btn btn-priamry">삭제</a>
		<%
			}
		%>
		<a href="threadWrite.jsp" class="btn btn-primary pull-right">글쓰기</a>

	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>
	
		<script>
	var updateFlag=1;
	var _replyNo=0;
	
function myFunction(replyContent, replyNo) {
	updateFlag=2;
	_replyNo=replyNo;
	document.getElementById("replyContent").value = replyContent;
}

function replySubmit(){
	if(updateFlag==1){
		document.replyForm.action="threadReplyAction.jsp";
		document.replyForm.method="post";
		document.replyForm.submit();
	} else if(updateFlag==2) {
		document.replyForm.action="threadReplyUpdateAction.jsp?replyNo=" + _replyNo;
		document.replyForm.method="post";
		document.replyForm.submit();
	}
}
</script>
</body>
</html>