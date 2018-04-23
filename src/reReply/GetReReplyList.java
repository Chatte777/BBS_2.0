package reReply;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import reply.ReplyDAO;
import reply.ReplyVO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetReReplyList.do")
public class GetReReplyList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        response.getWriter().write(getReReplyList(request.getParameter("boardName"), Integer.parseInt(request.getParameter("boardNo")), Integer.parseInt(request.getParameter("replyNo"))).toString());
    }

    private JSONArray getReReplyList(String boardName, int boardNo, int replyNo){
        ReReplyDAO reReplyDAO = new ReReplyDAO(boardName);
        ArrayList<ReReplyVO> reReplyList = reReplyDAO.getList(boardNo, replyNo);

        JSONArray reReplyListJsonArr = new JSONArray();

        for(int i=0; i<reReplyList.size(); i++){
            JSONObject replyJsonObj = new JSONObject();
            replyJsonObj.put("boardNo", reReplyList.get(i).getBoardNo());
            replyJsonObj.put("replyNo", reReplyList.get(i).getReplyNo());
            replyJsonObj.put("reReplyNo", reReplyList.get(i).getReReplyNo());
            replyJsonObj.put("reReplyContent", reReplyList.get(i).getReReplyContent());
            replyJsonObj.put("reReplyMakeUser", reReplyList.get(i).getReReplyMakeUser());
            replyJsonObj.put("reReplyMakeDt", reReplyList.get(i).getReReplyMakeDt());
            replyJsonObj.put("reReplyLikeCnt", reReplyList.get(i).getReReplyLikeCnt());
            replyJsonObj.put("reReplyDislikeCnt", reReplyList.get(i).getReReplyDislikeCnt());
            replyJsonObj.put("reReplyDeleteYn", reReplyList.get(i).getReReplyDeleteYn());

            reReplyListJsonArr.add(replyJsonObj);
        }

        return reReplyListJsonArr;
    }
}
