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
import java.io.PrintWriter;

@WebServlet("/GetBoard.do")
public class GetBoard extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected  void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 서버에서는 특수한 경우에 발생할 수 있는 nullpointException에 대한 처리만 하였음.
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo = CommonValidation.boardNoValidation(request);
        int viewFlag=CommonValidation.viewFlagValidation(request); //1: page redirect, 2: JSON Return
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);

        if (boardNo == 0) {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('서버로부터의 알림 : 유효하지 않은 글입니다.')");
            script.println("location.href = 'board.jsp?boardName=" + boardName + "'");
            script.println("</script>");
        }
        BoardDAO boardDAO = new BoardDAO(boardName);
        BoardVO boardVO = boardDAO.getBoardVO(boardNo);

        if(viewFlag==1){
            request.setAttribute("boardVO", boardVO);

            RequestDispatcher requestDispatcher = request.getRequestDispatcher("boardView.jsp");
            requestDispatcher.forward(request, response);
        } else if(viewFlag==2) {
            JSONObject boardVOJson = new JSONObject();
            boardVOJson.put("tableName", boardVO.getTableName());
            boardVOJson.put("boardNo", boardVO.getBoardNo());
            boardVOJson.put("boardTitle", boardVO.getBoardTitle());
            boardVOJson.put("boardTm", boardVO.getBoardTm());
            boardVOJson.put("boardContent", boardVO.getBoardContent());
            boardVOJson.put("boardMakeUser", boardVO.getBoardMakeUser());
            boardVOJson.put("boardMakeDt", boardVO.getBoardMakeDt());
            boardVOJson.put("boardReplyCnt", boardVO.getBoardReplyCnt());
            boardVOJson.put("boardLikeCnt", boardVO.getBoardLikeCnt());
            boardVOJson.put("boardDislkeCnt", boardVO.getBoardDislikeCnt());
            boardVOJson.put("boardDeleteYn", boardVO.getBoardDeleteYn());
            boardVOJson.put("boardAuthorize", boardVO.getBoardAuthorize());
            boardVOJson.put("boardReadCount", boardVO.getBoardReadCount());
            boardVOJson.put("isReboard", boardVO.getIsReboard());
            boardVOJson.put("hasReboard", boardVO.getHasReboard());
            boardVOJson.put("orgBoardNo", boardVO.getOrgBoardNo());
            boardVOJson.put("boardPassword", boardVO.getBoardPassword());
            boardVOJson.put("boardPriority", boardVO.getBoardPriority());
            boardVOJson.put("fixedYn", boardDAO.getFixedYn(sessionUserId, boardName, boardNo));

            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write(boardVOJson.toString());
        }
    }
}
