package board;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/BoardDelete.do")
public class BoardDelete extends HttpServlet {
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
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('서버로부터의 알림: 로그인이 풀렸습니다.')");
            script.println("location.href = '/login.jsp?prevPage=\'GetBoard.do?boardName=" + boardName + "&boardNo=" + boardNo + "\''");
            script.println("</script>");
        }

        BoardDAO boardDAO = new BoardDAO(boardName);
        BoardVO boardVO = boardDAO.getBoardVO(boardNo);

        if (!userId.equals(boardVO.getBoardMakeUser())) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('서버로부터의 알림 : 글 작성자가 아니세요.')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            int result = boardDAO.delete(boardNo);

            if (result == -1) {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('서버로부터의 알림 : 글 삭제에 실패했습니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("location.href='GetBoardList.do?boardName=" + boardName + "'");
                script.println("</script>");
            }
        }
    }
}
