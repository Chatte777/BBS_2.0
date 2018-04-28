<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.io.PrintWriter" %>
<%@ page import="alarmMaster.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    String userId = null;

    if (session.getAttribute("userId") != null) {
        userId = (String) session.getAttribute("userId");
    }
    if (userId == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.')");
        script.println("location.href = 'Login.jsp'");
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
        script.println("location.href = 'GetAlarmList.do'");
        script.println("</script>");
    }

    AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
    AlarmMaster alarmMaster = alarmMasterDAO.getAlarmMaster(alarmNo);

    int result = alarmMasterDAO.updateAlarmReadYn(alarmMaster.getAlarmNo());

    if(Integer.parseInt(request.getParameter("readType"))==1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='boardView.jsp?boardName="+alarmMaster.getAlarmOrgboardName()+"&boardNo="+alarmMaster.getAlarmOrgBoardNo()+"'");
        script.println("</script>");
    }

    if (result == -1) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('읽음처리에 실패했습니다.')");
        script.println("history.back()");
        script.println("</script>");
    } else {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("location.href='GetAlarmList.do'");
        script.println("</script>");
    }
%>