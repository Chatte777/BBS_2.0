package common;

import javax.net.ssl.HttpsURLConnection;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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

    static public int reReplyNoValidation(HttpServletRequest request){
        int reReplyNo=0;
        if(request.getParameter("reReplyNo")!=null) reReplyNo=Integer.parseInt(request.getParameter("reReplyNo"));
        return reReplyNo;
    }

    static public String userIdValidation(HttpServletRequest request) {
        String userId="";
        if(request.getParameter("userId")!=null) userId=request.getParameter("userId");
        return userId;
    }

    static public String userPasswordValidation(HttpServletRequest request){
        String userPassword="";
        if(request.getParameter("userPassword")!=null) userPassword=request.getParameter("userPassword");
        return userPassword;
    }

    static public int accountRemeberYnValidation(HttpServletRequest request){
        int accountRememberYn=0;
        if(request.getParameter("accountRememberYn")!=null) accountRememberYn=Integer.parseInt(request.getParameter("accountRememberYn"));
        return accountRememberYn;
    }

    static public int initialLoginFlagValidation(HttpServletRequest request){
        int initialLoginFlag=0;
        if(request.getParameter("initialLoginFlag")!=null) initialLoginFlag = Integer.parseInt(request.getParameter("initialLoginFlag"));
        return initialLoginFlag;
    }

    static public int alarmNoValidation(HttpServletRequest request){
        int alarmNo=0;
        if(request.getParameter("alarmNo")!=null) alarmNo=Integer.parseInt(request.getParameter("alarmNo"));
        return alarmNo;
    }

    static public String alarmTargetUserValidation(HttpServletRequest request){
        String alarmTargetUser="";
        if(request.getParameter("alarmTargetUser")!=null) alarmTargetUser=request.getParameter("alarmTargetUser");
        return alarmTargetUser;
    }

    static public int pageNumberValidation(HttpServletRequest request){
        int pageNumber=1;
        if(request.getParameter("pageNumber")!=null) pageNumber=Integer.parseInt(request.getParameter("pageNumber"));
        return pageNumber;
    }

    static public int fixedYnValidation(HttpServletRequest request){
        int fixedYn=2;
        if(request.getParameter("fixedYn")!=null) fixedYn=Integer.parseInt(request.getParameter("fixedYn"));
        return fixedYn;
    }

    static public int viewFlagValidation(HttpServletRequest request){
        int viewFlag=1;
        if(request.getParameter("viewFlag")!=null) viewFlag=Integer.parseInt(request.getParameter("viewFlag"));
        return viewFlag;
    }


}
