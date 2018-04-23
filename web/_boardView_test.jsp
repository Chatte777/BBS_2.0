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
<c:set var="boardNo" value="${param.boardNo}"></c:set>

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
                       href="boardDeleteAction.jsp?boardName=${boardName}&boardNo=${boardVO.boardNo}"
                       class="btn btn-primary">삭제</a>&nbsp;
                </c:when>
                <c:otherwise>
                    <a href="#" class="btn btn-primary" style="background:gray;">수정</a>
                    <a href="#" class="btn btn-primary" style="background:gray;">삭제</a>&nbsp;
                </c:otherwise>
            </c:choose>
        </div>

        <table id="replyListTable" class="table table-striped">
        </table>
    </div>

    <form name="replyForm">
        <table class="table table-condensed">
            <tbody>
            <tr>
                <td style="width: 90%;"><textarea class="form-control" placeholder="댓글" name="replyContent"
                                                  id="replyContent" maxlength="2048" style="height: 150px;"></textarea>
                </td>
                <td style="width: 10%; vertical-align: bottom;" align="center">
                    <input type="button" onclick="replySubmit()" class="btn btn-primary pull-right" value="댓글작성">
                </td>
            </tr>
            </tbody>
        </table>
        <input type="hidden" name="boardNo" id="boardNo" value="${boardNo}">
    </form>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>

<script>
    var _updateFlag = 1;
    var _replyNo = 0;

    window.onload = function getReplyList() {
        $.ajax({
            type: "POST",
            url: "GetReplyList.do?boardName=${boardName}&boardNo=${boardNo}",
            dataType: "json",
            success: function (data) {

                var row = "<tbody>";
                for (var i = 0; i < data.length; i++) {
                    row += "<tr>" +
                        "<td></td>" +
                        "<td align=\"left\" style=\"word-break: break-all;\">"+ data[i].replyContent +"</td>" +
                        "<td align=\"center\" style=\"width: 10%;\" onclick=\"event.cancelBubble = true;\">" +
                        "<a onclick=\"reReplyClick('"+ data[i].replyNo +"', '"+ data[i].replyContent +"')\"" +
                        "type=\"button\" class=\"glyphicon glyphicon-share-alt\" style=\"color: seagreen; padding:0px 5px 0px 0px;\"/>";

                    if(data[i].replyMakeUser == '${userId}'){
                        row += "<a onclick=\"modifyClick('"+ data[i].replyContent +"', '"+ data[i].replyNo +"')\" type=\"button\"" +
                            "class=\"glyphicon glyphicon-pencil\" style=\"color: limegreen; padding:5px;\"/>" +
                            "<a onclick=\"return confirm('정말 삭제하시겠습니까?')\"" +
                            "a href=\"replyDeleteAction.jsp?boardName=${boardName}&boardNo=${boardNo}&replyNo="+ data[i].replyNo +"\"" +
                            "type=\"button\" class=\"glyphicon glyphicon-remove\" style=\"color: #a9a9a9; padding:5px;\"/>";
                    }

                    row += "</td>";

                    row += "<td style=\"width: 10%;\">" + data[i].replyMakeUser + "</td>" +
                        "<td style=\"width: 15%;\">" + data[i].replyMakeDt + "</td>" +
                        "</tr>";
                }
                row += "</tbody>";
                $("#replyListTable").append(row);
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    };

    function getReReplyList(replyNo) {
        $.ajax({
            type: "POST",
            url: "GetReReplyList.do?boardName=${boardName}&boardNo=${boardNo}&replyNo="+replyNo,
            dataType: "json",
            success: function (data) {


                for (var i = 0; i < data.length; i++) {
                    var row = "<tr>" +
                        "</tr>";
                }
                $("#replyListTable").append(row);
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });

    function reReplyClick(replyNo, replyContent) {
        _updateFlag = 3;
        _replyNo = replyNo;document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent + "에 대한 대댓글을 작성하세요.";
    };

    function modifyClick(replyContent, replyNo) {
        _updateFlag = 2;
        _replyNo = replyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent;
    };

    function replySubmit() {
        if (_updateFlag == 1) {
            document.replyForm.action = "replyAction.jsp?boardName=${boardName}";
            document.replyForm.method = "post";
            document.replyForm.submit();
        } else if (_updateFlag == 2) {
            document.replyForm.action = "replyUpdateAction.jsp?boardName=${boardName}&replyNo=" + _replyNo;
            document.replyForm.method = "post";
            document.replyForm.submit();
        } else if (_updateFlag == 3) {
            document.replyForm.action = "reReplyAction.jsp?boardName=${boardName}&replyNo=" + _replyNo;
            document.replyForm.method = "post";
            document.replyForm.submit();
        }
    }
</script>