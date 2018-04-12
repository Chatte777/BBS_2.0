<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<link href="summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="summernote-0.8.9-dist/dist/summernote.js"></script>

<%
    String userId=null;

    if (session.getAttribute("userID") != null) {
        userId = (String) session.getAttribute("userID");
    }
    if (userId == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.')");
        script.println("location.href = '/login.jsp'");
        script.println("</script>");
    }

    String boardName = request.getParameter("boardName");
    int boardNo = 0;

    if(request.getParameter("boardNo")!=null) boardNo=Integer.parseInt(request.getParameter("boardNo"));
    Cookie[] cookies = request.getCookies();
    String boardTitle=null;
    String boardContent=null;
    String boardAuthorize=null;
    String reloadFlag=null;

    for(int i=0; i<cookies.length; i++){
        if("reloadFlag".equals(cookies[i].getName())) reloadFlag=cookies[i].getValue();
    }

    if("1".equals(reloadFlag))
    for(int i=0; i<cookies.length; i++){
        if("boardTitle".equals(cookies[i].getName())) boardTitle=URLDecoder.decode(cookies[i].getValue(),"utf-8");
        if("boardContent".equals(cookies[i].getName())) boardContent= URLDecoder.decode(cookies[i].getValue(),"utf-8");
        if("boardAuthorize".equals(cookies[i].getName())) boardAuthorize=cookies[i].getValue();
    }
%>

<div class="container">
    <div class="row">
        <form method="post" name="boardForm">
            <table class="table table-striped" style="border: 1px solid #dddddd">
                <thead>
                <tr>
                    <th colspan="3"
                        style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                <tr>
                    <td width="80%"><input type="text" class="form-control"
                               placeholder="글 제목" name="boardTitle" maxlength="50" <%if(boardTitle!=null){%>value="<%=boardTitle%>"<%}%>></td>
                    <td width="10%"><select class="form-control" name="boardAuthorize" id="boardAuthorize">
                        <%
                            if(boardAuthorize=="2"){
                        %>
                        <option value="1">전체공개</option><option value="2" selected>나만보기</option></select>
                        <%
                            } else {
                        %>
                        <option value="1" selected>전체공개</option><option value="2">나만보기</option></select>
                        <%
                            }
                        %>
                    </td>
                    <td width="10%">
                        <input type="text" class="form-control" disabled style="text-align: center;" onkeydown="onlyNumber(this)"
                               placeholder="글 비밀번호" name="boardPassword" id="boardPassword" maxlength="4" <%if(boardTitle!=null){%>value="<%=boardTitle%>"<%}%>></td>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"><textarea name="boardContent" id="summernote"
                                    maxlength="2048"><%if(boardContent!=null){%><%=boardContent%><%}%></textarea></td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script src="js/_boardFileUpload.js" boardName="<%=boardName%>" boardNo="<%=boardNo%>" boardType="1"></script>