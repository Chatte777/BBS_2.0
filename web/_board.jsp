<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>

<div class="container">
    <div class="row">
        <table class="table table-striped" style="text-align: center; border: 1px solid #dddddd">
            <thead>
            <tr>
                <th style="background-color: #eeeeee; text-align: center;">조회수</th>
                <th style="background-color: #eeeeee; text-align: center;">제목</th>
                <th style="background-color: #eeeeee; text-align: center;">댓글</th>
                <th style="background-color: #eeeeee; text-align: center;">작성자</th>
                <th style="background-color: #eeeeee; text-align: center;">작성일</th>
            </tr>
            </thead>

            <tbody>
            <%
                String userId = null;
                if(session.getAttribute("userID") != null){
                    userId = (String)session.getAttribute("userID");
                }

                int pageNumber = 1;
                if(request.getParameter("pageNumber") != null) {
                    pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
                }

                    String boardName = request.getParameter("boardName");

                    BoardDAO boardDAO = new BoardDAO(boardName);
                    ArrayList<BoardVO> list = boardDAO.getList(pageNumber, userId);

                    for(int i=0; i<list.size(); i++){
                        int replyCnt = boardDAO.getReplyCnt(list.get(i).getBoardNo());
                        int replyColorFlag = boardDAO.getReplyColor(list.get(i).getBoardNo());
            %>
            <tr>
                <td><%= list.get(i).getBoardReadCount() %></td>
                <td align="left"><a href="boardView.jsp?boardName=<%=boardName%>&boardNo=<%= list.get(i).getBoardNo() %>"><%= list.get(i).getBoardTitle() %></a></td>
                <td
                        <%
                            if(replyColorFlag==1){%> style="color:#873286;"<%}
                else if(replyColorFlag==2){%> style="color:#DE2A45;"<%}
                else if(replyColorFlag==3){%> style="color:#F5762C;"<%}
                else if(replyColorFlag==4){%> style="color:#10BF00;"<%}
                else if(replyColorFlag==5){%> style="color:#2865BF;"<%}
                else if(replyColorFlag==6){%> style="color:black;"<%}
                %>>
                    <%if(replyCnt!=0){%><%=replyCnt%><%}%></td>
                <td><%= list.get(i).getBoardMakeUser() %></td>
                <td><%= list.get(i).getBoardMakeDt().substring(5,7)+"/"+list.get(i).getBoardMakeDt().substring(8,13)+":"+list.get(i).getBoardMakeDt().substring(14,16) %></td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>

        <%
            if(pageNumber!= 1){
        %>
        <a href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber-1%>" class="btn btn-successs btn-arrow-left">이전</a>
        <%
            } else { %>
        <a href="#" class="btn btn-primary btn-arrow-left" style="background: gray;">이전</a>
        <%
            }

            if(boardDAO.isNextPage(pageNumber, userId)) {
        %>
        <a href="board.jsp?boardName=<%=boardName%>&pageNumber=<%=pageNumber+1%>" class="btn btn-successs btn-arrow-right">다음</a>
        <%
            } else {
        %>
        <a href="#" class="btn btn-primary btn-arrow-right" style="background: gray;">다음</a>
        <% } %>
        <a href="boardWrite.jsp?boardName=<%=boardName%>" class="btn btn-primary.disabled pull-right">글쓰기</a>
    </div>
</div>
