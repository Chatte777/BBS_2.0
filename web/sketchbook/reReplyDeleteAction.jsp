<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ page import = "reply.*" %>
<%@ page import = "reReply.*" %>
<%@ page import = "java.io.PrintWriter" %>


<% request.setCharacterEncoding("UTF-8"); %>

<%
    String userId = null;
    String boardName = request.getParameter("boardName");
    int boardNo = Integer.parseInt(request.getParameter("boardNo"));

    if(session.getAttribute("userId") != null){
        userId = (String) session.getAttribute("userId");
    }
    if (userId == null) {
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('로그인을 하세요.')");
        script.println("location.href = 'Login.jsp'");
        script.println("</script>");
    }

    int replyNo = 0;
    if(request.getParameter("reReplyNo") != null){
        replyNo = Integer.parseInt(request.getParameter("reReplyNo"));
    }

    if(replyNo == 0){
        PrintWriter script = response.getWriter();
        script.println("<script>");
        script.println("alert('유효하지 않은 대댓글입니다.')");
        script.println("location.href = 'boardView.jsp?boardNo="+boardNo+"'");
        script.println("</script>");
    }

    ReReplyVO reReplyVO = new ReReplyVO();
    ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);

        int result = reReplyDAO.delete(Integer.parseInt(request.getParameter("boardNo")), Integer.parseInt(request.getParameter("replyNo")), Integer.parseInt(request.getParameter("reReplyNo")));

        if(result == -1){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('대댓글 삭제에 실패했습니다.')");
            script.println("history.back()");
            script.println("</script>");
        }
        else
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("location.href='boardView.jsp?boardName="+boardName+"&boardNo="+request.getParameter("boardNo")+"'");
            script.println("</script>");
        }

%>