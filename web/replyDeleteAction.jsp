<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "reply.ReplyVO" %>
<%@ page import = "reply.ReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>

<% request.setCharacterEncoding("UTF-8"); %>

	<%
		String userId = null;
		String boardName = request.getParameter("boardName");
		int boardNo = Integer.parseInt(request.getParameter("boardNo"));

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
				replyNo = Integer.parseInt(request.getParameter("replyNo"));
			}
		
			if(replyNo == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'boardView.jsp?boardName="+boardName+"&boardNo="+boardNo+"'");
				script.println("</script>"); 
			}

		ReplyVO replyVO = null;
		ReplyDAO replyDAO = new ReplyDAO(boardName);
		replyVO = replyDAO.getReply(boardNo, replyNo);

		if(!userId.equals(replyVO.getReplyMakeUser())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>"); 
			} else {
			int result=0;
				if(replyVO.getHasReReply()==1) result = replyDAO.delete(replyVO.getBoardNo(), replyNo);
				else if(replyVO.getHasReReply()==2) result = replyDAO.deleteFail(replyVO.getBoardNo(), replyNo);
					
					if(result == -1){
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('댓글 삭제에 실패했습니다.')");
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