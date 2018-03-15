<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "board.BoardVO" %>
<%@ page import = "board.BoardDAO"%>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>



	<%
		String userId = null;
		if(session.getAttribute("userID") != null){
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
			if(request.getParameter("boardNo") != null){
				boardNo = Integer.parseInt(request.getParameter("boardNo"));
			}
		
			if(boardNo == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>"); 
			}

			String boardName = request.getParameter("boardName");
			BoardDAO boardDAO = new BoardDAO(boardName);
			BoardVO boardVO = boardDAO.getBoardVO(boardNo);

			if(!userId.equals(boardVO.getBoardMakeUser())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>"); 
			} else {
					int result = boardDAO.delete(boardNo);
					
					if(result == -1){
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('글 삭제에 실패했습니다.')");
						script.println("history.back()");
						script.println("</script>");
					}
					else
					{
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href='board.jsp?boardName="+boardName+"'");
						script.println("</script>");
					}
		}
	%>