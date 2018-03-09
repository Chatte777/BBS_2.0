<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "mountainMaster.MountainMasterDAO" %>
<%@ page import = "mountainReply.MountainReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="mountainMaster" class="mountainMaster.MountainMaster" scope="page"/>
<jsp:useBean id="mountainReply" class="mountainReply.MountainReply" scope="page"/> 
<jsp:setProperty name="mountainMaster" property="mountainNo"/>
<jsp:setProperty name="mountainReply" property="replyContent"/>

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
			if(mountainReply.getReplyContent()==null){
				
			} else {
				MountainReplyDAO mountainReplyDAO = new MountainReplyDAO();
				int result = mountainReplyDAO.write(mountainMaster.getMountainNo(), userID, mountainReply.getReplyContent());
				
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
					script.println("location.href='mountainView.jsp?mountainNo=" + mountainMaster.getMountainNo() + "'");
					script.println("</script>");
				}
		}
		}
	%>
</body>
</html>









