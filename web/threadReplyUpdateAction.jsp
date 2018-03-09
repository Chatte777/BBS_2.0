<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "threadMaster.ThreadMasterDAO" %>
<%@ page import = "threadReply.ThreadReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="threadMaster" class="threadMaster.ThreadMaster" scope="page"/>
<jsp:useBean id="threadReply" class="threadReply.ThreadReply" scope="page"/> 
<jsp:setProperty name="threadMaster" property="threadNo"/>
<jsp:setProperty name="threadReply" property="replyContent"/>
<jsp:setProperty name="threadReply" property="replyNo"/>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DREAMY CAT</title>
</head>
<body>
	<%
		String userID = null;
		if(session.getAttribute("userID") != null){
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else{
			if(threadReply.getReplyContent()==null){
				
			} else {
				ThreadReplyDAO threadReplyDAO = new ThreadReplyDAO();
				int result = threadReplyDAO.update(threadMaster.getThreadNo(), threadReply.getReplyNo(), threadReply.getReplyContent());
				
				if(result == -1){
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('댓글수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				}
				else
				{
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("location.href='threadView.jsp?threadNo=" + threadMaster.getThreadNo() + "'");
					script.println("</script>");
				}
		}
		
		
		}
			
	%>
</body>
</html>









