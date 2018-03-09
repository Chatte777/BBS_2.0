<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="mountainMaster.MountainMaster"%>
<%@ page import="mountainMaster.MountainMasterDAO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="mountainReply.MountainReply"%>
<%@ page import="mountainReply.MountainReplyDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="mountainFile.MountainFile"%>
<%@ page import="mountainFile.MountainFileDAO"%>
<%@ page import="mountainReReply.MountainReReply"%>
<%@ page import="mountainReReply.MountainReReplyDAO"%>


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

		int mountainNo = 0;
		if (request.getParameter("mountainNo") != null) {
			mountainNo = Integer.parseInt(request.getParameter("mountainNo"));
		}

		if (mountainNo == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'mountain.jsp'");
			script.println("</script>");
		}
		MountainMaster mountainMaster = new MountainMasterDAO().getMountainMaster(mountainNo);
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
						<td colspan="3"><%=mountainMaster.getMountainTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
					.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="3"><%=mountainMaster.getMountainMakeUser()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="3"><%=mountainMaster.getMountainMakeDt().substring(0, 11)
					+ mountainMaster.getMountainMakeDt().substring(11, 13) + "시"
					+ mountainMaster.getMountainMakeDt().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="3" style="min-height: 200px; text-align: center;">
							<%
								ArrayList<MountainFile> fileList = new MountainFileDAO().getList(mountainMaster.getMountainNo());

								for (MountainFile file : fileList) {
							%>
							<div style="width: 100%; text-algin: center;">
								<%
									out.write("<img src=\"images/uploadFile/mountainFile/"
												+ java.net.URLEncoder.encode(file.getFileServerName(), "UTF-8")
												+ "\" style=\"width:100%; max-width:760px; vertical-align:middle\">" + "</a><br><br>");
								%>

							</div> <%
 	}
 %>

							<p class="text-left">
								<%=mountainMaster.getMountainContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
					.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></p>
						</td>
					</tr>
				</tbody>
			</table>

			<table class="table table-striped">
				<tbody>
					<%
						MountainReplyDAO mountainReplyDAO = new MountainReplyDAO();
						ArrayList<MountainReply> list = mountainReplyDAO.getList(mountainNo);

						MountainReReplyDAO mountainReReplyDAO = new MountainReReplyDAO();

						for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td align="center"><a onclick="reReplyClick('<%=list.get(i).getReplyNo()%>')" style="text-decoration: none; color: #000000;"><%=list.get(i).getReplyNo()%></a></td>
						<td align="left" style="word-break: break-all;"><%=list.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
						<td align="center" style="width: 5%;">
							<%
								if (userID != null && userID.equals(list.get(i).getReplyMakeUser())) {
							%> <a onclick="modifyClick('<%=list.get(i).getReplyContent()%>', '<%=list.get(i).getReplyNo()%>')" type="button" class="glyphicon glyphicon-pencil" style="color: #cccccc" /> <a onclick="return confirm('정말로 삭제하시겠습니까?')" a href="mountainReplyDeleteAction.jsp?mountainNo=<%=mountainNo%>&replyNo=<%=list.get(i).getReplyNo()%>" type="button" class="close" aria-label="close"></a> <span aria-hidden="true">&times;</span> <%
 	}
 %>
						</td>
						<td style="width: 10%;"><%=list.get(i).getReplyMakeUser()%></td>
						<td style="width: 15%;"><%=list.get(i).getReplyMakeDt().substring(0, 11) + list.get(i).getReplyMakeDt().substring(11, 13)
						+ "시" + list.get(i).getReplyMakeDt().substring(14, 16) + "분"%></td>
					</tr>
					<%
						ArrayList<MountainReReply> listReReply = mountainReReplyDAO.getInnerList(mountainNo,
									list.get(i).getReplyNo());

							for (int j = 0; j < listReReply.size(); j++) {
					%>
					<tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
						<td align="center"><span class="glyphicon glyphicon-menu-right" style="color: #bbbbbb;">&nbsp;</span></td>

						<td align="left" style="word-break: break-all;"><%=listReReply.get(j).getReReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
							.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
						<td align="center" style="width: 5%;">
							<%
								if (userID != null && userID.equals(list.get(j).getReplyMakeUser())) {
							%> <a onclick="modifyClick'<%=list.get(j).getReplyContent()%>', '<%=list.get(j).getReplyNo()%>')" type="button" class="glyphicon glyphicon-pencil" style="color: #cccccc" /> <a onclick="return confirm('정말로 삭제하시겠습니까?')" a href="mountainReplyDeleteAction.jsp?mountainNo=<%=mountainNo%>&replyNo=<%=list.get(j).getReplyNo()%>" type="button" class="close" aria-label="close" /> <span aria-hidden="true">&times;</span> <%
 	}
 %>
						</td>
						<td><%=list.get(j).getReplyMakeUser()%></td>
						<td><%=list.get(i).getReplyMakeDt().substring(0, 11)
							+ list.get(i).getReplyMakeDt().substring(11, 13) + "시"
							+ list.get(i).getReplyMakeDt().substring(14, 16) + "분"%></td>
					</tr>
					<%
						}
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
			<input type="hidden" name="threadNo" value="<%=mountainMaster.getMountainNo()%>">
		</form>
		<a href="mountain.jsp" class="btn btn-primary">목록</a>
		<%
			if (userID != null && userID.equals(mountainMaster.getMountainMakeUser())) {
		%>
		<a href="mountainUpdate.jsp?mountainNo=<%=mountainNo%>" class="btn btn-priamry">수정</a> <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="mountainDeleteAction.jsp?mountainNo=<%=mountainNo%>" class="btn btn-priamry">삭제</a>
		<%
			}
		%>
		<a href="mountainWrite.jsp" class="btn btn-primary pull-right">글쓰기</a>
	</div>

	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

	<script>
	var updateFlag=1;
	var _replyNo=0;
	
	function modifyClick(replyContent, replyNo) {
		updateFlag=2;
		_replyNo=replyNo;
		document.getElementById("replyContent").value = replyContent;
	}
	
	function reReplyClick(replyNo) {
		updateFlag=3;
		_replyNo=replyNo;
		document.getElementById("replyContent").value = replyNo+"번 리플에 대한 대댓글을 작성하세요.";
	}

function replySubmit(){
	if(updateFlag==1){
		document.replyForm.action="mountainReplyAction.jsp";
		document.replyForm.method="post";
		document.replyForm.submit();
	} else if(updateFlag==2) {
		document.replyForm.action="mountainReplyUpdateAction.jsp?replyNo=" + _replyNo;
		document.replyForm.method="post";
		document.replyForm.submit();
	}
}
</script>
</body>
</html>