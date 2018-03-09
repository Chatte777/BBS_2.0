<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "mountainMaster.MountainMasterDAO" %>
<%@ page import = "mountainMaster.MountainMaster" %>
<%@ page import = "mountainReply.MountainReply" %>
<%@ page import = "mountainReply.MountainReplyDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>


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
			}
		
			int replyNo = 0;
			if(request.getParameter("replyNo") != null){
				replyNo = Integer.parseInt(request.getParameter("replyNo"));
			}
		
			if(replyNo == 0){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('유효하지 않은 글입니다.')");
				script.println("location.href = 'mountain.jsp'");
				script.println("</script>"); 
			}

			MountainReply mountainReply = new MountainReply();
			MountainReplyDAO mountainReplyDAO = new MountainReplyDAO();
			mountainReply = mountainReplyDAO.getReply(Integer.parseInt(request.getParameter("mountainNo")), replyNo);
			if(!userID.equals(mountainReply.getReplyMakeUser())){
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('권한이 없습니다.')");
				script.println("location.href = 'login.jsp'");
				script.println("</script>"); 
			} else {

					int result = mountainReplyDAO.delete(Integer.parseInt(request.getParameter("mountainNo")), replyNo);
					
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
						script.println("location.href='mountainView.jsp?mountainNo=" + request.getParameter("mountainNo") + "'");
						script.println("</script>");
					}
			
		
		
		}
	

			
	%>
</body>
</html>