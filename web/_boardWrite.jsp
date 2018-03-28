<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<!--<link href="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.9/summernote.js"></script> -->
<link href="summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="summernote-0.8.9-dist/dist/summernote.js"></script>

<%
    String boardName = request.getParameter("boardName");
    int boardNo = 0;
    if(request.getParameter("boardNo")!=null) boardNo=Integer.parseInt(request.getParameter("boardNo"));
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
                                    maxlength="2048"></textarea></td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script src="js/_boardFileUpload.js" boardName="<%=boardName%>" boardNo="<%=boardNo%>" boardType="1"></script>