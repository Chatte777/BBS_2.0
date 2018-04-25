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
                <td style="width: 90%;"><textarea class="form-control" placeholder="댓글" name="replyContent" id="replyContent" maxlength="2048" style="height: 150px;"></textarea>
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
    var _reReplyNo = 0;

    window.onload = function getReplyList() {
        $.ajax({
            type: "POST",
            url: "GetReplyList.do?boardName=${boardName}&boardNo=${boardNo}",
            dataType: "json",
            success: function (data) {

                $("#replyListTable").append("<tbody>");
                for (var i = 0; i < data.length; i++) {
                    var replyContent = data[i].replyContent.replace(/\r\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
                    var replyMakeDt = data[i].replyMakeDt.substring(0,11)+data[i].replyMakeDt.substring(11,13)+"시"+data[i].replyMakeDt.substring(14,16)+"분";

                    var row = "<tr onclick=\"reReplyClick('"+data[i].replyNo+"', '"+replyContent +"')\">" +
                        "<td></td>" +
                        "<td align=\"left\" style=\"word-break: break-all;\">"+ replyContent +"</td>" +
                        "<td align=\"center\" style=\"width: 10%;\" onclick=\"event.cancelBubble = true;\">" +
                        "<a onclick=\"reReplyClick('"+ data[i].replyNo +"', '"+ replyContent +"')\"" +
                        "type=\"button\" class=\"glyphicon glyphicon-share-alt\" style=\"color: seagreen; padding:0px 5px 0px 0px;\"/>";

                    if(data[i].replyMakeUser == '${userId}'){
                        row += "<a onclick=\"replyModifyClick('"+ replyContent +"', '"+ data[i].replyNo +"')\" type=\"button\"" +
                            "class=\"glyphicon glyphicon-pencil\" style=\"color: limegreen; padding:5px;\"/>" +
                            "<a onclick=\"return confirm('정말 삭제하시겠습니까?')\"" +
                            "a href=\"replyDeleteAction.jsp?boardName=${boardName}&boardNo=${boardNo}&replyNo="+ data[i].replyNo +"\"" +
                            "type=\"button\" class=\"glyphicon glyphicon-remove\" style=\"color: #a9a9a9; padding:5px;\"/>";
                    }

                    row += "</td>" +
                        "<td style=\"width: 10%;\">" + data[i].replyMakeUser + "</td>" +
                        "<td style=\"width: 15%;\">" + replyMakeDt + "</td>" +
                        "</tr>";

                    $("#replyListTable").append(row);
                    if(data[i].hasReReply==2) getReReplyList(data[i].replyNo);
                }
                $("#replyListTable").append("</tbody>");
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
            async: false,
            dataType: "json",
            success: function (data) {
                var row="";
                for (var j = 0; j < data.length; j++) {
                    var reReplyContent = data[j].reReplyContent.replace(/\r\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
                    var reReplyMakeDt = data[j].reReplyMakeDt.substring(0,11)+data[j].reReplyMakeDt.substring(11,13)+"시"+data[j].reReplyMakeDt.substring(14,16)+"분";

                        row += "<tr style=\"height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;\">" +
                        "<td align=\"center\" style=\"border: none;\"><span class=\"glyphicon glyphicon-menu-right\"" +
                        "style=\"color: #bbbbbb;\">&nbsp;</span></td>" +
                        "<td style=\"border: none;\" align=\"left\">"+ data[j].reReplyMakeUser + "&nbsp;" + reReplyMakeDt + "&nbsp;";

                        if(data[j].reReplyMakeUser == '${userId}'){
                            row += "<a onclick=\"reReplyModifyClick('"+reReplyContent  +"', '"+data[j].replyNo+"', '"+data[j].reReplyNo+"')\"" +
                                "type=\"button\" class=\"glyphicon glyphicon-pencil\" style=\"color: #cccccc\"/>" +
                                "<a onclick=\"return confirm('정말로 삭제하시겠습니까?')\"" +
                                "a href=\"reReplyDeleteAction.jsp?boardName=${boardName}&boardNo=${boardNo}&replyNo="+data[j].replyNo+"&reReplyNo="+data[j].reReplyNo+"\"" +
                                "type=\"button\" class=\"glyphicon glyphicon-remove\" style=\"color: #cccccc; padding:0px;\"/>";
                        }

                        row += "<td style=\"border: none;\"></td>" +
                            "<td style=\"border: none;\"></td>" +
                            "<td style=\"border: none;\"></td>" +
                            "</tr>" +
                            "<tr style=\"height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;\">" +
                            "<td style=\" border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;\"></td>" +
                            "<td align=\"left\" style=\"word-break: break-all; border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;\">" +
                            reReplyContent +
                            "</td>" +
                            "<td style=\"border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;\"></td>" +
                            "<td style=\"border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;\"></td>" +
                            "<td align=\"center\" style=\"width: 5%; border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;\"></td>" +
                            "</tr>";
                }

                $("#replyListTable").append(row);

            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function reReplyClick(replyNo, replyContent) {
        _updateFlag = 3;
        _replyNo = replyNo;document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent + "에 대한 대댓글을 작성하세요.";
    }

    function replyModifyClick(replyContent, replyNo) {
        _updateFlag = 2;
        _replyNo = replyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent;
    }

    function reReplyModifyClick(reReplyContent, replyNo, reReplyNo) {
        _updateFlag = 4;
        _replyNo = replyNo;
        _reReplyNo = reReplyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = reReplyContent;
    }

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
        } else if (_updateFlag == 4) {
            document.replyForm.action = "reReplyUpdateAction.jsp?boardName=${boardName}&replyNo=" + _replyNo + "&reReplyNo=" + _reReplyNo;
            document.replyForm.method = "post";
            document.replyForm.submit();
        }
    }
</script>