<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String boardName = request.getParameter("boardName");
%>
<div class="container">
    <div class="row">
        <form method="post" name="boardForm">
            <table class="table table-striped"
                   style="text-align: center; border: 1px solid #dddddd">
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
                    <td colspan="2"><textarea type="text" class="form-control" name="boardContent" id="boardContent"
                                  placeholder="글 내용"  maxlength="2048"
                                  style="height: 350px;"></textarea></td>
                </tr>
                <jsp:include page="_fileUpload.jsp" flush="false"/>
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
</script>

