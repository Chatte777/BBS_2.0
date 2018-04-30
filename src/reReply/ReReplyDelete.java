package reReply;

import reply.ReplyDAO;
import reply.ReplyVO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ReReplyDelete.ajax")
public class ReReplyDelete extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request,response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionId = session.getAttribute("userId").toString();
        String boardName = request.getParameter("boardName");
        int boardNo = Integer.parseInt(request.getParameter("boardNo"));
        int replyNo = Integer.parseInt(request.getParameter("replyNo"));
        int reReplyNo = Integer.parseInt(request.getParameter("reReplyNo"));

        ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
        ReReplyVO reReplyVO = reReplyDAO.getReReply(boardNo, replyNo, reReplyNo);

        if(sessionId!=null && sessionId.equals(reReplyVO.getReReplyMakeUser())){
            int result = reReplyDAO.delete(boardNo, replyNo, reReplyNo);
            if(result==1) response.getWriter().write("1");
        }
    }
}
