package board;

import org.json.simple.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/GetBoard.do")
public class GetBoard extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected  void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = null;
        String boardName = request.getParameter("boardName");
        JSONObject etcInformationJsonObj = new JSONObject();

        HttpSession session = request.getSession();

        if (session.getAttribute("userId") != null) {
            userId = (String) session.getAttribute("userId");
        }

        int boardNo = 0;
        if (request.getParameter("boardNo") != null) {
            boardNo = Integer.parseInt(request.getParameter("boardNo"));
        }

        if (boardNo == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('유효하지 않은 글입니다.')");
            script.println("location.href = 'GetBoardList.do?boardName=" + boardName + "'");
            script.println("</script>");
        }
        BoardVO boardVO = new BoardDAO(boardName).getBoardVO(boardNo);

        request.setAttribute("boardVO", boardVO);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("boardView.jsp");
        requestDispatcher.forward(request, response);
    }
}
