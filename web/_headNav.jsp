<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<c:if test="${sessionScope.userId!=null}">
    <c:set var="userId" value="${sessionScope.userId}"></c:set>
</c:if>

<nav class="navbar navbar-default">
    <div class="navbar-header">
        <button type="button" class="navbar-toggle collpased"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
            <span class="icon-bar"></span> <span class="icon-bar"></span> <span
                class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/main.jsp">DREAMY KAT</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
            <li><a href="GetBoardList.do?boardName=notify">공지 및 건의</a></li>
            <li><a href="GetBoardList.do?boardName=mountain">산악일기</a></li>
            <li><a href="GetBoardList.do?boardName=military">국방부학습지</a></li>
            <li><a href="/sketchbook/board.jsp?boardName=sketchbook">스케치북</a></li>
            <c:if test="${userId!=null}">
                <li><a href="GetAlarmList.do">
                    알림
                    <span style="color: red;" id="alarmCount"></span>
                </a></li>
            </c:if>
            <c:if test="${userId=='slop1434'||userId=='chatte777'}">
                <li><a href="GetBoardList.do?boardName=thread">대화의 숲</a></li>
            </c:if>
        </ul>

        <c:choose>
            <c:when test="${userId==null}">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown"><a href="#" class="dropdown-toggle"
                                            data-toggle="dropdown" role="button" aria-haspopup="true"
                                            aria-expanded="false">접속하기<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="/login.jsp">로그인</a></li>
                            <li><a href="/join.jsp">회원가입</a></li>
                        </ul></li>
                </ul>
            </c:when>
            <c:otherwise>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown"><a href="#" class="dropdown-toggle"
                                            data-toggle="dropdown" role="button" aria-haspopup="true"
                                            aria-expanded="false">회원관리<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="/logoutAction.jsp">로그아웃</a></li>
                        </ul></li>
                </ul>
            </c:otherwise>
        </c:choose>
    </div>
</nav>

<script type="text/javascript">
    window.onload = function getAlarmCount() {
        $.ajax({
            type: "POST",
            url: "GetAlarmCount.do?userId=${userId}",
            dataType: "text",
            success: function (data) {
                if(data!=0)  document.getElementById("alarmCount").innerText = data;
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }
</script>