package board;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetBoardList.do")
public class GetBoardList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected  void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String boardName = request.getParameter("boardName");
        HttpSession session = request.getSession();
        ArrayList<BoardVO> returnList = new ArrayList<BoardVO>();
        int replyCnt;
        int replyColorFlag;
        int boardColorFlag;

        String userId = null;
        if (session.getAttribute("userID") != null) {
            userId = (String) session.getAttribute("userID");
        }

        int pageNumber = 1;
        if (request.getParameter("pageNumber") != null) {
            pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        }

        BoardDAO boardDAO = new BoardDAO(boardName);
        ArrayList<BoardVO> boardList;

        if ("myBoard".equals(boardName)) {
            boardList = boardDAO.getMyList(pageNumber, userId);
        } else {
            boardList = boardDAO.getList(pageNumber, userId);
        }

        for (int i = 0; i < boardList.size(); i++) {
            if (boardList.get(i).getIsRebaord() == 1) {
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
                    ArrayList<BoardVO> reboardList = reboardDAO.getReboardList(userId, boardList.get(i).getBoardNo());

                    for (int j = 0; j < reboardList.size(); j++) {

                        if ("myBoard".equals(boardName)) {
                            replyCnt = reboardDAO.getMyReplyCnt(reboardList.get(j).getTableName(), reboardList.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getMyReplyColor(reboardList.get(j).getTableName(), reboardList.get(j).getBoardNo());
                        } else {
                            replyCnt = reboardDAO.getReplyCnt(reboardList.get(j).getBoardNo());
                            replyColorFlag = reboardDAO.getReplyColor(reboardList.get(j).getBoardNo());
                        }
                        boardColorFlag = reboardDAO.getBoardColor(reboardList.get(j).getBoardNo());

                        returnList.add(reboardList.get(j));
                    }
                }
                //댓글갯수, 댓글갯수색깔, 글제목색깔 JSON 만들기
                StringBuffer JSONBuffer = new StringBuffer("");
                String etcInformationJSON;
                JSONBuffer.append("{\"result\":[");

                for(int k=0; k<4; k++){
                    JSONBuffer.append("[{\"value\": \"" + String.valueOf(replyCnt) + "\"}, ");
                    JSONBuffer.append("[{\"value\": \"" + String.valueOf(replyColorFlag) + "\"}, ");
                    JSONBuffer.append("[{\"value\": \"" + String.valueOf(boardColorFlag) + "\"}, ");
                }
                etcInformationJSON = JSONBuffer.toString();

                request.setAttribute("etcInformationJSON", etcInformationJSON);
            }
        }

        request.setAttribute("boardList", returnList);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("board.jsp");
        requestDispatcher.forward(request, response);
    }
}
