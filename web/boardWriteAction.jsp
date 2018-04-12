<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="java.net.URLEncoder" %>


<%
	request.setCharacterEncoding("UTF-8");
%>

	<%
		String userId = null;

		if (session.getAttribute("userID") != null) {
			userId = (String) session.getAttribute("userID");
		}
		if (userId == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = '/login.jsp'");
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
				int boardAuthorize = Integer.parseInt(request.getParameter("boardAuthorize"));
				String boardPassword = null;

				if(boardAuthorize==2){
					if(request.getParameter("boardPassword")!=null) {
					    if(request.getParameter("boardPassword").equals("")) boardPassword="0000";
					    else boardPassword = request.getParameter("boardPassword");
					}
					else boardPassword = "0000";
				}

				int result = boardDAO.write(request.getParameter("boardTitle"), userId, request.getParameter("boardContent"),
						boardAuthorize, Integer.parseInt(request.getParameter("boardNo")), boardPassword);

				if (result == -1) {
					Cookie reloadFlag = new Cookie("reloadFlag", "1");
					reloadFlag.setMaxAge(5);
					Cookie cookieBoardTitle = new Cookie("boardTitle", URLEncoder.encode(request.getParameter("boardTitle"),"utf-8"));
					cookieBoardTitle.setMaxAge(5);
                    Cookie cookieBoardContent = new Cookie("boardContent", URLEncoder.encode(request.getParameter("boardContent"),"utf-8"));
					cookieBoardContent.setMaxAge(5);
					Cookie cookieBoardAuthorize = new Cookie("boardAuthorize", request.getParameter("boardAuthorize"));
					cookieBoardAuthorize.setMaxAge(5);

					response.addCookie(reloadFlag);
					response.addCookie(cookieBoardTitle);
					response.addCookie(cookieBoardContent);
					response.addCookie(cookieBoardAuthorize);

					PrintWriter script = response.getWriter();

					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("location.href='boardWrite.jsp?boardName="+boardName+"'");
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