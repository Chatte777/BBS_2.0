package reply;

import com.sun.deploy.net.HttpRequest;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/ReplyDelete.do")
public class ReplyDelete extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request,response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String sessionId = session.getAttribute("userID").toString();
        String boardName = request.getParameter("boardName");
        int boardNo = Integer.parseInt(request.getParameter("boardNo"));
        int replyNo = Integer.parseInt(request.getParameter("replyNo"));

        ReplyDAO replyDAO = new ReplyDAO(boardName);
        ReplyVO replyVO = replyDAO.getReply(boardNo, replyNo);

        if(sessionId!=null && sessionId.equals(replyVO.getReplyMakeUser())){
            int result=0;
            if(replyVO.getHasReReply()==1) result = replyDAO.delete(boardNo, replyNo);
            else if(replyVO.getHasReReply()==2) result = replyDAO.deleteFail(boardNo, replyNo);

            if(result==1) response.getWriter().write("1");
        }
    }
}
