<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "reply.ReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="replyVO" class="reply.ReplyVO" scope="page"/>
<jsp:setProperty name="replyVO" property="replyContent"/>
<jsp:setProperty name="replyVO" property="replyNo"/>
<jsp:setProperty name="replyVO" property="boardNo"/>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DREAMY CAT</title>
</head>
<body>
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
			if(replyVO.getReplyContent()==null){
				
			} else {
			    String boardName = request.getParameter("boardName");
				ReplyDAO replyDAO = new ReplyDAO(boardName);
				int result = replyDAO.update(replyVO.getBoardNo(), replyVO.getReplyNo(), replyVO.getReplyContent());
				
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
					script.println("location.href='boardView.jsp?boardName="+ boardName +"&boardNo=" + replyVO.getBoardNo() + "'");
					script.println("</script>");
				}
		}
		}
	%>
</body>
</html>