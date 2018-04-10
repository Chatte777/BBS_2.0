<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>

<%
	request.setCharacterEncoding("UTF-8");

		String userID = null;

		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
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
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}

		String boardName = request.getParameter("boardName");

		BoardDAO boardDAO = new BoardDAO(boardName);
		BoardVO boardVO = boardDAO.getBoardVO(boardNo);

		if (!userID.equals(boardVO.getBoardMakeUser())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {
			if (request.getParameter("boardTitle") == null
					|| request.getParameter("boardContent") == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				int result = boardDAO.update(Integer.parseInt(request.getParameter("boardNo")),
						request.getParameter("boardTitle"),
						request.getParameter("boardContent"),
						Integer.parseInt(request.getParameter("boardAuthorize")));

				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('수정 되었습니다.')");
						script.println("location.href='boardView.jsp?boardName="+boardName+"&boardNo="+boardNo+"'");
						script.println("</script>");
					}
				}
		}
	%>