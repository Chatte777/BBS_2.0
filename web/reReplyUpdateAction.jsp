<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "reReply.ReReplyDAO" %>
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
		} else{

			    String boardName = request.getParameter("boardName");
				ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
				int result = reReplyDAO.update(Integer.parseInt(request.getParameter("boardNo")), Integer.parseInt(request.getParameter("replyNo")), Integer.parseInt(request.getParameter("reReplyNo")), request.getParameter("replyContent"));
				
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('대댓글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='GetBoard.do?boardName="+ boardName +"&boardNo=" + request.getParameter("boardNo") + "'");
					script.println("</script>");
				}
		}

	%>