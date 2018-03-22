<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.js"></script>

<%
    String boardName = request.getParameter("boardName");
%>
<div class="container">
    <div class="row">
        <form method="post" name="boardForm">
            <table class="table table-striped" style="border: 1px solid #dddddd">
                <thead>
                <tr>
                    <th colspan="2"
                        style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                <tr>
                    <td><input type="text" class="form-control"
                               placeholder="글 제목" name="boardTitle" maxlength="50"></td>
                    <td><select class="form-control" name="boardAuthorize"><option value="1" selected>전체공개</option><option value="2">나만보기</option></select></td>
                </tr>
                <tr>
                    <td colspan="2"><textarea name="boardContent" id="summernote"
                                  placeholder="글 내용"  maxlength="2048"></textarea></td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script type="text/javascript">
    function contentSubmit() {
        try {
            document.boardForm.action="boardWriteAction.jsp?boardName=<%=boardName%>";
            document.boardForm.enctype="multipart/form-data";
            document.boardForm.method="post";
            document.boardForm.submit();
        } catch (e) {
        }
    }

    $(document).ready(function() {
        $('#summernote').summernote(
            {
                height: 300,                 // set editor height
                minHeight: null,             // set minimum height of editor
                maxHeight: null,             // set maximum height of editor
                focus: true                  // set focus to editable area after initializing summernote
            }
        );
    });
</script>

