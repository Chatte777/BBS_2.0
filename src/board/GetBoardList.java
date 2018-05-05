package board;

import common.CommonValidation;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetBoardList.ajax")
public class GetBoardList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //변수 선언 및 초기화
        String boardName = CommonValidation.boardNameValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        int pageNumber = CommonValidation.pageNumberValidation(request);

        BoardDAO boardDAO = new BoardDAO(boardName);
        ArrayList<BoardVO> returnList = new ArrayList<BoardVO>();
        ArrayList<BoardVO> boardList;

        JSONArray etcInformationJsonArr = new JSONArray();
        JSONObject paginationJsonObj = new JSONObject();
        JSONObject totalJsonObj = new JSONObject();

        int replyCnt = 0;
        int replyColorFlag = 1;
        int boardColorFlag = 1;
        int isNextPage = 0;
        int isDoubleNextPage = 0;
        int isTripleNextPage = 0;

        //Pagination
        int lastPage = boardDAO.getTotalPageNo(sessionUserId);
        if (boardDAO.isNextPage(pageNumber, sessionUserId)) isNextPage = 1;
        if (boardDAO.isNextPage(pageNumber + 1, sessionUserId)) isDoubleNextPage = 1;
        if (boardDAO.isNextPage(pageNumber + 2, sessionUserId)) isTripleNextPage = 1;
        paginationJsonObj.put("isNextPage", String.valueOf(isNextPage));
        paginationJsonObj.put("isDoubleNextPage", String.valueOf(isDoubleNextPage));
        paginationJsonObj.put("isTripleNextPage", String.valueOf(isTripleNextPage));
        paginationJsonObj.put("lastPage", String.valueOf(lastPage));

        //getBoardList
        if ("myBoard".equals(boardName)) {
            boardList = boardDAO.getMyList(pageNumber, sessionUserId);
        } else {
            boardList = boardDAO.getList(pageNumber, sessionUserId);
        }

        for (int i = 0; i < boardList.size(); i++) {
            if ("myBoard".equals(boardName)) {
                replyCnt = boardDAO.getMyReplyCnt(boardList.get(i).getTableName(), boardList.get(i).getBoardNo());
                replyColorFlag = boardDAO.getMyReplyColor(boardList.get(i).getTableName(), boardList.get(i).getBoardNo());
            } else {
                replyCnt = boardDAO.getReplyCnt(boardList.get(i).getBoardNo());
                replyColorFlag = boardDAO.getReplyColor(boardList.get(i).getBoardNo());
            }
            boardColorFlag = boardDAO.getBoardColor(boardList.get(i).getBoardNo());

            returnList.add(boardList.get(i));

            if (boardList.get(i).getHasReboard() == 2) {
                BoardDAO reboardDAO = new BoardDAO(boardName);
                ArrayList<BoardVO> reboardList = reboardDAO.getReboardList(sessionUserId, boardList.get(i).getBoardNo());

                for (int j = 0; j < reboardList.size(); j++) {

                    if ("myBoard".equals(boardName)) {
                        replyCnt = reboardDAO.getMyReplyCnt(reboardList.get(j).getTableName(), reboardList.get(j).getBoardNo());
                        replyColorFlag = reboardDAO.getMyReplyColor(reboardList.get(j).getTableName(), reboardList.get(j).getBoardNo());
                    } else {
                        replyCnt = reboardDAO.getReplyCnt(reboardList.get(j).getBoardNo());
                        replyColorFlag = reboardDAO.getReplyColor(reboardList.get(j).getBoardNo());
                    }
                    boardColorFlag = reboardDAO.getBoardColor(reboardList.get(j).getBoardNo());

                    JSONObject etcInformationJsonObj = new JSONObject();
                    etcInformationJsonObj.put("replyCnt", String.valueOf(replyCnt));
                    etcInformationJsonObj.put("boardColorFlag", String.valueOf(boardColorFlag));
                    etcInformationJsonObj.put("replyColorFlag", String.valueOf(replyColorFlag));
                    etcInformationJsonArr.add(etcInformationJsonObj);

                    returnList.add(reboardList.get(j));
                }
            }

            JSONObject etcInformationJsonObj = new JSONObject();
            etcInformationJsonObj.put("replyCnt", String.valueOf(replyCnt));
            etcInformationJsonObj.put("boardColorFlag", String.valueOf(boardColorFlag));
            etcInformationJsonObj.put("replyColorFlag", String.valueOf(replyColorFlag));
            etcInformationJsonArr.add(etcInformationJsonObj);

        }

        /*
        request.setAttribute("etcInformationJson", etcInformationJsonArr);
        request.setAttribute("boardList", returnList);
        request.setAttribute("paginationJson", paginationJsonObj);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("board.jsp");
        requestDispatcher.forward(request, response);
        */

        totalJsonObj.put("etcInformationJson", etcInformationJsonArr);
        totalJsonObj.put("boardList", returnList);
        totalJsonObj.put("paginationJson", paginationJsonObj);

        response.setContentType("text/html;charset=UTF-8");
        response.getWriter().write(totalJsonObj.toString());
    }
}
