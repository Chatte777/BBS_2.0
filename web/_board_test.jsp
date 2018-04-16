<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>


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

            <tbody>
            <tr>
                <td><%= list.get(i).getBoardReadCount() %>
                </td>

                <td align="left" colspan="2">
                    <%
                        if (list.get(i).getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span>
                    <%
                    }
                %>
                    <span onclick="onClickBoardTitle('<%=list.get(i).getTableName()%>', '<%=list.get(i).getBoardNo()%>', '<%=list.get(i).getBoardAuthorize()%>', '<%=list.get(i).getBoardPassword()%>')"
                            <%
                                if (boardColorFlag == 1) {%>
                       style="color: #DE2A45; cursor: pointer;"<%} else if (boardColorFlag == 2) {%>
                       style="color:#10BF00; cursor: pointer;"<%} else if (boardColorFlag == 3) {%>
                       style="color:#2865BF; cursor: pointer;"<%} else if (boardColorFlag == 4) {%>
                        style="color:black; cursor: pointer;"<%}%>>
                        <%= list.get(i).getBoardTitle() %>
                    </span>
                </td>
                <td
                        <%
                            if (replyColorFlag == 1) {%>
                        style="color: #7A447A; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 2) {%>
                        style="color:#DE2A45; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 3) {%>
                        style="color:#F5762C; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 4) {%>
                        style="color:#10BF00; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 5) {%>
                        style="color:#2865BF; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 6) {%>
                        style="color:black;"<%
                    }
                %>>
                    <%if (replyCnt != 0) {%><%=replyCnt%><%}%></td>
                <td><%= list.get(i).getBoardMakeUser() %>
                </td>
                <td><%= list.get(i).getBoardMakeDt().substring(5, 7) + "/" + list.get(i).getBoardMakeDt().substring(8, 13) + ":" + list.get(i).getBoardMakeDt().substring(14, 16) %>
                </td>
            </tr>
            <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                <td align="center"><span class="glyphicon glyphicon-menu-right" style="color: #bbbbbb;">&nbsp;</span>
                </td>
                <td align="left"><a
                        href="boardView.jsp?boardName=<%=listReboard.get(j).getTableName()%>&boardNo=<%= listReboard.get(j).getBoardNo() %>">조회수&nbsp;<%= listReboard.get(j).getBoardReadCount() %>
                </a>
                </td>
                <td align="left">
                    <%
                        if (listReboard.get(j).getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
                    }
                %>
                    <a href="boardView.jsp?boardName=<%=listReboard.get(j).getTableName()%>&boardNo=<%= listReboard.get(j).getBoardNo() %>"
                            <%
                                if (boardColorFlag == 1) {%>
                       style="color: #DE2A45;"<%} else if (boardColorFlag == 2) {%>
                       style="color:#10BF00;"<%} else if (boardColorFlag == 3) {%>
                       style="color:#2865BF;"<%} else if (boardColorFlag == 4) {%> style="color:black;"<%}%>>
                        <%= listReboard.get(j).getBoardTitle() %>
                    </a>
                </td>
                <td
                        <%
                            if (replyColorFlag == 1) {%>
                        style="color: #7A447A; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 2) {%>
                        style="color:#DE2A45; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 3) {%>
                        style="color:#F5762C; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 4) {%>
                        style="color:#10BF00; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 5) {%>
                        style="color:#2865BF; font-weight: bold; font-size:1.2em;"<%} else if (replyColorFlag == 6) {%>
                        style="color:black;"<%
                    }
                %>>
                    <%if (replyCnt != 0) {%><%=replyCnt%><%}%></td>
                <td><%= listReboard.get(j).getBoardMakeUser() %>
                </td>
                <td><%= listReboard.get(j).getBoardMakeDt().substring(5, 7) + "/" + listReboard.get(j).getBoardMakeDt().substring(8, 13) + ":" + listReboard.get(j).getBoardMakeDt().substring(14, 16) %>
                </td>
            </tr>

            <%
                            }
                        }
                    }
                }
            %>
            </tbody>
        </table>

        <div class="text-center">
            <nav aria-label="...">
                <ul class="pagination">
                    <!--1페이지로 이동-->
                    <li class="page-item">
                        <a class="page-link" href="board.jsp?boardName=<%=boardName%>&pageNumber=1">처음</a>
                    </li>
                    <!--현재 1페이지이면 '이전'탭을 disable시키고 그게 아니라면 이전페이지로 이동-->
                    <%if (pageNumber != 1) { %>
                    <li class="page-item">
                        <a class="page-link" href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-1%>">이전</a>
                    </li>
                    <%
                    } else {
                    %>
                    <li class="page-item disabled">
                        <span class="page-link">이전</span>
                    </li>
                    <!--현재 페이지가 3페이지 이상이면 '...'탭을 활성화 시키고, 클릭시 이전 페이지묶음 목록을 로드. 그게 아니라면 버튼 비활성화-->
                    <% }
                        if (pageNumber > 3) { %>
                    <li class="page-item">
                        <a class="page-link"
                           href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-3%>"><span
                                class="glyphicon glyphicon-option-horizontal"></span></a>
                    </li>
                    <%
                    } else {
                    %>
                    <li class="page-item disabled">
                        <span class="page-link"><span class="glyphicon glyphicon-option-horizontal"></span></span>
                    </li>
                    <!--현재 페이지가 2페이지 초과라면 -2페이지를 활성화시키고 -2페이지로 이동. 2페이지 이하라면 -2페이지를 비활성화.-->
                    <% }
                        if (pageNumber > 2) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-2%>"><%=pageNumber - 2%>
                    </a></li>
                    <%
                        } else {
                        %>
                    <li class="page-item disabled"><span class="page-link" style="color: darkgrey;">X</span></li>
                    <!--현재 페이지가 1페이지 초과이면 -1페이지를 활성화시키고 -1페이지로 이동. 1페이지 이하면 -1페이지를 비활성화.-->
                    <%
                        }
                        if (pageNumber > 1) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-1%>"><%=pageNumber - 1%>
                    </a></li>
                    <%
                        } else {
                        %>
                    <li class="page-item disabled"><span class="page-link" style="color: darkgray;">X</span></li>
                    <%
                        }
                    %>
                    <li class="page-item active">
                        <!-- 현재페이지는 항상 active, 활성화, 링크없음.-->
      <span class="page-link">
        <%=pageNumber%>
        <span class="sr-only">(current)</span>
      </span>
                    </li>
                    <!-- 현재페이지의 다음페이지가 있으면 +1페이지 버튼을 활성화시키고 다음페이지로 이동. 다음페이지가 없으면 비활성화-->
                    <%
                        if (boardDAO.isNextPage(pageNumber, userId)) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+1%>"><%=pageNumber + 1%>
                    </a></li>
                    <%
                        } else{
                            %>
                    <li class="page-item disabled"><span class="page-link" style="color: darkgray;">X</span></li>
                    <!-- 현재+1페이지의 다음페이지가 있으면 +2페이지 버튼을 활성화시키고 +2페이지로 이동, 현재+1페이지의 다음페이지가 없으면 +2페이지 버튼 비활성화-->
                    <%
                        }
                        if (boardDAO.isNextPage(pageNumber + 1, userId)) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+2%>"><%=pageNumber + 2%>
                    </a></li>
                    <%
                        } else {
                            %>
                    <li class="page-item disabled"><span class="page-link" style="color: darkgray;">X</span></li>
                    <!-- 현재+2페이지의 다음페이지가 있으면 '...'버튼을 활성화시키고 다음페이지묶음 목록을 로드. 현재+2페이지의 다음페이지가 없으면 버튼 비활성화-->
                    <%
                        }
                        if (boardDAO.isNextPage(pageNumber + 2, userId)) { %>
                    <li class="page-item">
                        <a class="page-link"
                           href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+3%>"><span
                                class="glyphicon glyphicon-option-horizontal"></span></a>
                    </li>
                    <%
                    } else {
                    %>
                    <li class="page-item disabled">
                        <span class="page-link"><span class="glyphicon glyphicon-option-horizontal"></span></span>
                    </li>
                    <!-- 현재페이지의 다음페이지가 있으면 '다음'버튼을 활성화시키고 다음페이지로 이동. 다음페이지가 없으면 버튼 비활성화 -->
                    <% }
                        if (boardDAO.isNextPage(pageNumber, userId)) {
                    %>
                    <li class="page-item">
                        <a class="page-link"
                           href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+1%>">다음</a>
                    </li>
                    <%
                    } else {
                    %>
                    <li class="page-item disabled">
                        <span class="page-link">다음</span>
                    </li>
                    <%}%>
                    <!-- 마지막 페이지로 이동 -->
                    <li class="page-item">
                        <a class="page-link"
                           href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=boardDAO.getTotalPageNo(userId)%>">마지막</a>
                    </li>
                </ul>
            </nav>
            <%
                if (!("myBoard".equals(boardName))) {
            %>
            <a href="boardWrite.jsp?boardName=<%=boardName%>" class="btn btn-primary pull-right">글쓰기</a>
            <%
                }
            %>
        </div>
    </div>
</div>

<script>
    function onClickBoardTitle(boardName, boardNo, boardAuthorize, boardPassword) {
        if(boardAuthorize == 1) location.href = "boardView.jsp?boardName="+boardName+"&boardNo="+boardNo;
        else if(boardAuthorize==2) {
            var inputPassword = prompt("비밀번호를 입력하세요.(4자리 이하의 숫자)", "0000");

            if(inputPassword!=null) {
                if (boardPassword == inputPassword) location.href = "boardView.jsp?boardName=" + boardName + "&boardNo=" + boardNo + "&boardPassword=" + inputPassword;
                else {
                    alert("비밀번호 오류입니다.");
                }
            }
        }
    }
</script>