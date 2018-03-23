<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.BoardDAO" %>


<%
	request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="boardVO" class="board.BoardVO" scope="page" />
<jsp:setProperty name="boardVO" property="boardTitle" />
<jsp:setProperty name="boardVO" property="boardContent" />


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
		} else {
			if (request.getParameter("boardTitle") == null
					|| request.getParameter("boardContent") == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				String boardName = request.getParameter("boardName");
				BoardDAO boardDAO = new BoardDAO(boardName);
				int result = boardDAO.write(request.getParameter("boardTitle"), userId,
						request.getParameter("boardContent"), Integer.parseInt(request.getParameter("boardAuthorize")));

				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href='board.jsp?boardName="+boardName+"'");
						script.println("</script>");
				}
			}
		}
	%>