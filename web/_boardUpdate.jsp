<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script type="text/javascript" src="smartEditor\js\HuskyEZCreator.js" charset="utf-8"></script>

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
			<form method="post" name="boardForm">
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
							<td colspan="2"><textarea type="text" class="form-control" name="boardContent" id="boardContent"
									placeholder="글 내용" maxlength="2048"
									style="height: 350px;"><%=boardVO.getBoardContent().replaceAll("\n", "<br>").replaceAll(" ", "&nbsp;")%></textarea></td>
						</tr>
						<jsp:include page="_fileUpload.jsp" flush="false"/>
					</tbody>
				</table>
				<input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="글수정">
			</form>

		</div>
	</div>


<script type="text/javascript">
    var oEditors = [];

    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "boardContent",
        sSkinURI: "smartEditor\\SmartEditor2Skin.html",
        fCreator: "createSEditor2"
    });

    // ‘저장’ 버튼을 누르는 등 저장을 위한 액션을 했을 때 submitContents가 호출된다고 가정한다.
    function contentSubmit() {
        // 에디터의 내용이 textarea에 적용된다.
        oEditors.getById["boardContent"].exec("UPDATE_CONTENTS_FIELD", []);

        // 에디터의 내용에 대한 값 검증은 이곳에서
        // document.getElementById("ir1").value를 이용해서 처리한다.

        try {
            document.boardForm.action="boardUpdateAction.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>";
            document.boardForm.enctype="multipart/form-data";
            document.boardForm.method="post";
            document.boardForm.submit();
        } catch (e) {
        }
    }
</script>