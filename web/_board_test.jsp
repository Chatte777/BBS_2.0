<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>



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
            <tbody>
            <c:forEach items="${boardList}" var="boardVO" varStatus="status">
                <c:set var = "tmpDt" value = "${fn:substring(boardVO.boardMakeDt, 5, 16)}" />
                <c:set var = "tmpDt" value = "${fn:replace(tmpDt, '-', '/')}" />


                <tr>
                    <td>${boardVO.boardReadCount}</td>
                    <td align="left" colspan="2">
                        <c:if test="${boardVO.boardAuthorize==2}">
                            <span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span>
                        </c:if>
                        <span onclick="onClickBoardTitle('${boardVO.tableName}', '${boardVO.boardNo}', '${boardVO.boardAuthorize}', '${boardVO.boardPassword}')">
                            ${boardVO.boardTitle}
                        </span>
                    </td>
                    <td>
                        replyCnt
                    </td>
                    <td>
                        ${boardVO.boardMakeUser}
                    </td>
                    <td>
                        ${tmpDt}
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>


    </div>
</div>

<script>
    function onClickBoardTitle(boardName, boardNo, boardAuthorize, boardPassword) {
        if(boardAuthorize == 1) location.href = "boardView.jsp?boardName="+boardName+"&boardNo="+boardNo;
        else if(boardAuthorize==2) {
            var inputPassword = prompt("비밀번호를 입력하세요.(4자리 이하의 숫자)", "0000");

            if(inputPassword!=null) {
                if (boardPassword == inputPassword) location.href = "boardView.jsp?boardName=" + boardName + "&boardNo=" + boardNo + "&boardPassword=" + inputPassword;
                else {
                    alert("비밀번호 오류입니다.");
                }
            }
        }
    }
</script>