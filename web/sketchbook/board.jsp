<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>

<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width", initial-scale="1">
    <link rel="stylesheet" href="../css/bootstrap.css">
    <title>DREAMY KAT</title>
    <style type="text/css">
        a, a:hover {
            color: #000000;
            text-decoration: none;
        }
    </style>
</head>
<body>
<jsp:include page="../_headNav.jsp" flush="false"/>
<%
    String boardName = request.getParameter("boardName");
%>
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
            <%
                String userId = null;
                if (session.getAttribute("userId") != null) {
                    userId = (String) session.getAttribute("userId");
                }

                int pageNumber = 1;
                if (request.getParameter("pageNumber") != null) {
                    pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
                }

                BoardDAO boardDAO = new BoardDAO(boardName);
                ArrayList<BoardVO> list;

                if ("myBoard".equals(boardName)) {
                    list = boardDAO.getMyList(pageNumber, userId);
                } else {
                    list = boardDAO.getList(pageNumber, userId);
                }

                int replyCnt;
                int replyColorFlag;
                int boardColorFlag;

                for (int i = 0; i < list.size(); i++) {
                    if (list.get(i).getIsRebaord() == 1) {
                        if ("myBoard".equals(boardName)) {
                            replyCnt = boardDAO.getMyReplyCnt(list.get(i).getTableName(), list.get(i).getBoardNo());
                            replyColorFlag = boardDAO.getMyReplyColor(list.get(i).getTableName(), list.get(i).getBoardNo());
                        } else {
                            replyCnt = boardDAO.getReplyCnt(list.get(i).getBoardNo());
                            replyColorFlag = boardDAO.getReplyColor(list.get(i).getBoardNo());
                        }
                        boardColorFlag = boardDAO.getBoardColor(list.get(i).getBoardNo());
            %>
            <tr>
                <td><%= list.get(i).getBoardReadCount() %>
                </td>

                <td align="left" colspan="2">
                    <%
                        if (list.get(i).getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
                    }
                %>
                    <a href="./boardView.jsp?boardName=<%=list.get(i).getTableName()%>&boardNo=<%= list.get(i).getBoardNo() %>"
                            <%
                                if (boardColorFlag == 1) {%>
                       style="color: #DE2A45;"<%} else if (boardColorFlag == 2) {%>
                       style="color:#10BF00;"<%} else if (boardColorFlag == 3) {%>
                       style="color:#2865BF;"<%} else if (boardColorFlag == 4) {%> style="color:black;"<%}%>>
                        <%= list.get(i).getBoardTitle() %>
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
                <td><%= list.get(i).getBoardMakeUser() %>
                </td>
                <td><%= list.get(i).getBoardMakeDt().substring(5, 7) + "/" + list.get(i).getBoardMakeDt().substring(8, 13) + ":" + list.get(i).getBoardMakeDt().substring(14, 16) %>
                </td>
            </tr>
            <%
                if (list.get(i).getHasReboard() == 2) {
                    BoardDAO reboardDAO = new BoardDAO(boardName);
                    ArrayList<BoardVO> listReboard = reboardDAO.getReboardList(userId, list.get(i).getBoardNo());

                    for (int j = 0; j < listReboard.size(); j++) {

                        if ("myBoard".equals(boardName)) {
                            replyCnt = reboardDAO.getMyReplyCnt(listReboard.get(j).getTableName(), listReboard.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getMyReplyColor(listReboard.get(j).getTableName(), listReboard.get(j).getBoardNo());
                        } else {
                            replyCnt = reboardDAO.getReplyCnt(listReboard.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getReplyColor(listReboard.get(j).getBoardNo());
                        }
                        boardColorFlag = reboardDAO.getBoardColor(listReboard.get(j).getBoardNo());
            %>
            <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                <td align="center"><span class="glyphicon glyphicon-menu-right" style="color: #bbbbbb;">&nbsp;</span></td>
                <td align="left" ><a href="./boardView.jsp?boardName=<%=listReboard.get(j).getTableName()%>&boardNo=<%= listReboard.get(j).getBoardNo() %>">조회수&nbsp;<%= listReboard.get(j).getBoardReadCount() %></a>
                </td>
                <td align="left">
                    <%
                        if (listReboard.get(j).getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
                    }
                %>
                    <a href="./boardView.jsp?boardName=<%=listReboard.get(j).getTableName()%>&boardNo=<%= listReboard.get(j).getBoardNo() %>"
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
                    <li class="page-item">
                        <a class="page-link" href="board.jsp?boardName=<%=boardName%>&pageNumber=1">처음</a>
                    </li>
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
                    <% }
                        if (pageNumber > 2) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-2%>"><%=pageNumber - 2%>
                    </a></li>
                    <%
                        }
                        if (pageNumber > 1) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-1%>"><%=pageNumber - 1%>
                    </a></li>
                    <%
                        }
                    %>
                    <li class="page-item active">
      <span class="page-link">
        <%=pageNumber%>
        <span class="sr-only">(current)</span>
      </span>
                    </li>
                    <%
                        if (boardDAO.isNextPage(pageNumber, userId)) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+1%>"><%=pageNumber + 1%>
                    </a></li>
                    <%
                        }
                        if (boardDAO.isNextPage(pageNumber + 1, userId)) {
                    %>
                    <li class="page-item"><a class="page-link"
                                             href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+2%>"><%=pageNumber + 2%>
                    </a></li>
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


<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>
</body>
</html>