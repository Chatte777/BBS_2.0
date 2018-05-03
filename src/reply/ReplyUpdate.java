package reply;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/ReplyUpdate.ajax")
public class ReplyUpdate extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo = CommonValidation.boardNoValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        int replyNo = CommonValidation.replyNoValidation(request);
        String replyContent = CommonValidation.replyContentValidation(request);

        if("".equals(sessionUserId)){
            response.getWriter().write(String.valueOf("2"));
        } else {
            ReplyDAO replyDAO = new ReplyDAO(boardName);
            int result = replyDAO.update(boardNo, replyNo, replyContent);

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(String.valueOf(result));
        }
    }
}
