package board;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/BoardUpdate.do")
public class BoardUpdate extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardName = request.getParameter("boardName");
        BoardDAO boardDAO = new BoardDAO(boardName);
        BoardVO boardVO = boardDAO.getBoardVO(Integer.parseInt(request.getParameter("boardNo")));

        request.setAttribute("boardVO", boardVO);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("boardUpdate.jsp");
        requestDispatcher.forward(request, response);
    }
}
