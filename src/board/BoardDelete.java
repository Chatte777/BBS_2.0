package board;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
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
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo = CommonValidation.boardNoValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter script = response.getWriter();
        script.println("<script>");

        if("".equals(sessionUserId)){
            script.println("alert('서버로부터의 알림 : 로그인이 풀렸어요!')");
            script.println("location.href='login.jsp'");
        } else {
            BoardDAO boardDAO = new BoardDAO(boardName);
            BoardVO boardVO = boardDAO.getBoardVO(boardNo);

            if (!sessionUserId.equals(boardVO.getBoardMakeUser())) {
                script.println("alert('서버로부터의 알림 : 글 작성자가 아니세요.')");
                script.println("history.back()");
            } else {
                int result = boardDAO.delete(boardNo);

                if (result == -1) {
                    script.println("alert('서버로부터의 알림 : 글 삭제에 실패했습니다.')");
                    script.println("history.back()");
                } else {
                    script.println("location.href='board.jsp?boardName=" + boardName + "'");
                }
            }
        }
        script.println("</script>");
    }
}
