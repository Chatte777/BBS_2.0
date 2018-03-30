<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.io.PrintWriter" %>
<%@ page import="alarmMaster.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userID = null;

    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }
    if (userID == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.')");
        script.println("location.href = 'login.jsp'");
        script.println("</script>");
    }

    int alarmNo = 0;
    if (request.getParameter("alarmNo") != null) {
        alarmNo = Integer.parseInt(request.getParameter("alarmNo"));
    }

    if (alarmNo == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 알림입니다.')");
        script.println("location.href = 'alarm.jsp'");
        script.println("</script>");
    }

    AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();

    int result = alarmMasterDAO.updateAlarmDeleteYn(Integer.parseInt(request.getParameter("alarmNo")), request.getParameter("alarmTargetUser"));

    if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('삭제처리에 실패했습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='alarm.jsp'");
        script.println("</script>");
    }
%>