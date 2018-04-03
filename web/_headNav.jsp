<%@ page import="alarmMaster.AlarmMasterDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%
    String userID = null;
    if (session.getAttribute("userID") != null) {
        userID = (String) session.getAttribute("userID");
    }

    AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
    int alarmCount = alarmMasterDAO.getAlarmCount(userID);
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
            if (userID != null && (userID.equals("slop1434") || userID.equals("chatte777"))) {
        %>
        <a class="navbar-brand" href="main.jsp">DREAMY KAT</a>
        <%
        } else {
        %>
        <a class="navbar-brand" href="main.jsp">MyLogs</a>
        <%
            }
        %>

    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
            <li><a href="main.jsp">메인</a></li>
            <li><a href="board.jsp?boardName=notify">공지 및 건의</a></li>
            <li><a href="board.jsp?boardName=mountain">산악일기</a></li>
            <li><a href="board.jsp?boardName=military">국방부학습지</a></li>
            <%if (userID != null) {%> <li><a href="board.jsp?boardName=myBoard">내가쓴글</a></li> <%}%>
            <%if (userID != null) {%> <li><a href="alarm.jsp">알림
            <%
                if(alarmCount!=0) {%><span style="color: red;"><%=alarmCount%><%};%>
            </a></li> <%}%>
            <%
                if (userID != null && (userID.equals("slop1434") || userID.equals("chatte777") || userID.equals("test"))) {
            %>
            <li><a href="board.jsp?boardName=thread">대화의 숲</a></li>
            <%
                }
            %>
        </ul>

        <%
            if (userID == null) {
        %>
        <ul class="nav navbar-nav navbar-right">
            <li class="dropdown"><a href="#" class="dropdown-toggle"
                                    data-toggle="dropdown" role="button" aria-haspopup="true"
                                    aria-expanded="false">접속하기<span class="caret"></span></a>
                <ul class="dropdown-menu">
                    <li><a href="login.jsp">로그인</a></li>
                    <li><a href="join.jsp">회원가입</a></li>
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
                    <li><a href="logoutAction.jsp">로그아웃</a></li>
                </ul></li>
        </ul>
        <%
            }
        %>

    </div>
</nav>