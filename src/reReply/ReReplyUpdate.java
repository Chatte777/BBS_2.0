package reReply;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ReReplyUpdate.ajax")
public class ReReplyUpdate extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo = CommonValidation.boardNoValidation(request);
        int replyNo = CommonValidation.replyNoValidation(request);
        int reReplyNo = CommonValidation.reReplyNoValidation(request);
        String reReplyContent = CommonValidation.replyContentValidation(request);


        if("".equals(sessionUserId)) response.getWriter().write("2");
        else {
            ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
            int result = reReplyDAO.update(boardNo, replyNo, reReplyNo, reReplyContent);

            response.getWriter().write(String.valueOf(result));
        }
    }
}