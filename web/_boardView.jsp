<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/errorAlert.js"></script>

<style>
    .btn {
        background-color: transparent;
        color:blue;
        border-color:powderblue;
    }
</style>

<c:set var="userId" value="${sessionScope.userId}"></c:set>
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
            <a href="/board.jsp?boardName=${boardName}" class="btn btn-primary">목록</a>
                <c:if test="${userId==boardVO.boardMakeUser}">
                    <a href="/boardWrite.jsp?boardName=${boardName}&boardNo=${boardVO.boardNo}&writeFlag=2" class="btn btn-primary">수정</a>
                    <a onclick="return confirm('정말 삭제하시려는거 맞죠?')"
                       href="BoardDelete.do?boardName=${boardName}&boardNo=${boardVO.boardNo}"
                       class="btn btn-primary">삭제</a>&nbsp;
                </c:if>
        </div>

        <table class="table table-striped">
            <tbody id="replyListTable" >
            </tbody>
        </table>
    </div>

    <form name="replyForm" id="replyForm">
        <table class="table table-condensed">
            <tbody>
            <tr>
                <td style="width: 90%;"><textarea class="form-control" placeholder="댓글" name="replyContent"
                                                  id="replyContent" maxlength="2048" style="height: 150px;"></textarea>
                </td>
                <td style="width: 10%; vertical-align: bottom;" align="center">
                    <input type="button" onclick="replySubmit()" class="btn btn-primary pull-right" id="replySubmit" value="댓글작성">
                </td>
            </tr>
            </tbody>
        </table>
        <input type="hidden" name="boardNo" id="boardNo" value="${boardNo}">
    </form>
    <div class="row" style="align-: right">
        <a href="/board.jsp?boardName=${boardName}" class="btn">목록</a>
        <c:if test="${boardVO.isReboard==1}">
            <a href="/boardWrite.jsp?boardName=${boardName}&boardNo=${boardVO.boardNo}&writeFlag=3" class="btn">답글달기</a>
        </c:if>
    </div>

</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
<script src="js/errorAlert.js"></script>

<script>
    var _updateFlag = 1;
    var _replyNo = 0;
    var _reReplyNo = 0;

    window.onload = function myFunction() {
        getReplyList();
    };

    function appendReplyListRow(data){
        var replyContent = data.replyContent.replace(/\r\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
        var replyMakeDt = data.replyMakeDt.substring(0, 11) + data.replyMakeDt.substring(11, 13) + "시" + data.replyMakeDt.substring(14, 16) + "분";

        var row = "";

        row +=
            "<tr onclick=\"reReplyClick('" + data.replyNo + "', '" + replyContent + "')\">" +
            "<td></td>" +
            "<td align=\"left\" style=\"word-break: break-all;\">" + replyContent + "</td>" +
            "<td align=\"center\" style=\"width: 10%;\" onclick=\"event.cancelBubble = true;\">" +
            "<a onclick=\"reReplyClick('" + data.replyNo + "', '" + replyContent + "')\"" +
            "type=\"button\" class=\"glyphicon glyphicon-share-alt\" style=\"color: seagreen; padding:0px 5px 0px 0px;\"/>";

        if (data.replyMakeUser == '${userId}') {
            row +=
                "<a onclick=\"replyModifyClick('" + replyContent + "', '" + data.replyNo + "')\" type=\"button\"" +
                "class=\"glyphicon glyphicon-pencil\" style=\"color: limegreen; padding:5px;\"/>" +
                "<a onclick=\"if(confirm('정말 삭제하시겠습니까?')) replyDeleteClick('" + data.replyNo + "', this)\"" +
                "type=\"button\" class=\"glyphicon glyphicon-remove\" style=\"color: #a9a9a9; padding:5px;\"/>";
        }

        row +=
            "</td>" +
            "<td style=\"width: 10%;\">" + data.replyMakeUser + "</td>" +
            "<td style=\"width: 15%;\">" + replyMakeDt + "</td>" +
            "</tr>";

        $("#replyListTable").append(row);
        if (data.hasReReply == 2) getReReplyList(data.replyNo);
    }


    function getReplyList() {
        $.ajax({
            type: "POST",
            url: "GetReplyList.ajax?boardName=${boardName}&boardNo=${boardNo}",
            dataType: "json",
            success: function (data) {
                $("#replyListTable").empty();
                for (var i = 0; i < data.length; i++) {
                    appendReplyListRow(data[i]);
                }
            },
            error: function (request, status, error) {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });

        if(${param.linkType==2}){
            var offset = $('#replyContent').offset();
            $('html, body').animate({scrollTop : offset.top}, 400);
        }
    }

    function getReReplyList(replyNo) {
        $.ajax({
            type: "POST",
            url: "GetReReplyList.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo=" + replyNo,
            async: false,
            dataType: "json",
            success: function (data) {
                var row = "";
                for (var j = 0; j < data.length; j++) {
                    var reReplyContent = data[j].reReplyContent.replace(/\r\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
                    var reReplyMakeDt = data[j].reReplyMakeDt.substring(0, 11) + data[j].reReplyMakeDt.substring(11, 13) + "시" + data[j].reReplyMakeDt.substring(14, 16) + "분";

                    row += "<tr style=\"height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;\">" +
                        "<td align=\"center\" style=\"border: none;\"><span class=\"glyphicon glyphicon-menu-right\"" +
                        "style=\"color: #bbbbbb;\">&nbsp;</span></td>" +
                        "<td style=\"border: none;\" align=\"left\">" + data[j].reReplyMakeUser + "&nbsp;" + reReplyMakeDt + "&nbsp;";

                    if (data[j].reReplyMakeUser == '${userId}') {
                        row += "<a onclick=\"reReplyModifyClick('" + reReplyContent + "', '" + data[j].replyNo + "', '" + data[j].reReplyNo + "')\"" +
                            "type=\"button\" class=\"glyphicon glyphicon-pencil\" style=\"color: #cccccc\"/>" +
                            "<a onclick=\"if(confirm('정말 삭제하시겠습니까?')) reReplyDeleteClick('" + data[j].replyNo + "','" + data[j].reReplyNo + "', this)\"" +
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

    function replyDeleteClick(replyNo, thisObject) {
        $.ajax({
            type: "POST",
            url: "ReplyDelete.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo=" + replyNo,
            dataType: "text",
            success: function (data) {
                thisObject.closest("tr").remove();
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function reReplyDeleteClick(replyNo, reReplyNo, thisObject) {
        $.ajax({
            type: "POST",
            url: "ReReplyDelete.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo=" + replyNo + "&reReplyNo=" + reReplyNo,
            dataType: "text",
            success: function () {
                thisObject.closest("tr").nextElementSibling.remove();
                thisObject.closest("tr").remove();
            },
            error: function () {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
            }
        });
    }

    function reReplyClick(replyNo, replyContent) {
        _updateFlag = 3;
        _replyNo = replyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").placeholder = replyContent.replace(/<br>/g, " ") + "에 대한 대댓글을 작성하세요.";
    }

    function replyModifyClick(replyContent, replyNo) {
        _updateFlag = 2;
        _replyNo = replyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent.replace(/<br>/g, "\n");
    }

    function reReplyModifyClick(reReplyContent, replyNo, reReplyNo) {
        _updateFlag = 4;
        _replyNo = replyNo;
        _reReplyNo = reReplyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = reReplyContent.replace(/<br>/g, "\n");
    }

    function replySubmit() {
        //_updateFlag==1 : 댓글작성
        if (_updateFlag == 1) {
            $.ajax({
                type: "POST",
                url: "ReplyWrite.ajax?boardName=${boardName}&boardNo=${boardNo}",
                data: $("#replyForm").serialize(),
                dataType: "text",
                success: function (data) {
                    if(data==1) {
                        //insert에 성공했으면 해당 댓글을 댓글리스트에 추가한다.
                        //날짜 변환
                        var date = new Date();
                        var dateReformat =date.getFullYear() + "-" + ("0" + (date.getMonth() + 1)).slice(-2) + "-" + ("0" + date.getDate()).slice(-2) + " " + ("0" + date.getHours()).slice(-2) + ":" + ("0" + date.getMinutes()).slice(-2) + ":" + ("0" + date.getSeconds()).slice(-2);
                        //replyContent는 입력한 값 그대로 가져오고
                        var trContent = document.getElementById('replyContent').value.replace(/\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
                        //나머지 값들은 여기저기서 가져옴(DB에서 가져오는게 아니라 입력할 당시에 설정했던 값들로)
                        var trData = {replyDislikeCnt: '1', replyContent: trContent, replyMakeUser: '${userId}', replyLikeCnt: '1', replyMakeDt: dateReformat};
                        appendReplyListRow(trData);
                        //댓글 textarea 초기화
                        document.getElementById('replyContent').value="";
                    }
                    else if(data==2) alert('로그인이 풀렸어요!');
                    else if(data=='-1') alert('서버로부터의 알림 : 댓글 등록에 실패했습니다.');
                },
                error: function () {
                    alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            });
            //updateFlag==2 : 댓글수정
        } else if (_updateFlag == 2) {
            $.ajax({
                type: "POST",
                url: "ReplyUpdate.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo="+_replyNo,
                data: $("#replyForm").serialize(),
                dataType: "text",
                success: function (data) {
                    if(data==1) {
                        getReplyList();
                        document.getElementById('replyContent').value="";
                    }
                    else if(data==2) alert('로그인이 풀렸어요!');
                    else if(data=='-1') alert('서버로부터의 알림 : 댓글 수정에 실패했습니다.');
                    _updateFlag = 1;
                },
                error: function () {
                    alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            });
            //updateFlag==3 : 대댓글작성
        } else if (_updateFlag == 3) {
            $.ajax({
                type: "POST",
                url: "ReReplyWrite.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo="+_replyNo,
                data: $("#replyForm").serialize(),
                dataType: "text",
                success: function (data) {
                    if(data==1) {
                        getReplyList();
                        document.getElementById('replyContent').value="";
                        _updateFlag = 1;
                    }
                    else if(data==2) alert('로그인이 풀렸어요!');
                    else if(data=='-1') alert('서버로부터의 알림 : 대댓글 등록에 실패했습니다.');
                },
                error: function () {
                    alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            });
            //updateFlag==4 : 대댓글수정
        } else if (_updateFlag == 4) {
            $.ajax({
                type: "POST",
                url: "ReReplyUpdate.ajax?boardName=${boardName}&boardNo=${boardNo}&replyNo="+_replyNo+"&reReplyNo="+_reReplyNo,
                data: $("#replyForm").serialize(),
                dataType: "text",
                success: function (data) {
                    if(data==1) {
                        getReplyList();
                        document.getElementById('replyContent').value="";
                        _updateFlag = 1;
                    }
                    else if(data==2) alert('로그인이 풀렸어요!');
                    else if(data=='-1') alert('서버로부터의 알림 : 대댓글 수정에 실패했습니다.');
                },
                error: function (request, status, error) {
                    alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error);
                }
            });
        }
    }
</script>