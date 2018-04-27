<%@ page import="alarmMaster.AlarmMasterDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String userId = null;
    if (session.getAttribute("userId") != null) {
        userId = (String) session.getAttribute("userId");
    }

    AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
    int alarmCount = alarmMasterDAO.getAlarmCount(userId);
%>


<nav class="navbar navbar-default">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle collpased"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
            <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                class="icon-bar"></span>
        </button>
        <%
            if (userId != null && (userId.equals("slop1434") || userId.equals("chatte777"))) {
        %>
        <a class="navbar-brand" href="/main.jsp">DREAMY KAT</a>
        <%
        } else {
        %>
        <a class="navbar-brand" href="/main.jsp">MyLogs</a>
        <%
            }
        %>

    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
            <li><a href="GetBoardList.do?boardName=notify">공지 및 건의</a></li>
            <li><a href="GetBoardList.do?boardName=mountain">산악일기</a></li>
            <li><a href="GetBoardList.do?boardName=military">국방부학습지</a></li>
            <li><a href="/sketchbook/board.jsp?boardName=sketchbook">스케치북</a></li>
            <%if (userId != null) {%> <li><a href="GetBoardList.do?boardName=myBoard">내가쓴글</a></li> <%}%>
            <%if (userId != null) {%> <li><a href="GetAlarmList.do">알림
            <%
                if(alarmCount!=0) {%><span style="color: red;"><%=alarmCount%><%};%>
            </a></li> <%}%>
            <%
                if (userId != null && (userId.equals("slop1434") || userId.equals("chatte777") || userId.equals("test"))) {
            %>
            <li><a href="GetBoardList.do?boardName=thread">대화의 숲</a></li>
            <%
                }
            %>
        </ul>

        <%
            if (userId == null) {
        %>
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown"><a href="#" class="dropdown-toggle"
                                    data-toggle="dropdown" role="button" aria-haspopup="true"
                                    aria-expanded="false">접속하기<span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="/login.jsp">로그인</a></li>
                    <li><a href="/join.jsp">회원가입</a></li>
                </ul></li>
        </ul>
        <%
        } else {
        %>
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown"><a href="#" class="dropdown-toggle"
                                    data-toggle="dropdown" role="button" aria-haspopup="true"
                                    aria-expanded="false">회원관리<span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="/logoutAction.jsp">로그아웃</a></li>
                </ul></li>
        </ul>
        <%
            }
        %>

    </div>
</nav>