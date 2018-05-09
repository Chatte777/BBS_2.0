<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<c:if test="${sessionScope.userId!=null}">
    <c:set var="userId" value="${sessionScope.userId}"></c:set>
</c:if>

<nav class="navbar navbar-default">
    <div class="navbar-header ">
        <button type="button" class="navbar-toggle collapsed"
                data-toggle="collapse" data-target="#bs-example-navbar-collapse-1"
                aria-expanded="false">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
        <a class="navbar-brand" href="/main.jsp">
            <img src="/images/iStock-662195090.jpg" style="max-width: 100px; margin-top: -7px">DREAMY KAT</a>
    </div>

    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
        <ul class="nav navbar-nav">
            <li><a href="board.jsp?boardName=notify">공지 및 건의</a></li>
            <li><a href="board.jsp?boardName=mountain">산악일기</a></li>
            <li><a href="board.jsp?boardName=military">국방부학습지</a></li>
            <c:if test="${userId!=null}">
                <li><a href="GetAlarmList.do">
                    알림
                    <span style="color: red;" id="alarmCount"></span>
                </a></li>
                <li><a href="board.jsp?boardName=myBoard">내가 쓴 글</a></li>
            </c:if>
            <c:if test="${userId=='slop1434'||userId=='chatte777'}">
                <li><a href="board.jsp?boardName=thread">대화의 숲</a></li>
            </c:if>
        </ul>

        <c:choose>
            <c:when test="${userId==null}">
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown"><a href="#" class="dropdown-toggle"
                                            data-toggle="dropdown" role="button" aria-haspopup="true"
                                            aria-expanded="false">접속하기<span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="/login.jsp?initialLoginFlag=1">로그인</a></li>
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
    $(document).ready(function getAlarmCount() {
        alert("asfd");
        $.ajax({
            type: "POST",
            url: "GetAlarmCount.do?userId=${userId}",
            dataType: "text",
            success: function (data) {
                if(data!=0)  document.getElementById("alarmCount").innerText = data;
            },
            error: function (request, status, error) {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    });
</script>