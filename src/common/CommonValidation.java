package common;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class CommonValidation {
    static public String sessionUserIdValidation(HttpServletRequest request){
        String sessionUserId="";
        HttpSession session = request.getSession();
        if (session.getAttribute("userId") != null) sessionUserId=(String) session.getAttribute("userId");
        return sessionUserId;
    }

    static public String boardNameValidation(HttpServletRequest requeset){
        String boardName="";
        if(requeset.getParameter("boardName")!=null) boardName=requeset.getParameter("boardName");
        return boardName;
    }

    static public int boardNoValidation(HttpServletRequest request){
        int boardNo=0;
        if(request.getParameter("boardNo")!=null) boardNo=Integer.parseInt(request.getParameter("boardNo"));
        return boardNo;
    }

    static public int replyNoValidation(HttpServletRequest request){
        int replyNo=0;
        if(request.getParameter("replyNo")!=null) replyNo=Integer.parseInt(request.getParameter("replyNo"));
        return  replyNo;
    }

    static public String replyContentValidation(HttpServletRequest request){
        String replyContent="";
        if(request.getParameter("replyContent")!=null) replyContent=request.getParameter("replyContent");
        return replyContent;
    }
}
