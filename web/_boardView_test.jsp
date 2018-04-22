<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="reply.ReplyVO" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="reReply.ReReplyDAO" %>
<%@ page import="reReply.ReReplyVO" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>

<c:set var="userId" value="${sessionScope.userID}"></c:set>
<c:set var="boardName" value="${param.boardName}"></c:set>

<div class="container">
    <div class="row">
        <table class="table table-striped"
               style="text-align: center; border: 1px solid #dddddd; word-break: break-all; margin-bottom: 5px;">
            <thead>
            <tr>
                <th colspan="4" style="background-color: #eeeeee; text-align: center;">게시판 글</th>
            </tr>
            </thead>

            <tbody>
            <tr>
                <td style="width: 20%;">글제목</td>
                <td colspan="3" align="left">
                    <c:if test="${boardVO.boardAuthorize==2}">
                        <span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span>
                    </c:if>
                    ${boardVO.boardTitle}
                </td>
            </tr>
            <tr>
                <td>작성자</td>
                <td colspan="3" align="left">
                    ${boardVO.boardMakeUser}
                </td>
            </tr>
            <tr>
                <td>작성일자</td>
                <td colspan="3" align="left">
                    ${boardVO.boardMakeDt}
                </td>
            </tr>
            <tr>
                <td>내용</td>
                <td colspan="3" style="min-height: 200px; text-align: left;">
                    <p>
                        ${boardVO.boardContent}
                    </p>
                </td>
            </tr>
            </tbody>
        </table>
        <div style="margin-bottom: 10px;" align="right">
            <c:choose>
                <c:when test="${userId}==${boardVO.boardMakeUser}">
                    <a href="boardUpdate.jsp?boardName=${boardName}&boardNo=${boardVO.boardNo}" class="btn btn-primary">수정</a>
                    <a onclick="return confirm('정말로 삭제하시겠습니까?')"
                       href="boardDeleteAction.jsp?boardName=${boardName}&boardNo=${boardVO.boardNo}" class="btn btn-primary">삭제</a>&nbsp;
                </c:when>
                <c:otherwise>
                    <a href="#" class="btn btn-primary" style="background:gray;">수정</a>
                    <a href="#" class="btn btn-primary" style="background:gray;">삭제</a>&nbsp;
                </c:otherwise>
            </c:choose>
        </div>

        <table id="replyListTable" class="table table-striped">
            <button onClick="onClickTest('${boardName}', '${boardVO.boardNo}')"></button>
            <tbody>

            </tbody>
        </table>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>

<script>
    var _updateFlag = 1;
    var _replyNo = 0;

    function onClickTest(boardName, boardNo){
        $.ajax({
            type : "GET",
            url: "GetReplyList.do?boardName="+boardName+"&boardNo="+boardNo,
            dataType: "text",
            success: function (data) {
                alert(data);
            },
            error: function () { alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error); }
        });
    };

    var request = new XMLHttpRequest();
    function getReply(boardName, boardNo){
        request.open("Post", "/GetReplyList.do?boardName="+boardName+"&boardNo="+boardNo, true);
        request.onreadystatechange = displayReply;
        request.send(null);
    }

    function displayReply(){
                var table = document.getElementById("replyListTable");
        table.innerHTML = "";
        if(request.readyState==4 && request.status==200){
            var object = eval('('+request.responseText+')');
            var replyList = object.replyListJsonArr;

            alert(request.responseText);

            for(i=0; i<replyList.length; i++){
                var row = table.insertRow(0);
                for(var j=0; j<replyList[j].length; j++){
                    var cell = row.insertCell(j);
                    cell.innerHTML = replyList[i][j].value;
                }
            }
        }
    }
</script>