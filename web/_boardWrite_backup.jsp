<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<link href="summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="summernote-0.8.9-dist/dist/summernote.js"></script>

<c:set var="userId" value="${sessionScope.userId}"></c:set>
<c:set var="boardName" value="${param.boardName}"></c:set>
<c:set var="boardNo" value="${param.boardNo}"></c:set>

<!--boardName에 대한 validation check-->
<c:choose>
    <c:when test="${param.boardName==null}">
        <script>errorAlert('21', 'main.jsp')</script>
    </c:when>
    <c:otherwise>
        <c:set var="boardName" value="${param.boardName}"></c:set>
    </c:otherwise>
</c:choose>

<!--로그인 상태에 대한 validation check-->
<c:choose>
    <c:when test="${sessionScope.userId==null}">
        <script>errorAlert('1', 'boardUpdate.jsp?boardName=${boardName}&boardNo=${boardNo}')</script>
    </c:when>
    <c:otherwise>
        <c:set var="sessionId" value="${sessionScope.userId}"></c:set>
    </c:otherwise>
</c:choose>

<!--Eroor로 인한 reload된 페이지의 경우 데이터를 채워넣어야 하므로 reloadFlag를 1로 셋한다.-->
<c:forEach var="cookie" items="<%=request.getCookies()%>">
    <c:if test="${cookie.name=='reloadFlag'}">
        <c:set var="reloadFlag" value="${cookie.value}"/>
    </c:if>
</c:forEach>

<!--boardUpdate 경우 데이터를 채워넣어야 하므로 writeFlag 2로 셋한다.-->
<c:set var="writeFlag" value="${param.writeFlag}"></c:set>
<c:if test="${writeFlag==2}">
    <c:set var="writeFlag" value="2"></c:set>

    <!--boardNo에 대한 validation check-->
    <c:choose>
        <c:when test="${param.boardNo}==null">
            <script>errorAlert('21', 'GetBoardList.do?boardName=${boardName}')</script>
            <c:set var="boardNo" value="0"></c:set>
        </c:when>
        <c:otherwise>
            <c:set var="boardNo" value="${param.boardNo}"></c:set>
            <script>getBoard('${boardNo}')</script>
        </c:otherwise>
    </c:choose>
</c:if>

<div class="container">
    <div class="row">
        <form method="post" name="boardForm">
            <table class="table table-striped" style="border: 1px solid #dddddd">
                <thead>
                <tr>
                    <th colspan="3"
                        style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식
                    </th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td width="80%">
                                <input type="text" class="form-control" placeholder="글 제목" name="boardTitle"
                                       id="boardTitle" maxlength="50">
                    </td>
                    <td width="10%">
                        <select class="form-control" name="boardAuthorize" id="boardAuthorize">
                            <option value="1" selected>전체공개</option>
                            <option value="2">나만보기</option>
                        </select>
                    </td>
                    <td width="10%">
                        <input type="text" class="form-control" disabled style="text-align: center;"
                               onkeydown="onlyNumber(this)"
                               placeholder="글 비밀번호" name="boardPassword" id="boardPassword" maxlength="4"></td>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                                <textarea name="boardContent" id="summernote"
                                          maxlength="2048"></textarea>
                    </td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script type="text/javascript">
    $(document).ready(function () {
        //게시글 권한설정이 바뀌면 게시글비밀번호 활성화,비활성화
        $("#boardAuthorize").change(function () {
            if ($("#boardAuthorize option:selected").val() == 1) $("#boardPassword").attr('disabled', true);
            else if ($("#boardAuthorize option:selected").val() == 2) $("#boardPassword").removeAttr('disabled');
        });

        $('#summernote').summernote(
            {
                height: 300,                 // set editor height
                minHeight: null,             // set minimum height of editor
                maxHeight: null,             // set maximum height of editor
                focus: true,             // set focus to editable area after initializing summernote
                onImageUpload: function (files, editor, welEditable) {
                    sendFile(files[0], editor, welEditable);
                },
                lang: 'ko-KR',
                placeholder: '이제 게시글에 사진을 업로드할 수 있습니다.',
                codemirror: { // codemirror options
                    theme: 'monokai'
                }
            });
    });

    //게시글 비밀번호에 숫자만 입력할 수 있도록 정규식처리.
    function onlyNumber(obj) {
        $(obj).keyup(function () {
            $(this).val($(this).val().replace(/[^0-9]/g, ""));
        });
    }

    function contentSubmit() {
        var writeFlag = ${writeFlag};
        var boardName = ${param.boardName};


        try {
            if (writeFlag==1) document.boardForm.action = "BoardWrite.do?boardName=" + boardName + "&boardNo=" + boardNo;
            else if (writeFlag==2) document.boardForm.action = "BoardUpdate.do?boardName=" + boardName + "&boardNo=" + boardNo;
            document.boardForm.method = "post";
            document.boardForm.submit();
        } catch (e) {
        }
    }

    $(document).ready(function () {
        $('#summernote').summernote(
            {
                height: 300,                 // set editor height
                minHeight: null,             // set minimum height of editor
                maxHeight: null,             // set maximum height of editor
                focus: true,             // set focus to editable area after initializing summernote
                onImageUpload: function (files, editor, welEditable) {
                    sendFile(files[0], editor, welEditable);
                },
                lang: 'ko-KR',
                placeholder: '이제 게시글에 사진을 업로드할 수 있습니다.',
                codemirror: { // codemirror options
                    theme: 'monokai'
                }
            });
    });

    /* summernote에서 이미지 업로드시 실행할 함수 */
    function sendFile(file, editor, welEditable) {
        // 파일 전송을 위한 폼생성
        data = new FormData();
        data.append("uploadFile", file);
        $.ajax({ // ajax를 통해 파일 업로드 처리
            data: data,
            type: "POST",
            url: "./summernote_imageUpload.jsp",
            cache: false,
            contentType: false,
            processData: false,
            success: function (data) { // 처리가 성공할 경우
                // 에디터에 이미지 출력
                editor.insertImage(welEditable, data.url);
            }
            , error: function (request, status, error) {
                alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error + request.dataType);
            }
        });
    }

    /* update의경우, error에 의한 reload page의 경우 화면에 값을 채워넣는 함수 */
    $(document).ready(function () {
        var boardTitle;
        var boardAuthorize;
        var boardPassword;
        var boardContent;

        var boardTitleElement = document.getElementById("boardTitle");
        var boardAuthorizeElement = document.getElementById("boardAuthorize");
        var boardPassword = document.getElementById("boardPassword");
        var boardContent = document.getElementById("summernote");

        if(${reloadFlag==1}){
            boardTitle = $.cookie("boardTitle");
            boardAuthorize = $.cookie("boardAuthorize");
            boardPassword = $.cookie("boardPassword");
            boardContent = $.cookie("boardContent");

            boardTitleElement.value = boardTitle;
            boardAuthorize.value = boardAuthorize;
            boardPassword.value = boardPassword;
            boardContent.value = boardContent;
        }

        if(${writeFlag==2}){
            $.ajax({
                data: data,
                type: "POST",
                url: "GetBoard.do?boardName=${boardName}&boardNo=${boardNo}&viewFlag=2",
                success: function (data) { // 처리가 성공할 경우
                    boardTitle=data.boardTitle;
                    boardAuthorize=data.boardAuthorize;
                    boardPassword=data.boardPassword;
                    boardContent=data.boardContent;

                    boardTitleElement.value = boardTitle;
                    boardAuthorize.value = boardAuthorize;
                    boardPassword.value = boardPassword;
                    boardContent.value = boardContent;
                }
                , error: function (request, status, error) {
                    alert("code:" + request.status + "\n" + "message:" + request.responseText + "\n" + "error:" + error + request.dataType);
                }
            });
        }
    });
</script>