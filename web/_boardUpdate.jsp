<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.BoardVO"%>
<%@ page import="board.BoardDAO"%>

	<%
		String userId = null;
		if (session.getAttribute("userID") != null) {
			userId = (String) session.getAttribute("userID");
		}
		if (userId == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
		int boardNo = 0;
		if (request.getParameter("boardNo") != null) {
			boardNo = Integer.parseInt(request.getParameter("boardNo"));
		}

		if (boardNo == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'board.jsp'");
			script.println("</script>");
		}

		String boardName = request.getParameter("boardName");
		BoardVO boardVO = new BoardDAO(boardName).getBoardVO(boardNo);
		if (!userId.equals(boardVO.getBoardMakeUser())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}
	%>

	<div class="container">
		<div class="row">
			<form method="post" action="boardUpdateAction.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>" enctype="multipart/form-data">
				<table class="table table-striped"
					style="text-align: center; border: 1px solid #dddddd">
					<thead>
						<tr>
							<th colspan="2"
								style="background-color: #eeeeee; text-align: center;">게시판
								글 수정 양식</th>
						</tr>
					</thead>

					<tbody>
						<tr>
						<tr>
							<td><input type="text" class="form-control"
								placeholder="글 제목" name="boardTitle" maxlength="50"
								value="<%=boardVO.getBoardTitle()%>"></td>
							<td><select class="form-control" name="boardAuthorize"><option value="1" <%if (boardVO.getBoardAuthorize()==1){ %>selected <%}%>>전체공개</option><option value="2"  <%if (boardVO.getBoardAuthorize()==2){ %>selected <%}%>>나만보기</option></select></td>
						</tr>
						<tr>
							<td colspan="2"><textarea type="text" class="form-control"
									placeholder="글 내용" name="boardContent" maxlength="2048"
									style="height: 350px;"><%=boardVO.getBoardContent()%></textarea></td>
						</tr>
						<jsp:include page="_fileUpload.jsp" flush="false"/>
					</tbody>
				</table>
				<input type="submit" class="btn btn-primary pull-right" value="글수정">
			</form>

		</div>
	</div>