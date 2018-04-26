<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="alarmMaster.AlarmMasterDAO" %>
<%@ page import="alarmMaster.AlarmMaster" %>


<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <link rel="stylesheet" href="css/bootstrap.css">
    <title>DREAMY KAT</title>
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
</head>
<body>
<c:set var="boardName" value="${param.boardName}"></c:set>

<c:choose>
    <c:when test="${sessionScope.userID==null}">
        로그인이 풀렸어요!
    </c:when>
    <c:otherwise>
        <c:set var="sessionId" value="${sessionScope.userID}"></c:set>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${param.pageNumber==null}">
        <c:set var="pageNumber" value="1"></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="pageNumber" value="${param.pageNumber}"></c:set>
    </c:otherwise>
</c:choose>

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
            <c:forEach items="${alarmList}" var="alarmVO" varStatus="status">
                <c:choose>
                    <c:when test="${alarmVO.alarmOrgboardName}=='notify'">
                        <c:set var="boardName" value="공지 및 건의"></c:set>
                    </c:when>
                    <c:when test="${alarmVO.alarmOrgboardName}=='mountain'">
                        <c:set var="boardName" value="산악일기"></c:set>
                    </c:when>
                    <c:when test="${alarmVO.alarmOrgboardName}=='thread'">
                        <c:set var="boardName" value="대화의 숲"></c:set>
                    </c:when>
                </c:choose>

                <tr>
                    <td align="left">
                        <!-- 알람 컨텐츠를 클릭했을 때는 해당 게시글로 이동한다. (readType 1)-->
                        <a onclick="readClick('${alarmVO.alarmNo}','1')">
                        <span style="color:purple;">
                            <c:choose>
                                <c:when test="${alarmVO.alarmType==1}">
                                    "${boardName}"게시판에 작성한【${alarmVO.alarmOrgContent}】글에 답글이 달렸습니다.
                                </c:when>
                                <c:when test="${alarmVO.alarmType==2}">
                                    "${boardName}" 게시판에 작성한 【${alarmVO.alarmOrgContent}】 글에 댓글이 달렸습니다.
                                </c:when>
                                <c:when test="${alarmVO.alarmType==3}">
                                    "${boardName}"게시판에 작성한【${alarmVO.alarmOrgContent}】댓글에 대댓글이 달렸습니다.
                                </c:when>
                            </c:choose>
                            </span>
                            <br>
                            <span style="font-size: 0.9em; color: blue;">&nbsp;☞&nbsp;"${alarmVO.alarmNewContent}..."</span>
                        </a>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${alarmVO.alarmReadYn==1}">
                                <!-- 읽음처리 버튼을 클릭했을 때는 버튼 css만 변경한다. (reqdType 2) -->
                                <a  onclick="readClick('3','2')" class="btn" style="background-color: lightblue;">읽음처리</a>
                            </c:when>
                            <c:otherwise>
                                <a  class="btn" style="background-color: gray;">읽음</a>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="alarmDeleteAction.jsp?alarmNo=${alarmVO.alarmNo}%>&alarmTargetUser=${alarmVO.alarmTargetUser}"
                           class="btn" style="background-color: lightpink;">삭제</a>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
        <c:choose>
            <c:when test="${pageNumber==1}">
                <a  class="btn btn-primary btn-arrow-left" style="background: gray;">이전</a>
            </c:when>
            <c:otherwise>
                <a href="GetAlarmList.do?pageNumber=${pageNumber-1}" class="btn btn-successs btn-arrow-left">이전</a>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${isNextPage}">
                <a href="GetAlarmList.do?pageNumber=${pageNumber+1}" class="btn btn-successs btn-arrow-right">다음</a>
            </c:when>
            <c:otherwise>
                <a  class="btn btn-primary btn-arrow-right" style="background: gray;">다음</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>


<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
</body>

<script type="text/javascript">
    function readClick(alarmNo, readType){
        alert("asdf");
        $.ajax({
            type: "POST",
            url: "AlarmReadCheck.do?alarmNo=${alarmNo}",
            dataType: "text",
            success: function (data) {

            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function deleteClick(){

    }
</script>

</html>
