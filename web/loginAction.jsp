<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import = "user.UserDAO" %>
<%@ page import = "java.io.PrintWriter" %>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="user" class="user.User" scope="page"/> 
<jsp:setProperty name="user" property="userID"/>
<jsp:setProperty name="user" property="userPassword"/>

	<%
		String userId = null;
		if(session.getAttribute("userID") != null){
			userId = (String) session.getAttribute("userID");
		}
		if (userId != null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('이미 로그인되어있습니다.')");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		
		UserDAO userDAO = new UserDAO();
		int result = userDAO.login(user.getUserID(), user.getUserPassword());
		
		if(result == 1){
		    if(request.getParameter("accountRememberYn") != null) {
				if (Integer.parseInt(request.getParameter("accountRememberYn")) == 1) {
					Cookie idRemember = new Cookie("idRemember", user.getUserID());
					idRemember.setMaxAge(60 * 60 * 24 * 365);

					Cookie pwRemember = new Cookie("pwRemember", user.getUserPassword());
					pwRemember.setMaxAge(60 * 60 * 24 * 365);

					response.addCookie(idRemember);
					response.addCookie(pwRemember);
				}
			}

			session.setAttribute("userID", user.getUserID());
			session.setMaxInactiveInterval(60*60*24*7);

			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("location.href = 'main.jsp'");
			script.println("</script>");
		}
		else if(result == 0)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('비밀번호가 틀립니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -1)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('존재하지 않는 아이디입니다.')");
			script.println("history.back()");
			script.println("</script>");
		}
		else if(result == -2)
		{
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('데이터베이스 오류가 발생했습니다..')");
			script.println("history.back()");
			script.println("</script>");
		}
			
	%>