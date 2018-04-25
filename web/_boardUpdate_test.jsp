<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<link href="css/bootstrap.css" rel="stylesheet">
<script src="http://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.js"></script>
<script src="js/bootstrap.js"></script>
<link href="summernote-0.8.9-dist/dist/summernote.css" rel="stylesheet">
<script src="summernote-0.8.9-dist/dist/summernote.js"></script>

<c:set var="boardName" value="${param.boardName}"></c:set>

<c:choose>
    <c:when test="${sessionScope.userID==null}">
        로그인이 풀렸어요!
    </c:when>
    <c:otherwise>
        <c:set var="sessionId" value="${sessionScope.userID}"></c:set>
    </c:otherwise>
</c:choose>
<c:if test="${sessionId!=boardVO.boardMakeUser}">
    글 작성자가 아니신가봐요.. ㅠㅠ
</c:if>

<c:choose>
    <c:when test="${param.boardNo==null}">
        유효하지 않은 번호의 글인 것 같아요.
    </c:when>
    <c:otherwise>
        <c:set var="boardNo" value="${param.boardNo}"></c:set>
    </c:otherwise>
</c:choose>

<div class="container">
    <div class="row">
        <form method="post" name="boardForm">
            <table class="table table-striped"
                   style="border: 1px solid #dddddd">
                <thead>
                <tr>
                    <th colspan="3" style="background-color: #eeeeee; text-align: center;">
                        글 수정 양식
                    </th>
                </tr>
                </thead>

                <tbody>
                <tr>
                    <td><input type="text" class="form-control" placeholder="글 제목" name="boardTitle" maxlength="50"
                    value="${boardVO.boardTitle}"></td>
                    <td>
                        <select class="form-control" name="boardAuthorize" id="boardAuthorize">
                            <c:choose>
                                <c:when test="${boardVO.boardAuthorize==1}">
                                    <option value="1" selected>전체공개</option>
                                    <option value="2">나만보기</option>
                                </c:when>
                                <c:when test="${boardVO.boardAuthorize==2}">
                                    <option value="1">전체공개</option>
                                    <option value="2" selected>나만보기</option>
                                </c:when>
                            </c:choose>
                        </select>
                    </td>
                    <td width="10%">
                        <c:choose>
                            <c:when test="${boardVO.boardAuthorize==1}">
                                <input type="text" class="form-control" disabled style="text-align: center;" onkeydown="onlyNumber(this)"
                                       placeholder="글 비밀번호" name="boardPassword" id="boardPassword" maxlength="4">
                            </c:when>
                            <c:when test="${boardVO.boardAuthorize==2}">
                                <input type="text" class="form-control" style="text-align: center;" onkeydown="onlyNumber(this)"
                                       placeholder="글 비밀번호" name="boardPassword" id="boardPassword" maxlength="4" value="${boardVO.boardPassword}">
                            </c:when>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <textarea name="boardContent" id="summernote" placeholder="글 내용" maxlength="2048">
                            ${boardVO.boardContent}
                        </textarea>
                    </td>
                </tr>
                </tbody>
            </table>
            <input type="button" onclick="contentSubmit()" class="btn btn-primary pull-right" value="글수정">
        </form>
    </div>
</div>

<script src="js/_boardFileUpload.js" boardName="${boardName}" boardNo="${boardNo}" boardType="2"></script>