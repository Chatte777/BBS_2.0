package reply;

import reReply.ReReplyDAO;
import reReply.ReReplyVO;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetReplyList.do")
public class GetReplyList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String boardName = request.getParameter("boardName");
        int boardNo = Integer.parseInt(request.getParameter("boardNo"));
        ArrayList<ReReplyVO> reReplyList=null;

        //세션에서 ID 받아오기
        String userId = null;
        if (session.getAttribute("userID") != null) {
            userId = (String) session.getAttribute("userID");
        }

        ReplyDAO replyDAO = new ReplyDAO(boardName);
        ArrayList<ReplyVO> replyList = replyDAO.getList(boardNo);


        for (int i = 0; i < replyList.size(); i++) {
            int replyNo = replyList.get(i).getReplyNo();
            String replyContent = replyList.get(i).getReplyContent();
            if (replyContent.length() >= 10) replyContent = "<" + replyContent.substring(0, 10) + "...>";
            else replyContent = "<" + replyContent + ">";

            if (replyList.get(i).getHasReReply() == 2) {
                ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
                reReplyList = reReplyDAO.getList(boardNo, replyNo);
            }
        }

        request.setAttribute("replyList", replyList);
        request.setAttribute("reReplyList", reReplyList);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("board.jsp");
        requestDispatcher.forward(request, response);
    }

    public String getReplyList(String boardName, int boardNo, String sessionId){
        ReplyDAO replyDAO = new ReplyDAO(boardName);
        ArrayList<ReplyVO> replyList = replyDAO.getList(boardNo);

        return replyList.toString();
    }
}
