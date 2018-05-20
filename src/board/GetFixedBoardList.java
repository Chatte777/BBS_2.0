package board;

import common.CommonValidation;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetFixedBoardList.ajax")
public class GetFixedBoardList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 변수 선언 및 초기화
        String boardName = CommonValidation.boardNameValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);

        BoardDAO boardDAO = new BoardDAO(boardName);
        // 최종적으로 return할 게시글 리스트(원글, 답글)
        ArrayList<BoardVO> returnList = new ArrayList<BoardVO>();
        JSONArray returnJsonArray = new JSONArray();
        // for문을 돌리기 위한 게시글 리스트
        ArrayList<BoardVO> boardList;
        // replyCnt, boardColorFlag, replyColorFlag
        JSONArray etcInformationJsonArr = new JSONArray();
        // returList, etcInformation, pagination을 한번에 담아서 넘길 JsonObj
        JSONObject totalJsonObj = new JSONObject();

        int replyCnt = 0;
        int replyColorFlag = 1;
        int boardColorFlag = 1;

        //getBoardList
        boardList = boardDAO.getFixedList(sessionUserId, boardName);


        for (int i = 0; i < boardList.size(); i++) {
            replyCnt = boardDAO.getReplyCnt(boardList.get(i).getBoardNo());
            replyColorFlag = boardDAO.getReplyColor(boardList.get(i).getBoardNo());

            boardColorFlag = boardDAO.getBoardColor(boardList.get(i).getBoardNo());

            returnList.add(boardList.get(i));

            JSONObject etcInformationJsonObj = new JSONObject();
            etcInformationJsonObj.put("replyCnt", String.valueOf(replyCnt));
            etcInformationJsonObj.put("boardColorFlag", String.valueOf(boardColorFlag));
            etcInformationJsonObj.put("replyColorFlag", String.valueOf(replyColorFlag));
            etcInformationJsonArr.add(etcInformationJsonObj);
        }

        for(int i=0; i<returnList.size(); i++){
            JSONObject returnJsonObject = new JSONObject();
            returnJsonObject.put("boardReadCount", returnList.get(i).getBoardReadCount());
            returnJsonObject.put("boardTitle", returnList.get(i).getBoardTitle());
            returnJsonObject.put("boardMakeUser", returnList.get(i).getBoardMakeUser());
            returnJsonObject.put("boardMakeDt", returnList.get(i).getBoardMakeDt());
            returnJsonObject.put("boardAuthorize", returnList.get(i).getBoardAuthorize());
            returnJsonObject.put("isReboard", returnList.get(i).getIsReboard());
            returnJsonObject.put("tableName", returnList.get(i).getTableName());
            returnJsonObject.put("boardPassword", returnList.get(i).getBoardPassword());
            returnJsonObject.put("boardNo", returnList.get(i).getBoardNo());
            returnJsonArray.add(returnJsonObject);
        }

        totalJsonObj.put("boardData", returnJsonArray);
        totalJsonObj.put("etcInformation", etcInformationJsonArr);

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(totalJsonObj.toString());
    }
    }
}
