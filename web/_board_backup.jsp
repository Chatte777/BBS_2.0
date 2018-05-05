<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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
        <div class="text-center">
            <nav aria-label="...">
                <ul class="pagination">
                    <!--1페이지로 이동-->
                    <li class="page-item">
                        <a class="page-link" href="GetBoardList.do?boardName=${boardName}&pageNumber=1">처음</a>
                    </li>
                    <!--현재 1페이지이면 '이전'탭을 disable시키고 그게 아니라면 이전페이지로 이동-->
                    <c:choose>
                        <c:when test="${pageNumber!=1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber-1}">이전</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link">이전</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <!--현재 페이지가 3페이지 이상이면 '...'탭을 활성화 시키고, 클릭시 이전 페이지묶음 목록을 로드. 그게 아니라면 버튼 비활성화-->
                    <c:choose>
                        <c:when test="${pageNumber>3}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber-3}">
                                    <span class="glyphicon glyphicon-option-horizontal"></span></a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link"><span
                                        class="glyphicon glyphicon-option-horizontal"></span></span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <!--현재 페이지가 2페이지 초과라면 -2페이지를 활성화시키고 -2페이지로 이동. 2페이지 이하라면 -2페이지를 비활성화.-->
                    <c:choose>
                        <c:when test="${pageNumber>2}">
                            <li class="page-item"><a class="page-link"
                                                     href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber-2}">${pageNumber-2}
                            </a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled"><span class="page-link" style="color: darkgrey;">X</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <!--현재 페이지가 1페이지 초과이면 -1페이지를 활성화시키고 -1페이지로 이동. 1페이지 이하면 -1페이지를 비활성화.-->
                    <c:choose>
                        <c:when test="${pageNumber>1}">
                            <li class="page-item"><a class="page-link"
                                                     href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber-1}">${pageNumber-1}
                            </a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled"><span class="page-link" style="color: darkgray;">X</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <li class="page-item active">
                        <!-- 현재페이지는 항상 active, 활성화, 링크없음.-->
                        <span class="page-link">${pageNumber}
                            <span class="sr-only">(current)</span>
                        </span>
                    </li>

                    <c:choose>
                        <c:when test="${paginationJson.isNextPage==1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber+1}">${pageNumber+1}
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link" style="color: darkgray;">X</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${paginationJson.isDoubleNextPage==1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber+2}">${pageNumber+2}
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link" style="color: darkgray;">X</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${paginationJson.isTripleNextPage==1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber+3}">
                                    <span class="glyphicon glyphicon-option-horizontal"></span>
                                </a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link">
                                    <span class="glyphicon glyphicon-option-horizontal"/>
                                </span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <c:choose>
                        <c:when test="${paginationJson.isNextPage==1}">
                            <li class="page-item">
                                <a class="page-link"
                                   href="GetBoardList.do?boardName=${boardName}&pageNumber=${pageNumber+1}">다음</a>
                            </li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item disabled">
                                <span class="page-link">다음</span>
                            </li>
                        </c:otherwise>
                    </c:choose>

                    <li class="page-item">
                        <a class="page-link"
                           href="GetBoardList.do?boardName=${boardName}&pageNumber=${paginationJson.lastPage}">
                            마지막
                        </a>
                    </li>
                </ul>

                <a href="boardWrite.jsp?boardName=${boardName}&writeFlag=1" class="btn btn-primary pull-right">글쓰기</a>
        </div>
    </div>
</div>

<script>
    window.onload = function myfunction(){
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
                    appendReplyListRow(data[i]);
                }
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function appendBoardListRow(data){
        var readCount = data.replyCnt;
        var boardTitle = data.replyMakeDt.substring(0, 11) + data.replyMakeDt.substring(11, 13) + "시" + data.replyMakeDt.substring(14, 16) + "분";
        var replyCnt
        var boardMakeUser
        var boardMakeDt

        var row = "<tr onclick=\"reReplyClick('" + data.replyNo + "', '" + replyContent + "')\">" +
            "<td></td>" +
            "<td align=\"left\" style=\"word-break: break-all;\">" + replyContent + "</td>" +
            "<td align=\"center\" style=\"width: 10%;\" onclick=\"event.cancelBubble = true;\">" +
            "<a onclick=\"reReplyClick('" + data.replyNo + "', '" + replyContent + "')\"" +
            "type=\"button\" class=\"glyphicon glyphicon-share-alt\" style=\"color: seagreen; padding:0px 5px 0px 0px;\"/>";

        if (data.replyMakeUser == '${userId}') {
            row += "<a onclick=\"replyModifyClick('" + replyContent + "', '" + data.replyNo + "')\" type=\"button\"" +
                "class=\"glyphicon glyphicon-pencil\" style=\"color: limegreen; padding:5px;\"/>" +
                "<a onclick=\"if(confirm('정말 삭제하시겠습니까?')) replyDeleteClick('" + data.replyNo + "', this)\"" +
                "type=\"button\" class=\"glyphicon glyphicon-remove\" style=\"color: #a9a9a9; padding:5px;\"/>";
        }

        row += "</td>" +
            "<td style=\"width: 10%;\">" + data.replyMakeUser + "</td>" +
            "<td style=\"width: 15%;\">" + replyMakeDt + "</td>" +
            "</tr>";

        $("#replyListTable").append(row);
        if (data.hasReReply == 2) getReReplyList(data.replyNo);
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