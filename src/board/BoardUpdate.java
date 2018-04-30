package board;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

@WebServlet("/BoardUpdate.do")
public class BoardUpdate extends HttpServlet {
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

        // boardName에 대한 validation은 boardWritepage에서 완료하였음.
        // 서버에서는 특수한 경우에 발생할 수 있는 nullpointException에 대한 처리만 하였음.
        String boardName = "";
        if (request.getParameter("boardName") != null) boardName = request.getParameter("boardName");

        int boardNo = 0;
        if (request.getParameter("boardNo") != null) boardNo = Integer.parseInt(request.getParameter("boardNo"));

        // 세션 userId에 대한 Validation 체크
        String userId = null;
        if (session.getAttribute("userId") != null) {
            userId = (String) session.getAttribute("userId");
        }
        if (userId == null) {
            Cookie reloadFlag = new Cookie("reloadFlag", "1");
            reloadFlag.setMaxAge(5);
            Cookie cookieBoardTitle = new Cookie("boardTitle", URLEncoder.encode(request.getParameter("boardTitle"), "utf-8"));
            cookieBoardTitle.setMaxAge(5);
            Cookie cookieBoardContent = new Cookie("boardContent", URLEncoder.encode(request.getParameter("boardContent"), "utf-8"));
            cookieBoardContent.setMaxAge(5);
            Cookie cookieBoardAuthorize = new Cookie("boardAuthorize", request.getParameter("boardAuthorize"));
            cookieBoardAuthorize.setMaxAge(5);

            response.addCookie(reloadFlag);
            response.addCookie(cookieBoardTitle);
            response.addCookie(cookieBoardContent);
            response.addCookie(cookieBoardAuthorize);

            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('서버로부터의 알림: 로그인이 풀렸습니다.')");
            script.println("location.href = '/login.jsp?prevPage=\'boardUpdate.jsp?boardName=" + boardName + "&boardNo=" + boardNo + "\''");
            script.println("</script>");
        }

        BoardDAO boardDAO = new BoardDAO(boardName);
        BoardVO boardVO = boardDAO.getBoardVO(boardNo);

        if (!userId.equals(boardVO.getBoardMakeUser())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('글 작성자가 아니세요.')");
            script.println("location.href = 'Login.jsp'");
            script.println("</script>");
        } else {
            int boardAuthorize = Integer.parseInt(request.getParameter("boardAuthorize"));
            String boardPassword = null;
            if (boardAuthorize == 2) {
                if (request.getParameter("boardPassword") != null) {
                    if (request.getParameter("boardPassword").equals("")) boardPassword = "0000";
                    else boardPassword = request.getParameter("boardPassword");
                } else boardPassword = "0000";
            }

            int result = boardDAO.update(Integer.parseInt(request.getParameter("boardNo")),
                    request.getParameter("boardTitle"),
                    request.getParameter("boardContent"),
                    Integer.parseInt(request.getParameter("boardAuthorize")),
                    boardPassword);

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
                script.println("alert('글 수정에 실패했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('수정 되었습니다.')");
                script.println("location.href='GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo + "&viewFlag=1'");
                script.println("</script>");
            }
        }
    }
}
