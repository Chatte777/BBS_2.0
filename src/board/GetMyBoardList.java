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

@WebServlet("/GetMyBoardList.ajax")
public class GetMyBoardList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        int pageNumber = CommonValidation.pageNumberValidation(request);

        BoardDAO boardDAO = new BoardDAO("myBoard");
        ArrayList<BoardVO> myBoardList = boardDAO.getMyList(pageNumber, sessionUserId);

        // boardList Json Array
        JSONArray boardJsonArray = new JSONArray();
        // replyCnt, boardColorFlag, replyColorFlag
        JSONArray etcInformationJsonArray = new JSONArray();
        // isNextPage, isDoubleNextPage, isTripleNextPage, lastPage
        JSONObject paginationJsonObject = new JSONObject();
        // returList, etcInformation, pagination을 한번에 담아서 넘길 JsonObj
        JSONObject totalJsonObj = new JSONObject();

        int replyCnt = 0;
        int replyColorFlag = 1;
        int boardColorFlag = 1;
        int isNextPage = 0;
        int isDoubleNextPage = 0;
        int isTripleNextPage = 0;

        //Pagination
        int lastPage = boardDAO.getMyTotalPageNo(sessionUserId);
        if (boardDAO.isMyNextPage(pageNumber, sessionUserId)) isNextPage = 1;
        if (boardDAO.isMyNextPage(pageNumber + 1, sessionUserId)) isDoubleNextPage = 1;
        if (boardDAO.isMyNextPage(pageNumber + 2, sessionUserId)) isTripleNextPage = 1;
        paginationJsonObject.put("isNextPage", String.valueOf(isNextPage));
        paginationJsonObject.put("isDoubleNextPage", String.valueOf(isDoubleNextPage));
        paginationJsonObject.put("isTripleNextPage", String.valueOf(isTripleNextPage));
        paginationJsonObject.put("lastPage", String.valueOf(lastPage));

        //getBoardList
        myBoardList = boardDAO.getMyList(pageNumber, sessionUserId);

        for (int i = 0; i < myBoardList.size(); i++) {

            replyCnt = boardDAO.getMyReplyCnt(myBoardList.get(i).getTableName(), myBoardList.get(i).getBoardNo());
            replyColorFlag = boardDAO.getMyReplyColor(myBoardList.get(i).getTableName(), myBoardList.get(i).getBoardNo());
            boardColorFlag = boardDAO.getMyBoardColor(myBoardList.get(i).getTableName(), myBoardList.get(i).getBoardNo());

            JSONObject etcInformationJsonObj = new JSONObject();
            etcInformationJsonObj.put("replyCnt", String.valueOf(replyCnt));
            etcInformationJsonObj.put("boardColorFlag", String.valueOf(boardColorFlag));
            etcInformationJsonObj.put("replyColorFlag", String.valueOf(replyColorFlag));
            etcInformationJsonArray.add(etcInformationJsonObj);

            JSONObject boardJsonObject = new JSONObject();
            boardJsonObject.put("boardReadCount", myBoardList.get(i).getBoardReadCount());
            boardJsonObject.put("boardTitle", myBoardList.get(i).getBoardTitle());
            boardJsonObject.put("boardMakeUser", myBoardList.get(i).getBoardMakeUser());
            boardJsonObject.put("boardMakeDt", myBoardList.get(i).getBoardMakeDt());
            boardJsonObject.put("boardAuthorize", myBoardList.get(i).getBoardAuthorize());
            boardJsonObject.put("isReboard", myBoardList.get(i).getIsReboard());
            boardJsonObject.put("tableName", myBoardList.get(i).getTableName());
            boardJsonObject.put("boardPassword", myBoardList.get(i).getBoardPassword());
            boardJsonObject.put("boardNo", myBoardList.get(i).getBoardNo());
            boardJsonArray.add(boardJsonObject);
        }

        totalJsonObj.put("boardData", boardJsonArray);
        totalJsonObj.put("etcInformation", etcInformationJsonArray);
        totalJsonObj.put("pagination", paginationJsonObject);

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(totalJsonObj.toString());
    }
}
