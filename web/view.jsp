<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="bbs.Bbs"%>
<%@ page import="bbs.BbsDAO"%>
<%@ page import="file.FileDAO"%>
<%@ page import="file.FileDTO"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="reply.ReplyVO"%>
<%@ page import="reply.ReplyDAO"%>
<%@ page import="java.io.File"%>


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

		int bbsID = 0;
		if (request.getParameter("bbsID") != null) {
			bbsID = Integer.parseInt(request.getParameter("bbsID"));
		}

		if (bbsID == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}
		Bbs bbs = new BbsDAO().getBbs(bbsID);
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
						<td colspan="3"><%=bbs.getBbsTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\n", "<br>")%></td>
					</tr>
					<tr>
						<td>작성자</td>
						<td colspan="3"><%=bbs.getUserID()%></td>
					</tr>
					<tr>
						<td>작성일자</td>
						<td colspan="3"><%=bbs.getBbsDate().substring(0, 11) + bbs.getBbsDate().substring(11, 13) + "시"
					+ bbs.getBbsDate().substring(14, 16) + "분"%></td>
					</tr>
					<tr>
						<td>내용</td>
						<td colspan="3" style="min-height: 200px; text-align: left;"><%=bbs.getBbsContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;").replaceAll(">", "&gt;")
					.replaceAll("\n", "<br>")%></td>
					</tr>

					<tr>
						<td colspan="2">
							<%
								ArrayList<FileDTO> fileList = new FileDAO().getList(bbs.getBbsID());

								for (FileDTO file : fileList) {
									out.write("<a href=\"" + request.getContextPath() + "/downloadAction?file="
											+ java.net.URLEncoder.encode(file.getFileServerName(), "UTF-8") + "\">"
											+ file.getFileClientName()
											//+ "(다운로드 횟수: " + file.getDownloadCount() 
											+ "</a><br>");
								}
							%>
						</td>
					</tr>
				</tbody>
			</table>

			<table class="table table-striped">
				<tbody>
					<%
						ReplyDAO replyDAO = new ReplyDAO();
						ArrayList<ReplyVO> list = replyDAO.getList(bbsID);

						for (int i = 0; i < list.size(); i++) {
					%>
					<tr>
						<td align="center"><%=list.get(i).getReplyID()%></td>
						<td align="left" style="word-break: break-all;"><%=list.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
						.replaceAll(">", "&gt;").replaceAll("\n", "<br>")%></td>
						<td align="center" style="width: 5%;">
							<%
								if (userID != null && userID.equals(list.get(i).getUserID())) {
							%> <a onclick="myFunction('<%=list.get(i).getReplyContent()%>', '<%=list.get(i).getReplyID()%>')" type="button" class="glyphicon glyphicon-pencil" style="color: #cccccc"></a> <a onclick="return confirm('정말로 삭제하시겠습니까?')" a href="boardDeleteAction.jsp?bbsId=<%=bbsID%>&replyNo=<%=list.get(i).getReplyID()%>" type="button" class="close" aria-label="close"> <span aria-hidden="true">&times;</span></a> <%
 	}
 %>
						</td>
						<td style="width: 10%;"><%=list.get(i).getUserID()%></td>
						<td style="width: 15%;"><%=list.get(i).getReplyDate().substring(0, 11) + list.get(i).getReplyDate().substring(11, 13)
						+ "시" + list.get(i).getReplyDate().substring(14, 16) + "분"%></td>
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
			<input type="hidden" name="bbsID" value="<%=bbs.getBbsID()%>">
		</form>



		<a href="bbs.jsp" class="btn btn-primary">목록</a>
		<%
			if (userID != null && userID.equals(bbs.getUserID())) {
		%>
		<a href="update.jsp?bbsID=<%=bbsID%>" class="btn btn-priamry">수정</a> <a onclick="return confirm('정말로 삭제하시겠습니까?')" href="boardDeleteAction.jsp?bbsID=<%=bbsID%>" class="btn btn-priamry">삭제</a>
		<%
			}
		%>
		<a href="write.jsp" class="btn btn-primary pull-right">글쓰기</a>

	</div>


	<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
	<script src="js/bootstrap.js"></script>

	<script>
		var updateFlag = 1;
		var _replyId = 0;

		function myFunction(replyContent, replyId) {
			updateFlag = 2;
			_replyId = replyId;
			document.getElementById("replyContent").value = replyContent;
		}

		function replySubmit() {
			if (updateFlag == 1) {
				document.replyForm.action = "replyAction.jsp";
				document.replyForm.method = "post";
				document.replyForm.submit();
			} else if (updateFlag == 2) {
				document.replyForm.action = "replyUpdateAction.jsp?replyID="
						+ _replyId;
				document.replyForm.method = "post";
				document.replyForm.submit();
			}
		}
	</script>
</body>
</html>