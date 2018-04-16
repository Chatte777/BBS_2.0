<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="java.io.PrintWriter" %>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="reply.ReplyVO" %>
<%@ page import="reply.ReplyDAO" %>
<%@ page import="reReply.ReReplyDAO" %>
<%@ page import="reReply.ReReplyVO" %>


<%
    String userId = null;
    String boardName = request.getParameter("boardName");

    if (session.getAttribute("userID") != null) {
        userId = (String) session.getAttribute("userID");
    }

    int boardNo = 0;
    if (request.getParameter("boardNo") != null) {
        boardNo = Integer.parseInt(request.getParameter("boardNo"));
    }

    if (boardNo == 0) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 글입니다.')");
        script.println("location.href = '" + boardName + ".jsp'");
        script.println("</script>");
    }
    BoardVO boardVO = new BoardDAO(boardName).getBoardVO(boardNo);
%>


<div class="container">
    <div class="row">
        <table class="table table-striped"
               style="text-align: center; border: 1px solid #dddddd; word-break: break-all; margin-bottom: 5px;">
            <thead>
            <tr>
                <th colspan="4" style="background-color: #eeeeee; text-align: center;">게시판 글</th>
            </tr>
            </thead>

            <tbody>
            <tr>
                <td style="width: 20%;">글제목</td>
                <td colspan="3" align="left">
                    <%
                        if (boardVO.getBoardAuthorize() == 2) {
                    %><span class="glyphicon glyphicon-lock" style="color: #bbbbbb;">&nbsp;</span><%
                    }
                %>
                    <%=boardVO.getBoardTitle().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
                            .replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
                </td>
            </tr>
            <tr>
                <td>작성자</td>
                <td colspan="3" align="left"><%=boardVO.getBoardMakeUser()%>
                </td>
            </tr>
            <tr>
                <td>작성일자</td>
                <td colspan="3" align="left"><%=boardVO.getBoardMakeDt().substring(0, 11)
                        + boardVO.getBoardMakeDt().substring(11, 13) + "시"
                        + boardVO.getBoardMakeDt().substring(14, 16) + "분"%>
                </td>
            </tr>
            <tr>
                <td>내용</td>
                <td colspan="3" style="min-height: 200px; text-align: left;">
                    <p><%=boardVO.getBoardContent()%>
                    </p>
                </td>
            </tr>
            </tbody>
        </table>
        <div style="margin-bottom: 10px;" align="right">
            <%
                if (userId != null && userId.equals(boardVO.getBoardMakeUser())) {
            %>
            <a href="boardUpdate.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>" class="btn btn-primary">수정</a>
            <a onclick="return confirm('정말로 삭제하시겠습니까?')"
               href="boardDeleteAction.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>" class="btn btn-primary">삭제</a>&nbsp;
            <%
            } else {
            %>
            <a href="#" class="btn btn-primary" style="background:gray;">수정</a>
            <a href="#" class="btn btn-primary" style="background:gray;">삭제</a>&nbsp;
            <%
                }
            %>
        </div>

        <table class="table table-striped">
            <tbody>
            <%
                ReplyDAO replyDAO = new ReplyDAO(boardName);
                ArrayList<ReplyVO> list = replyDAO.getList(boardNo);

                for (int i = 0; i < list.size(); i++) {
                    int replyNo = list.get(i).getReplyNo();
                    String replyContent = list.get(i).getReplyContent();
                    if (replyContent.length() >= 10) replyContent = "<" + replyContent.substring(0, 10) + "...>";
                    else replyContent = "<" + replyContent + ">";
            %>
            <tr onclick="reReplyClick('<%=replyNo%>', '<%=replyContent%>')">
                <td align="center"></td>
                <td align="left"
                    style="word-break: break-all;"><%=list.get(i).getReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
                        .replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
                </td>
                <td align="center" style="width: 10%;" onclick="event.cancelBubble = true;">
                    <a onclick="reReplyClick('<%=replyNo%>', '<%=replyContent%>')"
                       type="button" class="glyphicon glyphicon-share-alt" style="color: seagreen; padding:0px 5px 0px 0px;"/>
                    <%
                        if (userId != null && userId.equals(list.get(i).getReplyMakeUser())) {
                    %>
                    <a onclick="modifyClick('<%=list.get(i).getReplyContent()%>', '<%=replyNo%>')" type="button"
                       class="glyphicon glyphicon-pencil" style="color: limegreen; padding:5px;"/>
                    <a onclick="return confirm('정말 삭제하시겠습니까?')" a
                       href="replyDeleteAction.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>&replyNo=<%=replyNo%>"
                       type="button" class="glyphicon glyphicon-remove" style="color: #a9a9a9; padding:5px;"/>  <%
                    }
                %>
                </td>
                <td style="width: 10%;"><%=list.get(i).getReplyMakeUser()%>
                </td>
                <td style="width: 15%;"><%=list.get(i).getReplyMakeDt().substring(0, 11) + list.get(i).getReplyMakeDt().substring(11, 13)
                        + "시" + list.get(i).getReplyMakeDt().substring(14, 16) + "분"%>
                </td>
            </tr>
            <%
                ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
                ArrayList<ReReplyVO> listReReply = reReplyDAO.getList(boardNo, replyNo);

                for (int j = 0; j < listReReply.size(); j++) {
            %>
            <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                <td align="center" style="border: none;"><span class="glyphicon glyphicon-menu-right"
                                                               style="color: #bbbbbb;">&nbsp;</span></td>
                <td style="border: none;" align="left"><%=listReReply.get(j).getReReplyMakeUser()%>
                    &nbsp; <%=listReReply.get(j).getReReplyMakeDt().substring(0, 11)
                            + listReReply.get(j).getReReplyMakeDt().substring(11, 13) + "시"
                            + listReReply.get(j).getReReplyMakeDt().substring(14, 16) + "분"%>
                    &nbsp;
                    <%
                        if (userId != null && userId.equals(listReReply.get(j).getReReplyMakeUser())) {
                    %>
                        <a onclick="modifyClick('<%=listReReply.get(j).getReReplyContent()%>', '<%=listReReply.get(j).getReReplyNo()%>')"
                           type="button" class="glyphicon glyphicon-pencil" style="color: #cccccc"/>
                        <a onclick="return confirm('정말로 삭제하시겠습니까?')" a
                           href="reReplyDeleteAction.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>&replyNo=<%=replyNo%>&reReplyNo=<%=listReReply.get(j).getReReplyNo()%>"
                           type="button" class="glyphicon glyphicon-remove" style="color: #cccccc; padding:0px;"/><%
                            }
                        %>
                    </td>
                <td style="border: none;">

                </td>
                <td style="border: none;"></td>
                <td style="border: none;"></td>
            </tr>
            <tr style="height: 1px; font-size: 0.875em; background-color: #FEFEF2; margin: 1em;">
                <td style=" border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;"></td>
                <td align="left"
                    style="word-break: break-all; border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;"><%=listReReply.get(j).getReReplyContent().replaceAll(" ", "&nbsp;").replaceAll("<", "&lt;")
                        .replaceAll(">", "&gt;").replaceAll("\n", "<br>")%>
                </td>
                <td style="border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;;"></td>
                <td style="border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;"></td>
                <td align="center"
                    style="width: 5%; border-top-style: none; border-bottom-style: dashed; border-right-style: none; border-left-style: none; border-bottom-color: lightskyblue; border-width: 0.1em;">

                </td>
            </tr>
            <%
                    }
                }
            %>

            </tbody>
        </table>
    </div>

    <form name="replyForm">
        <table class="table table-condensed">
            <tbody>
            <tr>
                <td style="width: 90%;"><textarea class="form-control" placeholder="댓글" name="replyContent"
                                                  id="replyContent" maxlength="2048" style="height: 150px;"></textarea>
                </td>
                <td style="width: 10%; vertical-align: bottom;" align="center"><input type="button"
                                                                                      onclick="replySubmit('<%=boardName%>')"
                                                                                      class="btn btn-primary pull-right"
                                                                                      value="댓글작성"></td>
            </tr>
            </tbody>
        </table>
        <input type="hidden" name="boardNo" id="boardNo" value="<%=boardNo%>">
    </form>

    <div class="row" align="right">
        <a href="board.jsp?boardName=<%=boardName%>" class="btn btn-primary">목록</a>
        <%
            if (boardVO.getIsRebaord() == 1) {
        %>
        <a href="boardWrite.jsp?boardName=<%=boardName%>&boardNo=<%=boardNo%>" class="btn btn-primary">답글쓰기</a>
        <%
        } else {
        %>
        <a href="#" class="btn btn-primary" style="background:gray;">답글쓰기</a>
        <%}%>

        <a href="boardWrite.jsp?boardName=<%=boardName%>" class="btn btn-primary">글쓰기</a>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>
<script src="js/bootstrap.js"></script>

<script>
    var _updateFlag = 1;
    var _replyNo = 0;

    function modifyClick(replyContent, replyNo) {
        _updateFlag = 2;
        _replyNo = replyNo;
        document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent;
    }

    function reReplyClick(replyNo, replyContent) {
        _updateFlag = 3;
        _replyNo = replyNo;document.getElementById("replyContent").focus();
        document.getElementById("replyContent").value = replyContent + "에 대한 대댓글을 작성하세요.";
    }

    function replySubmit(boardName) {
        if (_updateFlag == 1) {
            document.replyForm.action = "replyAction.jsp?boardName=" + boardName;
            document.replyForm.method = "post";
            document.replyForm.submit();
        } else if (_updateFlag == 2) {
            document.replyForm.action = "replyUpdateAction.jsp?boardName=" + boardName + "&board_no=<%=boardNo%>&replyNo=" + _replyNo;
            document.replyForm.method = "post";
            document.replyForm.submit();
        } else if (_updateFlag == 3) {
            document.replyForm.action = "reReplyAction.jsp?boardName=" + boardName + "&board_no=<%=boardNo%>&replyNo=" + _replyNo;
            document.replyForm.method = "post";
            document.replyForm.submit();
        }
    }
</script>