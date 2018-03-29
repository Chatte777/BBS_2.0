<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
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
                    if("notify".equals(boardName)) boardName="공지 및 건의";
                    else if("mountain".equals(boardName)) boardName = "산악일기";
                    else if("thread".equals(boardName)) boardName = "대화의 숲";
            %>
            <tr>
                <td align="left">
                    <a href="boardView.jsp?boardName=<%=list.get(i).getAlarmOrgboardName()%>&boardNo=<%=list.get(i).getAlarmOrgBoardNo()%>">
                        "<%=boardName%>" 게시판에 작성한 【<%= list.get(i).getAlarmContent() %>】 글에 답글이 달렸습니다.
                    </a>
                </td>
                <td></td>
                <td></td>
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
<script src="js/bootstrap.js"></script>
</body>
</html>


