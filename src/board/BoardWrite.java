package board;

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
        String boardPassword = "";

        // 답글 작성할 경우에도 이 모듈을 사용하기 때문에 boardNo에 대한 정보가 있음.
        // boardNo가 비어있을 경우에는 '0'으로 처리하며 이 경우는 (답글이 아닌)원본글을 작성하는 경우.
        int boardNo=0;
        if(request.getParameter("boardNo")!=null && request.getParameter("boardNo")!="") boardNo = Integer.parseInt(request.getParameter("boardNo"));

        // boardName에 대한 validation은 boardWritepage에서 완료하였음.
        // 서버에서는 특수한 경우에 발생할 수 있는 nullpointException에 대한 처리만 하였음.
        String boardName="";
        if(request.getParameter("boardName")!=null) boardName = request.getParameter("boardName");

        // boardAuthorize에 대한 validation체크 및 값 가져오기
        int boardAuthorize=1;
        if(request.getParameter("boardAuthorize")!=null) boardAuthorize = Integer.parseInt(request.getParameter("boardAuthorize"));

        // 세션 userId에 대한 Validation 체크
        String userId = null;
        if (session.getAttribute("userId") != null) {
            userId = (String) session.getAttribute("userId");
        }
        if (userId == null) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('서버로부터의 알림: 로그인이 풀렸습니다.')");
            script.println("location.href = '/login.jsp?prevPage=\'boardWrite.jsp?boardName="+boardName+"&boardNo="+boardNo+"\''");
            script.println("</script>");
        }

        BoardDAO boardDAO = new BoardDAO(boardName);

        // 게시글 비밀번호 처리
        if(boardAuthorize==2){
            if(request.getParameter("boardPassword")!=null) {
                if(request.getParameter("boardPassword").equals("")) boardPassword="0000";
                else boardPassword = request.getParameter("boardPassword");
            }
            else boardPassword = "0000";
        }

        // DAO.write 호출
        int result = boardDAO.write(request.getParameter("boardTitle"), userId, request.getParameter("boardContent"),
                boardAuthorize, boardNo, boardPassword);

        // 실패했을 경우 작성한 값들을 쿠키에 임시 저장 및 reoloadFlag를 1로 변경.
        // reloadFlag가 1일경우는 boardWrite페이지에 임시저장되어있는 값을 불러옴.
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
            PrintWriter script = response.getWriter();

            script.println("<script>");
            script.println("alert('서버로부터의 알림 : 글쓰기에 실패했습니다.')");
            script.println("location.href='boardWrite.jsp?boardName="+boardName+"'");
            script.println("</script>");
        } else {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("location.href='GetBoardList.do?boardName="+boardName+"'");
            script.println("</script>");
        }
    }
}
