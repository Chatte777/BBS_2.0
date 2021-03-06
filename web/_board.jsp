<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script src="js/jquery.cookie.js"></script>
<script src="js/errorAlert.js"></script>

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
            <tbody id="fixedBoardListTbody"></tbody>
            <tbody id="boardListTbody"></tbody>
        </table>

        <div class="text-center">
            <nav aria-label="...">
                <ul class="pagination" id="pagination">
                </ul>
                <c:if test="${boardName!='myBoard'}">
                <a href="boardWrite.jsp?boardName=${boardName}&writeFlag=1" class="btn btn-primary pull-right">글쓰기</a>
                </c:if>
        </div>
    </div>
</div>



<script>
    var _currentPageNumber = 1;

    function getBoardListSwitch(currentPageNumber){
        if(${boardName=='myBoard'}) getMyBoardList(currentPageNumber);
        else getBoardList(currentPageNumber);
    }

    function getMyBoardList(currentPageNumber){
        $.ajax({
            type: "POST",
            url: "GetMyBoardList.ajax?pageNumber="+currentPageNumber,
            dataType: "json",
            success: function (data) {
                appendBoardListRow(data.boardData, data.etcInformation, 1);
                pagination(currentPageNumber, data.pagination);
                $.cookie('${boardName}' , currentPageNumber, { expires : 1000*60*60*24 });
            },
            error: function (request, status, error) {
                alert(error);
            }
        });
    }

    function getBoardList(currentPageNumber){
        $.ajax({
            type: "POST",
            url: "GetBoardList.ajax?boardName=${boardName}&pageNumber="+currentPageNumber,
            dataType: "json",
            success: function (data) {
                appendBoardListRow(data.boardData, data.etcInformation, 1);
                pagination(currentPageNumber, data.pagination);
                $.cookie('${boardName}' , currentPageNumber, { expires : 1000*60*60*24 });
            },
            error: function (request, status, error) {
                alert(error);
            }
        });
    }

    function getFixedBoardList(){
        $.ajax({
            type: "POST",
            url: "GetFixedBoardList.ajax?boardName=${boardName}",
            dataType: "json",
            success: function (data) {
                appendBoardListRow(data.boardData, data.etcInformation, 2);
            },
            error: function (request, status, error) {
                alert(error);
            }
        });
    }

    $(document).ready(function myFunction() {
        if($.cookie('${boardName}')) _currentPageNumber=$.cookie('${boardName}');
        if(${param.boardName=='myBoard'}) getMyBoardList(_currentPageNumber);
        else {
            getFixedBoardList();
            getBoardList(_currentPageNumber);
        }

    });

    //boardType==1 : fixedBoard, boardType==2 : normalBoard
    function appendBoardListRow(boardData, etcInformation, boardType){
        $("#boardListTbody").empty();

        var row = "";

        for(var i=0; i<boardData.length; i++){
            var boardReadCount = boardData[i].boardReadCount;
            var boardTitle = boardData[i].boardTitle.replace(/\r\n/g, "<br>").replace(/\"/g, "〃").replace(/'/g, "＇");
            var replyCnt = etcInformation[i].replyCnt;
            var boardMakeUser =  boardData[i].boardMakeUser;
            var boardAuthorize = boardData[i].boardAuthorize;
            var isReboard = boardData[i].isReboard;
            var tableName = boardData[i].tableName;
            var boardPassword = boardData[i].boardPassword;
            var boardColorFlag = etcInformation[i].boardColorFlag;
            var replyColorFlag = etcInformation[i].replyColorFlag;
            var boardNo = boardData[i].boardNo;
            var boardMakeDt = boardData[i].boardMakeDt;
            var imageCount = boardData[i].imageCount;
            boardMakeDt = boardMakeDt.substring(0, 11) + boardMakeDt.substring(11, 13) + "시" + boardMakeDt.substring(14, 16) + "분";

            if(isReboard==1){
                row +=
                    "<tr>" +
                    "<td>"+boardReadCount+"</td>" +
                    "<td align=\"left\" colspan=\"2\">";

                if(boardAuthorize==2) row += "<span class=\"glyphicon glyphicon-lock\" style=\"color: #bbbbbb;\">&nbsp;</span>";

                row +=
                    "<span onclick=\"onClickBoardTitle('"+tableName+"', '"+boardNo+"', '"+boardAuthorize+"', '"+boardPassword+"', '1')\"" +
                    "style=\"cursor: pointer;\">";

                switch (boardColorFlag){
                    case '1':
                        row += "<span style=\"color: #DE2A45;\">"+boardTitle+"</span>";
                        break;
                    case '2':
                        row += "<span style=\"color: #10BF00;\">"+boardTitle+"</span>";
                        break;
                    case '3':
                        row += "<span style=\"color: #2865BF;\">"+boardTitle+"</span>";
                        break;
                    case '4':
                        row += "<span style=\"color: black;\">"+boardTitle+"</span>";
                        break;
                }

                if(imageCount > 0) row += "&nbsp;&nbsp;<span class=\"glyphicon glyphicon-picture\" style=\"color: darkblue;\">&nbsp;</span>";

                row +=
                    "</span>" +
                    "</td>" +
                    "<td>" +
                    "<span onclick=\"onClickBoardTitle('"+tableName+"', '"+boardNo+"', '"+boardAuthorize+"', '"+boardPassword+"', '2')\"" +
                    "style=\"cursor: pointer;\">";

                switch (replyColorFlag){
                    case '1':
                        row += "<span style=\"color: #7A447A;\">"+replyCnt+"</span>";
                        break;
                    case '2':
                        row += "<span style=\"color: #DE2A45;\">"+replyCnt+"</span>";
                        break;
                    case '3':
                        row += "<span style=\"color: #F5762C;\">"+replyCnt+"</span>";
                        break;
                    case '4':
                        row += "<span style=\"color: #10BF00;\">"+replyCnt+"</span>";
                        break;
                    case '5':
                        row += "<span style=\"color: #2865BF;\">"+replyCnt+"</span>";
                        break;
                    case '6':
                        row += "<span style=\"color: black;\">"+replyCnt+"</span>";
                        break;
                }

                row +=
                    "</span>" +
                    "</td>" +
                    "<td>" + boardMakeUser + "</td>" +
                    "<td>" + boardMakeDt + "</td>" +
                    "</tr>";
            } else {
                row +=
                    "<tr style=\"height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;\">" +
                    "<td>" + boardReadCount + "</td>" +
                    "<td align=\"left\" colspan=\"2\">" +
                    "<span class=\"glyphicon glyphicon-menu-right\" style=\"color: #bbbbbb;\">&nbsp;</span>";

                if(boardAuthorize==2) row += "<span class=\"glyphicon glyphicon-lock\" style=\"color: #bbbbbb;\">&nbsp;</span>";

                row +=
                    "<span onclick=\"onClickBoardTitle('"+ tableName +"', '"+ boardNo +"', '"+ boardAuthorize +"', '"+boardPassword+"')\"" +
                    "style=\"cursor: pointer;\">";

                switch(boardColorFlag){
                    case '1':
                        row += "<span style=\"color: #DE2A45;\">"+boardTitle+"</span>";
                        break;
                    case '2':
                        row += "<span style=\"color: #10BF00;\">"+boardTitle+"</span>";
                        break;
                    case '3':
                        row += "<span style=\"color: #2865BF;\">"+boardTitle+"</span>";
                        break;
                    case '4':
                        row += "<span style=\"color: black;\">"+boardTitle+"</span>";
                        break;
                }

                if(imageCount > 0) row += "&nbsp;&nbsp;<span class=\"glyphicon glyphicon-picture\" style=\"color: darkblue;\">&nbsp;</span>";

                row +=
                    "</span>" +
                    "</td>" +
                    "<td>" +
                    "<span onclick=\"onClickBoardTitle('"+tableName+"', '"+boardNo+"', '"+boardAuthorize+"', '"+boardPassword+"', '2')\"" +
                    "style=\"cursor: pointer;\">";

                switch (replyColorFlag){
                    case '1':
                        row += "<span style=\"color: #7A447A;\">"+replyCnt+"</span>";
                        break;
                    case '2':
                        row += "<span style=\"color: #DE2A45;\">"+replyCnt+"</span>";
                        break;
                    case '3':
                        row += "<span style=\"color: #F5762C;\">"+replyCnt+"</span>";
                        break;
                    case '4':
                        row += "<span style=\"color: #10BF00;\">"+replyCnt+"</span>";
                        break;
                    case '5':
                        row += "<span style=\"color: #2865BF;\">"+replyCnt+"</span>";
                        break;
                    case '6':
                        row += "<span style=\"color: black;\">"+replyCnt+"</span>";
                        break;
                }
                row+=
                    "</span>" +
                    "</td>" +
                    "<td>" + boardMakeUser + "</td>" +
                    "<td>" + boardMakeDt + "</td>" +
                    "</tr>";
            }
        }

        if(boardType==1) $("#boardListTbody").append(row);
        else {
            $("#fixedBoardListTbody").append(row);
            $("#fixedBoardListTbody > tr").css("background-color", "violet");
        }
    }

    // linkType=1 : 게시글제목 클릭. 단순 페이지이동. linkType=2 : 댓글갯수 클릭. 페이지 이동 후페이지 하단 포커스
    function onClickBoardTitle(boardName, boardNo, boardAuthorize, boardPassword, linkType) {
        if (boardAuthorize == 1) location.href = "GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo+"&viewFlag=1&linkType="+linkType;
        else if (boardAuthorize == 2) {
            var inputPassword = prompt("비밀번호를 입력하세요.(4자리 이하의 숫자)", "0000");

            if (inputPassword != null) {
                if (boardPassword == inputPassword) location.href = "GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo + "&boardPassword=" + inputPassword+"&viewFlag=1&linkType"+linkType;
                else {
                    alert("비밀번호 오류입니다.");
                }
            }
        }
    }

    function pagination(currentPageNumber, pagination){
        $("#pagination").empty();

        var row = "";
        currentPageNumber = currentPageNumber*1;

        // '처음으로'페이지는 항상 1페이지 링크로 활성화
        row +=
            "<li class=\"page-item\">" +
            "<a class=\"page-link\" onclick=\"getBoardListSwitch('1')\">처음</a>" +
            "</li>";

        // 현재 페이지가 1페이지가 아니면(첫 페이지가 아니면) '이전'버튼 활성화
        if(currentPageNumber != 1) {
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\"" +
                "onclick=\"getBoardListSwitch('" + (currentPageNumber-1) + "')\">이전</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\">이전</span>" +
                "</li>";
        }

        // 현재 페이지가 3페이지 초과이면 '...'탭을 활성화. 클릭 시 이전 페이지묶음을 불러온다. (now-3)
        if(currentPageNumber > 3){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\"" +
                "onclick=\"getBoardListSwitch('"+ (currentPageNumber-3) +"')\">" +
                "<span class=\"glyphicon glyphicon-option-horizontal\">" +
                "</span>" +
                "</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<a class=\"page-link\">" +
                "<span class=\"glyphicon glyphicon-option-horizontal\">" +
                "</span>" +
                "</a>" +
                "</li>";
        }

        // 현재 페이지가 2페이지 초과이면 '-2'페이지를 활성화.
        if(currentPageNumber > 2){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+ (currentPageNumber-2) +"')\">" +
                (currentPageNumber-2) +
                "</a></li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\" style=\"color: darkgrey;\">X</span>" +
                "</li>";
        }

        // 현재 페이지가 1페이지 초과이면 '-1'페이지를 활성화.
        if(currentPageNumber > 1){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch("+ (currentPageNumber-1) +")\">"+
                (currentPageNumber-1) +
                "</a></li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\" style=\"color: darkgray;\">X</span>" +
                "</li>";
        }

        // 현재 페이지는 항상 활성화
        row +=
            "<li class=\"page-item active\">" +
            "<span class=\"page-link\">"+
            currentPageNumber +
            "<span class=\"sr-only\">(current)</span>" +
            "</span>" +
            "</li>";

        // 다음 페이지가 있으면 '+1' 페이지를 활성화.
        if(pagination.isNextPage==1){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+(currentPageNumber+1)+"')\">" +
                (currentPageNumber+1) +
                "</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\" style=\"color: darkgray;\">X</span>" +
                "</li>";
        }

        // 다음 다음페이지가 있으면 '+2' 페이지를 활성화.
        if(pagination.isDoubleNextPage==1){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+ (currentPageNumber+2) +"')\">"+
                (currentPageNumber+2) +
                "</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\" style=\"color: darkgray;\">X</span>" +
                "</li>";
        }

        // 현재 페이지 이후로 페이지가 3개 넘게 있으면 '...'탭 활성화. 클릭 시 다음 페이지 묶음을 불러온다. (now+3)
        if(pagination.isTripleNextPage==1){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+ (currentPageNumber+3) +"')\">" +
                "<span class=\"glyphicon glyphicon-option-horizontal\"></span>" +
                "</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\">" +
                "<span class=\"glyphicon glyphicon-option-horizontal\"/>" +
                "</span>" +
                "</li>";
        }

        // 다음 페이지가 있으면 '다음'버튼을 활성화.
        if(pagination.isNextPage==1){
            row +=
                "<li class=\"page-item\">" +
                "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+ (currentPageNumber+1) +"')\">다음</a>" +
                "</li>";
        } else {
            row +=
                "<li class=\"page-item disabled\">" +
                "<span class=\"page-link\">다음</span>" +
                "</li>";
        }

        // 마지막 페이지로 이동
        row +=
            "<li class=\"page-item\">" +
            "<a class=\"page-link\" onclick=\"getBoardListSwitch('"+pagination.lastPage+"')\">" +
            "마지막" +
            "</a>" +
            "</li>";

        $("#pagination").append(row);
    }
</script>