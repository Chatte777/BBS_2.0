package reply;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetReplyList.ajax")
public class GetReplyList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ReplyDAO replyDAO = new ReplyDAO(request.getParameter("boardName"));
        ArrayList<ReplyVO> replyList = replyDAO.getList(Integer.parseInt(request.getParameter("boardNo")));

        JSONArray replyListJsonArr = new JSONArray();

        for(int i=0; i<replyList.size(); i++){
            JSONObject replyJsonObj = new JSONObject();
            replyJsonObj.put("boardNo", replyList.get(i).getBoardNo());
            replyJsonObj.put("replyNo", replyList.get(i).getReplyNo());
            replyJsonObj.put("replyContent", replyList.get(i).getReplyContent());
            replyJsonObj.put("replyMakeUser", replyList.get(i).getReplyMakeUser());
            replyJsonObj.put("replyMakeDt", replyList.get(i).getReplyMakeDt());
            replyJsonObj.put("replyLikeCnt", replyList.get(i).getReplyLikeCnt());
            replyJsonObj.put("replyDislikeCnt", replyList.get(i).getReplyDislikeCnt());
            replyJsonObj.put("replyDeleteYn", replyList.get(i).getReplyDeleteYn());
            replyJsonObj.put("hasReReply", replyList.get(i).getHasReReply());

            replyListJsonArr.add(replyJsonObj);
        }

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(replyListJsonArr.toString());
    }
}
