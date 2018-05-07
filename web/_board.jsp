<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>


<c:set var="i" value="0"></c:set>
<c:set var="boardName" value="${param.boardName}"></c:set>
<c:choose>
    <c:when test="${param.pageNumber==null}">
        <c:set var="pageNumber" value="1"></c:set>
    </c:when>
    <c:otherwise>
        <c:set var="pageNumber" value="${param.pageNumber}"></c:set>
    </c:otherwise>
</c:choose>

<div class="container">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
            <thead>
            <tr style="background-color: #eeeeee;">
                <th style="text-align: center;">조회수</th>
                <th style="text-align: center;" colspan="2">제목</th>
                <th style="text-align: center;">댓글</th>
                <th style="text-align: center;">작성자</th>
                <th style="text-align: center;">작성일</th>
            </tr>
            </thead>
            <tbody id="boardListTbody">
            <c:forEach items="${boardList}" var="boardVO" varStatus="status">
                <c:set var="tmpDt" value="${fn:substring(boardVO.boardMakeDt, 5, 16)}"/>
                <c:set var="tmpDt" value="${fn:replace(tmpDt, '-', '/')}"/>

                <c:choose>
                    <c:when test="${boardVO.isReboard==1}">
                        <tr>
                            <td>${boardVO.boardReadCount}</td>
                            <td align="left" colspan="2">
                                <c:if test="${boardVO.boardAuthorize==2}">
                                    <span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span>
                                </c:if>
                                <span onclick="onClickBoardTitle('${boardVO.tableName}', '${boardVO.boardNo}', '${boardVO.boardAuthorize}', '${boardVO.boardPassword}')"
                                      style="cursor: pointer;">
                            <c:choose>
                                <c:when test="${etcInformationJson[i].boardColorFlag==1}">
                                    <span style="color: #DE2A45;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==2}">
                                    <span style="color: #10BF00;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==3}">
                                    <span style="color: #2865BF;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==4}">
                                    <span style="color: black;">${boardVO.boardTitle}</span>
                                </c:when>
                            </c:choose>
                        </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==1}">
                                        <span style="color: #7A447A;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==2}">
                                        <span style="color: #DE2A45;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==3}">
                                        <span style="color: #F5762C;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==4}">
                                        <span style="color: #10BF00;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==5}">
                                        <span style="color: #2865BF;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==6}">
                                        <span style="color: black;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                    ${boardVO.boardMakeUser}
                            </td>
                            <td>
                                    ${tmpDt}
                            </td>
                        </tr>
                    </c:when>
                    <c:otherwise>
                        <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                            <td>${boardVO.boardReadCount}</td>
                            <td align="left" colspan="2">
                                <span class="glyphicon glyphicon-menu-right" style="color: #bbbbbb;">&nbsp;</span>
                                <c:if test="${boardVO.boardAuthorize==2}">
                                    <span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span>
                                </c:if>
                                <span onclick="onClickBoardTitle('${boardVO.tableName}', '${boardVO.boardNo}', '${boardVO.boardAuthorize}', '${boardVO.boardPassword}')"
                                      style="cursor: pointer;">
                            <c:choose>
                                <c:when test="${etcInformationJson[i].boardColorFlag==1}">
                                    <span style="color: #DE2A45;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==2}">
                                    <span style="color: #10BF00;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==3}">
                                    <span style="color: #2865BF;">${boardVO.boardTitle}</span>
                                </c:when>
                                <c:when test="${etcInformationJson[i].boardColorFlag==4}">
                                    <span style="color: black;">${boardVO.boardTitle}</span>
                                </c:when>
                            </c:choose>
                        </span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==1}">
                                        <span style="color: #7A447A;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==2}">
                                        <span style="color: #DE2A45;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==3}">
                                        <span style="color: #F5762C;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==4}">
                                        <span style="color: #10BF00;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==5}">
                                        <span style="color: #2865BF;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                    <c:when test="${etcInformationJson[i].replyColorFlag==6}">
                                        <span style="color: black;">${etcInformationJson[i].replyCnt}</span>
                                    </c:when>
                                </c:choose>
                            </td>
                            <td>
                                    ${boardVO.boardMakeUser}
                            </td>
                            <td>
                                    ${tmpDt}
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
                <c:set var="i" value="${i+1}"></c:set>
            </c:forEach>
            </tbody>
        </table>


    </div>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

<script>
    window.onload = function myFunction() {
        getBoardList();
    };

    function getBoardList(){
        $.ajax({
            type: "POST",
            url: "GetBoardList.ajax?boardName=${boardName}&pageNumber=${pageNumber}",
            dataType: "json",
            success: function (data) {
                $("#boardListTbody").empty();
                for (var i = 0; i < data.length; i++) {
                    appendBoardListRow(data.boardData[i], data.etcInformation[i]);
                }
            },
            error: function (request, status, error) {
                alert(error);
            }
        });
    }

    function appendBoardListRow(boardData, etcInformation){
        alert(boardData);
        var boardReadCount = boardData.boardReadCount;
        var boardTitle = boardData.boardTitle.replyCnt;
        var replyCnt = etcInformation.replyCnt;
        var boardMakeUser =  boardData.boardMakeUser;
        var boardMakeDt = boardData.boardMakeDt;
        var boardAuthorize = boardData.boardAuthorize;
        var isReboard = boardData.isReboard;
        var tableName = boardData.tableName;
        var boardPassword = boardData.boardPassword;
        var boardColorFlag = etcInformation.boardColorFlag;
        var replyColorFlag = etcInformation.replyColorFlag;

        var row = "";

        if(isReboard==1){
            row +=
                "<tr>" +
                "<td>"+boardReadCount+"</td>" +
                "<td align=\"left\" colspan=\"2\">";

            if(boardAuthorize==2) row += "<span class=\"glyphicon glyphicon-lock\" style=\"color: #bbbbbb;\">&nbsp;</span>";

            row +=
                "<span onclick=\"onClickBoardTitle('"+tableName+"', '"+boardNo+"', '"+boardAuthorize+"', '"+boardPassword+"')\"" +
                "style=\"cursor: pointer;\">";

            switch (boardColorFlag){
                case 1:
                    row += "<span style=\"color: #DE2A45;\">"+boardTitle+"</span>";
                    break;
                case 2:
                    row += "<span style=\"color: #10BF00;\">"+boardTitle+"</span>";
                    break;
                case 3:
                    row += "<span style=\"color: #2865BF;\">"+boardTitle+"</span>";
                    break;
                case 4:
                    row += "<span style=\"color: black;\">"+boardTitle+"</span>";
                    break;
            }

            row +=
                "</span>" +
                "</td>" +
                "<td>";

            switch (replyColorFlag){
                case 1:
                    row += "<span style=\"color: #7A447A;\">"+replyCnt+"</span>";
                    break;
                case 2:
                    row += "<span style=\"color: #DE2A45;\">"+replyCnt+"</span>";
                    break;
                case 3:
                    row += "<span style=\"color: #F5762C;\">"+replyCnt+"</span>";
                    break;
                case 4:
                    row += "<span style=\"color: #10BF00;\">"+replyCnt+"</span>";
                    break;
                case 5:
                    row += "<span style=\"color: #2865BF;\">"+replyCnt+"</span>";
                    break;
                case 6:
                    row += "<span style=\"color: black;\">"+replyCnt+"</span>";
                    break;
            }

            row +=
                "</td>" +
                "<td>" + boardMakeUser + "</td>" +
                "<td>" + boardMakeDt + "</td>" +
                "</tr>";
        } else {
            row +=
                "<tr style=\"height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;\">" +
                "<td>" + boardReadCount + "</td>" +
                "<td align=\"left\" colspan=\"2\"" +
                "<span class=\"glyphicon glyphicon-menu-right\" style=\"color: #bbbbbb;\">&nbsp;</span>";

            if(boardAuthorize==2) row += "<span class=\"glyphicon glyphicon-lock\" style=\"color: #bbbbbb;\">&nbsp;</span>";

            row +=
                "<span onclick=\"onClickBoardTitle('"+ tableName +"', '"+ boardNo +"', '"+ boardAuthorize +"', '"+boardPassword+"')\"" +
                "style=\"cursor: pointer;\">";

            switch(boardColorFlag){
                case 1:
                    row += "<span style=\"color: #DE2A45;\">"+boardTitle+"</span>";
                    break;
                case 2:
                    row += "<span style=\"color: #10BF00;\">"+boardTitle+"</span>";
                    break;
                case 3:
                    row += "<span style=\"color: #2865BF;\">"+boardTitle+"</span>";
                    break;
                case 4:
                    row += "<span style=\"color: black;\">"+boardTitle+"</span>";
                    break;
            }

            row +=
                "</span>" +
                "</td>" +
                "<td>";

            switch (replyColorFlag){
                case 1:
                    row += "<span style=\"color: #7A447A;\">"+replyCnt+"</span>";
                    break;
                case 2:
                    row += "<span style=\"color: #DE2A45;\">"+replyCnt+"</span>";
                    break;
                case 3:
                    row += "<span style=\"color: #F5762C;\">"+replyCnt+"</span>";
                    break;
                case 4:
                    row += "<span style=\"color: #10BF00;\">"+replyCnt+"</span>";
                    break;
                case 5:
                    row += "<span style=\"color: #2865BF;\">"+replyCnt+"</span>";
                    break;
                case 6:
                    row += "<span style=\"color: black;\">"+replyCnt+"</span>";
                    break;
            }

            row+=
                "</td>" +
                "<td>" + boardMakeUser + "</td>" +
                "<td>" + boardMakeDt + "</td>" +
                "</tr>";
        }

        $("#boardListTbody").append(row);
    }

    function onClickBoardTitle(boardName, boardNo, boardAuthorize, boardPassword) {
        if (boardAuthorize == 1) location.href = "GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo+"&viewFlag=1";
        else if (boardAuthorize == 2) {
            var inputPassword = prompt("비밀번호를 입력하세요.(4자리 이하의 숫자)", "0000");

            if (inputPassword != null) {
                if (boardPassword == inputPassword) location.href = "GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo + "&boardPassword=" + inputPassword+"&viewFlag=1";
                else {
                    alert("비밀번호 오류입니다.");
                }
            }
        }
    }
</script>