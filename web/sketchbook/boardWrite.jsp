<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.net.URLDecoder" %>
<link href="../css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="../js/bootstrap.js"></script>
<link href="../summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="../summernote-0.8.9-dist/dist/summernote.js"></script>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width" , initial-scale="1">
    <title>DREAMY CAT</title>
</head>
<body>
<jsp:include page="../_headNav.jsp" flush="false" />
<%
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
            if("boardTitle".equals(cookies[i].getName())) boardTitle= URLDecoder.decode(cookies[i].getValue(),"utf-8");
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
                    <th colspan="2"
                        style="background-color: #eeeeee; text-align: center;">게시판 글쓰기 양식</th>
                </tr>
                </thead>

                <tbody>
                <tr>
                <tr>
                    <td><input type="text" class="form-control"
                               placeholder="글 제목" name="boardTitle" maxlength="50" <%if(boardTitle!=null){%>value="<%=boardTitle%>"<%}%>></td>
                    <td><select class="form-control" name="boardAuthorize">
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
                </tr>
                <tr>
                    <td colspan="2"><textarea name="boardContent" id="summernote"
                                              maxlength="2048"><%if(boardContent!=null){%><%=boardContent%><%}%></textarea></td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script src="../js/_boardFileUpload.js" boardName="<%=boardName%>" boardNo="<%=boardNo%>" boardType="1"></script>
</body>
</html>