<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "reReply.ReReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="reReplyVO" class="reReply.ReReplyVO" scope="page"/>
<jsp:setProperty name="reReplyVO" property="boardNo"/>
<jsp:setProperty name="reReplyVO" property="replyNo"/>

	<%
		String userId = null;
		if(session.getAttribute("userId") != null){
			userId = (String) session.getAttribute("userId");
		}
		if (userId == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'Login.jsp'");
			script.println("</script>");
		} else{
			if(request.getParameter("replyContent")==null){
				
			} else {
			    String boardName = request.getParameter("boardName");
			    String reReplyContent = request.getParameter("replyContent");

				ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
				int result = reReplyDAO.write(reReplyVO.getBoardNo(), reReplyVO.getReplyNo(), userId, reReplyContent);
				
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='./boardView.jsp?boardName="+boardName+"&boardNo=" + reReplyVO.getBoardNo() + "'");
					script.println("</script>");
				}
		}
		}
	%>








