<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "reply.ReplyVO" %>
<%@ page import = "reply.ReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>

<jsp:useBean id="replyVO" class="reply.ReplyVO" scope="page"/>
<jsp:setProperty name="replyVO" property="replyNo"/>
<jsp:setProperty name="replyVO" property="boardNo"/>

<% request.setCharacterEncoding("UTF-8"); %>


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
			}
		
			int replyNo = 0;
			if(request.getParameter("replyNo") != null){
				replyNo = replyVO.getReplyNo();
			}
		
			if(replyNo == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'board.jsp'");
				script.println("</script>"); 
			}

			if(!userId.equals(replyVO.getReplyMakeUser())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>"); 
			} else {
				String boardName = request.getParameter("boardName");

				ReplyDAO replyDAO = new ReplyDAO(boardName);
				int result = replyDAO.delete(replyVO.getBoardNo(), replyNo);
					
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
						script.println("location.href='boardView.jsp?boardName="+boardName+"&boardNo="+replyVO.getBoardNo()+"'");
						script.println("</script>");
					}
		}
	%>
</body>
</html>