<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript" src="smartEditor\js\service\HuskyEZCreator.js" charset="utf-8"></script>

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
    var oEditors = [];

    nhn.husky.EZCreator.createInIFrame({
        oAppRef: oEditors,
        elPlaceHolder: "boardContent",
        sSkinURI: "smartEditor\\SmartEditor2Skin.html",
        fCreator: "createSEditor2"
    });

    // ‘저장’ 버튼을 누르는 등 저장을 위한 액션을 했을 때 submitContents가 호출된다고 가정한다.
    function contentSubmit() {
        // 에디터의 내용이 textarea에 적용된다.
        oEditors.getById["boardContent"].exec("UPDATE_CONTENTS_FIELD", []);

        // 에디터의 내용에 대한 값 검증은 이곳에서
        // document.getElementById("ir1").value를 이용해서 처리한다.

        try {
            document.boardForm.action="boardWriteAction.jsp?boardName=<%=boardName%>";
            document.boardForm.enctype="multipart/form-data";
            document.boardForm.method="post";
            document.boardForm.submit();
        } catch (e) {
        }
    }
</script>

