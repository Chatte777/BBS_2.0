package reply;

import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import common.CommonValidation;

@WebServlet("/ReplyWrite.ajax")
public class ReplyWrite extends HttpServlet {
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
        String replyContent = CommonValidation.replyContentValidation(request);

        if ("".equals(sessionUserId)) response.getWriter().write("2");
        else {
            ReplyDAO replyDAO = new ReplyDAO(boardName);
            int result = replyDAO.write(boardNo, sessionUserId, replyContent);

            response.getWriter().write(String.valueOf(result));
        }
    }
}
