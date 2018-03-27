<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>

<%
    String boardName = request.getParameter("boardName");
%>
<div class="container">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
            <thead>
            <tr>
                <th style="background-color: #eeeeee; text-align: center;">조회수</th>
                <th style="background-color: #eeeeee; text-align: center;" colspan="2">제목</th>
                <th style="background-color: #eeeeee; text-align: center;">댓글</th>
                <th style="background-color: #eeeeee; text-align: center;">작성자</th>
                <th style="background-color: #eeeeee; text-align: center;">작성일</th>
            </tr>
            </thead>

            <tbody>
            <%
                String userId = null;
                if (session.getAttribute("userID") != null) {
                    userId = (String) session.getAttribute("userID");
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
                    <a href="boardView.jsp?boardName=<%=list.get(i).getTableName()%>&boardNo=<%= list.get(i).getBoardNo() %>"
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
                            replyCnt = reboardDAO.getMyReplyCnt(list.get(j).getTableName(), list.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getMyReplyColor(list.get(j).getTableName(), list.get(j).getBoardNo());
                        } else {
                            replyCnt = reboardDAO.getReplyCnt(list.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getReplyColor(list.get(j).getBoardNo());
                        }
                        boardColorFlag = reboardDAO.getBoardColor(list.get(j).getBoardNo());
            %>
            <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                <td align="center"><span class="glyphicon glyphicon-menu-right" style="color: #bbbbbb;">&nbsp;</span></td>
                <td align="left" ><a href="boardView.jsp?boardName=<%=list.get(j).getTableName()%>&boardNo=<%= list.get(j).getBoardNo() %>">조회수&nbsp;<%= list.get(j).getBoardReadCount() %></a>
                </td>
                <td align="left">
                    <%
                        if (list.get(j).getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
                    }
                %>
                    <a href="boardView.jsp?boardName=<%=list.get(j).getTableName()%>&boardNo=<%= list.get(j).getBoardNo() %>"
                            <%
                                if (boardColorFlag == 1) {%>
                       style="color: #DE2A45;"<%} else if (boardColorFlag == 2) {%>
                       style="color:#10BF00;"<%} else if (boardColorFlag == 3) {%>
                       style="color:#2865BF;"<%} else if (boardColorFlag == 4) {%> style="color:black;"<%}%>>
                        <%= list.get(j).getBoardTitle() %>
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
                <td><%= list.get(j).getBoardMakeUser() %>
                </td>
                <td><%= list.get(j).getBoardMakeDt().substring(5, 7) + "/" + list.get(j).getBoardMakeDt().substring(8, 13) + ":" + list.get(j).getBoardMakeDt().substring(14, 16) %>
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

        <%
            if (pageNumber != 1) {
        %>
        <a href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-1%>"
           class="btn btn-successs btn-arrow-left">이전</a>
        <%
        } else { %>
        <a href="#" class="btn btn-primary btn-arrow-left" style="background: gray;">이전</a>
        <%
            }

            if (boardDAO.isNextPage(pageNumber, userId)) {
        %>
        <a href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+1%>"
           class="btn btn-successs btn-arrow-right">다음</a>
        <%
        } else {
        %>
        <a href="#" class="btn btn-primary btn-arrow-right" style="background: gray;">다음</a>
        <% } %>
        <a href="boardWrite.jsp?boardName=<%=boardName%>" class="btn btn-primary pull-right">글쓰기</a>
    </div>
</div>
