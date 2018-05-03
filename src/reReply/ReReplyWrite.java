package reReply;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReReplyWrite.ajax")
public class ReReplyWrite extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo = CommonValidation.boardNoValidation(request);
        int replyNo = CommonValidation.replyNoValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        String reReplyContnet = CommonValidation.replyContentValidation(request);

        if("".equals(sessionUserId)) response.getWriter().write("2");
        else{
            ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
            int result = reReplyDAO.write(boardNo, replyNo, sessionUserId, reReplyContnet);

            response.getWriter().write(String.valueOf(result));
        }
    }
}
