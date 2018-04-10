<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="alarmMaster.AlarmMasterDAO" %>
<%@ page import="alarmMaster.AlarmMaster" %>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>DREAMY CAT</title>
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
</head>
<body>
<%
    String userId = null;
    if (session.getAttribute("userID") != null) {
        userId = (String) session.getAttribute("userID");
    }

    int pageNumber = 1;
    if (request.getParameter("pageNumber") != null) {
        pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
    }
%>

<jsp:include page="_headNav.jsp" flush="false"/>

<div class="container">
    <div class="row">
        <table class="table" style="text-align: center; border: 1px solid #dddddd">
            <thead>
            <tr>
                <th style="background-color: #eeeeee; text-align: center;">알람내용</th>
                <th style="background-color: #eeeeee; text-align: center;">&nbsp;</th>
                <th style="background-color: #eeeeee; text-align: center;">&nbsp;</th>
            </tr>
            </thead>

            <tbody>
            <%
                AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
                ArrayList<AlarmMaster> list;

                String boardName;

                list = alarmMasterDAO.getList(pageNumber, userId);

                for (int i = 0; i < list.size(); i++) {
                    boardName = list.get(i).getAlarmOrgboardName();
                    if ("notify".equals(boardName)) boardName = "공지 및 건의";
                    else if ("mountain".equals(boardName)) boardName = "산악일기";
                    else if ("thread".equals(boardName)) boardName = "대화의 숲";
            %>
            <tr>
                <td align="left">
                    <a href="alarmReadAction.jsp?alarmNo=<%=list.get(i).getAlarmNo()%>&alarmTargetUser=<%=list.get(i).getAlarmTargetUser()%>&readType=1">

                        <span style="color:purple;">
                        <%if (list.get(i).getAlarmType() == 1) {%> "<%=boardName%>" 게시판에 작성한 【<%= list.get(i).getAlarmOrgContent() %>】 글에 답글이 달렸습니다. <%} else if (list.get(i).getAlarmType() == 2) {%> "<%=boardName%>" 게시판에 작성한 【<%= list.get(i).getAlarmOrgContent() %>】 글에 댓글이 달렸습니다. <%}%>
                            </span>
                        <br>
                        <span style="font-size: 0.9em; color: blue;">&nbsp;☞&nbsp;"<%=list.get(i).getAlarmNewContent()%>..."</span>
                    </a>
                </td>
                <td>
                    <%
                        if (list.get(i).getAlarmReadYn() == 1) {
                    %>
                    <a href="alarmReadAction.jsp?alarmNo=<%=list.get(i).getAlarmNo()%>&alarmTargetUser=<%=list.get(i).getAlarmTargetUser()%>&readType=2"
                       class="btn" style="background-color: lightblue;">읽음처리</a>
                    <%
                    } else {
                    %>
                    <a href="#" class="btn" style="background-color: gray;">읽음</a>
                    <%
                        }
                    %>
                </td>
                <td>
                    <a href="alarmDeleteAction.jsp?alarmNo=<%=list.get(i).getAlarmNo()%>&alarmTargetUser=<%=list.get(i).getAlarmTargetUser()%>"
                       class="btn" style="background-color: lightpink;">삭제</a>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
        <%
            if (pageNumber != 1) {
        %>
        <a href="alarm.jsp?pageNumber=<%=pageNumber-1%>"
           class="btn btn-successs btn-arrow-left">이전</a>
        <%
        } else { %>
        <a href="#" class="btn btn-primary btn-arrow-left" style="background: gray;">이전</a>
        <%
            }
            if (alarmMasterDAO.isNextPage(pageNumber, userId)) {
        %>
        <a href="alarm.jsp?pageNumber=<%=pageNumber+1%>"
           class="btn btn-successs btn-arrow-right">다음</a>
        <%
        } else {
        %>
        <a href="#" class="btn btn-primary btn-arrow-right" style="background: gray;">다음</a>
        <% }%>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
</body>
</html>

