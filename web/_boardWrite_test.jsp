<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<link href="summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="summernote-0.8.9-dist/dist/summernote.js"></script>

<c:set var="userId" value="${sessionScope.userId}"></c:set>
<c:set var="boardName" value="${param.boardName}"></c:set>
<c:set var="boardNo" value="${param.boardNo}"></c:set>

<c:forEach var="cookie" items="<%=request.getCookies()%>">
    <c:if test="${cookie.name=='reloadFlag'}">
        <c:set var="reloadFlag" value="${cookie.value}"/>
    </c:if>
</c:forEach>

<c:if test="${reloadFlag==1}">
    <c:forEach var="cookie" items="<%=request.getCookies()%>">
        <c:if test="${cookie.name=='boardTitle'}">
            <c:set var="boardTitle" value="${cookie.value}"/>
        </c:if>
        <c:if test="${cookie.name=='boardContent'}">
            <c:set var="boardContent" value="${cookie.value}"/>
        </c:if>
        <c:if test="${cookie.name=='boardAuthorize'}">
            <c:set var="boardAuthorize" value="${cookie.value}"/>
        </c:if>
    </c:forEach>
</c:if>

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
                                           placeholder="글 제목" name="boardTitle" maxlength="50"></td>
                    <td width="10%"><select class="form-control" name="boardAuthorize" id="boardAuthorize">
                        <c:choose>
                            <c:when test="${boardAuthorize==2}">
                                <option value="1">전체공개</option><option value="2" selected>나만보기</option></select>
                            </c:when>
                            <c:otherwise>
                                <option value="1" selected>전체공개</option><option value="2">나만보기</option></select>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td width="10%">
                        <input type="text" class="form-control" disabled style="text-align: center;" onkeydown="onlyNumber(this)"
                               placeholder="글 비밀번호" name="boardPassword" id="boardPassword" maxlength="4"></td>
                    </td>
                </tr>
                <tr>
                    <td colspan="3"><textarea name="boardContent" id="summernote"
                                              maxlength="2048"></textarea></td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="작성완료">
        </form>
    </div>
</div>

<script src="js/_boardFileUpload.js" boardName="${boardName}" boardNo="${boardNo}" boardType="1"></script>