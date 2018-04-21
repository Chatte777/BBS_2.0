package reReply;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetReReplyList")
public class GetReReplyList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    public String getReReplyList(String boardName, int boardNo, int replyNo, String sessionId){
        ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
        ArrayList<ReReplyVO> reReplyList = reReplyDAO.getReReplyList(boardNo, replyNo);

        return reReplyList.toString();
    }
}
