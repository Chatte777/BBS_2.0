package board;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

@WebServlet("/BoardWrite.do")
public class BoardWrite extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ////////// 변수선언 및 초기화
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        int result=0;
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo= CommonValidation.boardNoValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);

        String boardTitle = request.getParameter("boardTitle");
        int boardAuthorize = Integer.parseInt(request.getParameter("boardAuthorize"));
        String boardPassword = "";
        String boardContent = request.getParameter("boardContent");


        // 세션 userId에 대한 Validation 체크
        String userId = null;

        PrintWriter script = response.getWriter();

        script.println("<script>");
        script.println("alert('서버로부터의 알림: 로그인이 풀렸습니다.')");

        if("".equals(sessionUserId)){
            Cookie reloadFlag = new Cookie("reloadFlag", "1");
            reloadFlag.setMaxAge(5);
            Cookie cookieBoardTitle = new Cookie("boardTitle", URLEncoder.encode(request.getParameter("boardTitle"),"utf-8"));
            cookieBoardTitle.setMaxAge(5);
            Cookie cookieBoardContent = new Cookie("boardContent", URLEncoder.encode(request.getParameter("boardContent"),"utf-8"));
            cookieBoardContent.setMaxAge(5);
            Cookie cookieBoardAuthorize = new Cookie("boardAuthorize", request.getParameter("boardAuthorize"));
            cookieBoardAuthorize.setMaxAge(5);

            response.addCookie(reloadFlag);
            response.addCookie(cookieBoardTitle);
            response.addCookie(cookieBoardContent);
            response.addCookie(cookieBoardAuthorize);

            script.println("alert('서버로부터의 알림 : 로그인이 풀렸어요!')");
            script.println("location.href = 'login.jsp'");
        } else {
            BoardDAO boardDAO = new BoardDAO(boardName);

            // 게시글 비밀번호 처리
            if(boardAuthorize==2){
                if(request.getParameter("boardPassword")!=null) {
                    if(request.getParameter("boardPassword").equals("")) boardPassword="0000";
                    else boardPassword = request.getParameter("boardPassword");
                }
                else boardPassword = "0000";
            }

            //writeFlag==1 : 글 작성 __ writeFlag==2 : 글 수정 __ writeFlag==3 : 답글
            if("1".equals(request.getParameter("writeFlag"))){
                // DAO.write 호출
                result = boardDAO.write(boardTitle, userId, boardContent, boardAuthorize, boardNo, boardPassword);
            } else if("2".equals(request.getParameter("writeFlag"))){
                // 답글 작성할 경우에도 이 모듈을 사용하기 때문에 boardNo에 대한 정보가 있음.
                // boardNo가 비어있을 경우에는 '0'으로 처리하며 이 경우는 (답글이 아닌)원본글을 작성하는 경우.
                if(request.getParameter("boardNo")!=null && request.getParameter("boardNo")!="") boardNo = Integer.parseInt(request.getParameter("boardNo"));
                result = boardDAO.update(boardNo, boardTitle, boardContent, boardAuthorize, boardPassword);
            } else if("3".equals(request.getParameter("wriiteFlag"))){
                if(request.getParameter("boardNo")!=null && request.getParameter("boardNo")!="") boardNo = Integer.parseInt(request.getParameter("boardNo"));
                result = boardDAO.write(boardTitle, userId, boardContent, boardAuthorize, boardNo, boardPassword);
            }


            // 실패했을 경우 작성한 값들을 쿠키에 임시 저장 및 reoloadFlag를 1로 변경.
            if (result == -1) {
                Cookie reloadFlag = new Cookie("reloadFlag", "1");
                reloadFlag.setMaxAge(5);
                Cookie cookieBoardTitle = new Cookie("boardTitle", URLEncoder.encode(request.getParameter("boardTitle"),"utf-8"));
                cookieBoardTitle.setMaxAge(5);
                Cookie cookieBoardContent = new Cookie("boardContent", URLEncoder.encode(request.getParameter("boardContent"),"utf-8"));
                cookieBoardContent.setMaxAge(5);
                Cookie cookieBoardAuthorize = new Cookie("boardAuthorize", request.getParameter("boardAuthorize"));
                cookieBoardAuthorize.setMaxAge(5);

                response.addCookie(reloadFlag);
                response.addCookie(cookieBoardTitle);
                response.addCookie(cookieBoardContent);
                response.addCookie(cookieBoardAuthorize);

                script.println("alert('서버로부터의 알림 : 글쓰기에 실패했습니다.')");
                script.println("location.href='GetBoardList.do?boardName="+boardName+"'");
            } else {
                script.println("location.href='GetBoardList.do?boardName="+boardName+"'");
            }
        }

        script.println("</script>");
    }
}
