package common;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServlet;
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

    static public int boardAuthorizeValidation(HttpServletRequest request){
        int boardAuthorize=0;
        if(request.getParameter("boardAuthorize")!=null) boardAuthorize=Integer.parseInt(request.getParameter("boardAuthorize"));
        return boardAuthorize;
    }

    static public String boardTitleValildation(HttpServletRequest request){
        String boardTitle="";
        if(request.getParameter("boardTitle")!=null) boardTitle=request.getParameter("boardTitle");
        return boardTitle;
    }

    static public String boardContentValidation(HttpServletRequest request){
        String boardContent="";
        if(request.getParameter("boardContent")!=null) boardContent=request.getParameter("boardContent");
        return boardContent;
    }

    static public int writeFlagValidation(HttpServletRequest request){
        int writeFlag=0;
        if(request.getParameter("writeFlag")!=null) writeFlag=Integer.parseInt(request.getParameter("writeFlag"));
        return writeFlag;
    }
}
