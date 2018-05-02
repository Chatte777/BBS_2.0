package reply;

import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;

@WebServlet("/ReplyWrite.ajax")
public class ReplyWrite extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int result=0;

        // boardName에 대한 validation은 boardWritepage에서 완료하였음.
        // 서버에서는 특수한 경우에 발생할 수 있는 nullpointException에 대한 처리만 하였음.
        String boardName="";
        if(request.getParameter("boardName")!=null) boardName = request.getParameter("boardName");

        int boardNo=0;
        if(request.getParameter("boardNo")!=null) boardNo = Integer.parseInt(request.getParameter("boardNo"));

        // 세션 userId에 대한 Validation 체크
        HttpSession session = request.getSession();
        String userId = null;
        if (session.getAttribute("userId") != null) {
            userId = (String) session.getAttribute("userId");

            ReplyDAO replyDAO = new ReplyDAO(boardName);
            result = replyDAO.write(boardNo, userId, request.getParameter("replyContent"));
        }
        if (userId == null) {
            PrintWriter script = response.getWriter();

            result=2;
        }

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(String.valueOf(result));
    }
}
