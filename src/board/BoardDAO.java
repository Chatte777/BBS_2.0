package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import dbConn.*;
import alarmMaster.*;
import errorMaster.*;
import common.*;

public class BoardDAO {
    private Connection conn;
    private DbConn dbConn=new DbConn();
    private ResultSet rs;
    private CommonDAO commonDAO = new CommonDAO();
    
    private String boardName;
    private String tableName;
    private String colBoardNo;
    private String colTitle;
    private String colContent;
    private String colMakeUser;
    private String colMakeDt;
    private String colDeleteYn;
    private String colAuthorize;
    private String colReadCount;
    private String colBoardPassword;

    private String replyTableName;
    private String reReplyTableName;

    private int boardCountPerPage=15;
    private int _boardNo = 0;

    public BoardDAO(String boardName) {
        this.boardName = boardName;
        this.tableName = boardName+"_master";
        this.colBoardNo = boardName+"_no";
        this.colTitle = boardName+"_title";
        this.colContent = boardName+"_content";
        this.colMakeUser = boardName+"_make_user";
        this.colMakeDt = boardName+"_make_dt";
        this.colDeleteYn = boardName+"_delete_yn";
        this.colAuthorize = boardName+"_authorize";
        this.colReadCount = boardName+"_read_count";
        this.replyTableName = boardName+"_reply";
        this.reReplyTableName = boardName+"_re_reply";
        this.colBoardPassword = boardName+"_password";

        conn=dbConn.getDbConnection();
    }



    public int getNext(){
        String SQL = "SELECT " + this.colBoardNo + " FROM "+ this.tableName +" ORDER BY "+ this.colBoardNo +" DESC";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if(rs.next()){
                return rs.getInt(1)+1;
            }
            return 1; // 첫 게시물일 경우.
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("", "", "", "", "boardDAO.getNext", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1; //Database error
    }

    public BoardVO setBoardVO(BoardVO boardVO, ResultSet rs){
        try {
            boardVO.setTableName(rs.getString(1));
            boardVO.setBoardNo(rs.getInt(2));
            boardVO.setBoardTitle(rs.getString(3));
            boardVO.setBoardTm(rs.getInt(4));
            boardVO.setBoardContent(rs.getString(5));
            boardVO.setBoardMakeUser(rs.getString(6));
            boardVO.setBoardMakeDt(rs.getString(7));
            boardVO.setBoardReplyCnt(rs.getInt(8));
            boardVO.setBoardLikeCnt(rs.getInt(9));
            boardVO.setBoardDislikeCnt(rs.getInt(10));
            boardVO.setBoardDeleteYn(rs.getInt(11));
            boardVO.setBoardAuthorize(rs.getInt(12));
            boardVO.setBoardReadCount(rs.getInt(13));
            boardVO.setIsReboard(rs.getInt(14));
            boardVO.setHasReboard(rs.getInt(15));
            boardVO.setOrgBoardNo(rs.getInt(16));
            boardVO.setBoardPassword(rs.getString(17));
            boardVO.setBoardPriority(rs.getInt(18));
        }catch (Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardVO:"+boardVO, "rs:"+rs, "", "", "boardDAO.setBoardVO", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return boardVO;
    }


    public int write(String boardTitle, String boardMakeUser, String boardContent, int boardAuthorize, int boardNo, String boardPassword){
        CommonDAO commonDAO = new CommonDAO();
        CommonDAO.writeContentLog("boardWrite", boardContent);

        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();
        if(boardNo==0) this._boardNo = tmpNextNo;

        if("".equals(boardTitle)) boardTitle = "<span style=\"color:lightgray;\">제목을 작성하지 않은 글입니다._"+boardContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "").substring(0,20)+"</span>";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,this.boardName); //tableName
            pstmt.setInt(2, tmpNextNo); //boardNo
            pstmt.setString(3, boardTitle);  //boardTitle
            pstmt.setInt(4, 1);  //boardTm
            pstmt.setString(5, boardContent);  //boardContent
            pstmt.setString(6, boardMakeUser);  //boardMakeUser
            pstmt.setString(7, commonDAO.getDate());  //boardMakeDt
            pstmt.setInt(8, 1);  //boardReplyCnt
            pstmt.setInt(9, 1);  //boardLikeCnt
            pstmt.setInt(10, 1);  //boardDislikeCnt
            pstmt.setInt(11, 1);  //boardDeleteYn
            pstmt.setInt(12, boardAuthorize);  //boardAuthorize
            pstmt.setInt(13, 0);  //boardReadCount
            if(boardNo==0)pstmt.setInt(14,1);  //boardNo가 0이면 원본글임. isReboard
            else pstmt.setInt(14, 2);
            pstmt.setInt(15, 1);  //hasReboard
            if(boardNo==0)pstmt.setInt(16,0);  //orgBoardNo
            else pstmt.setInt(16, boardNo);
            pstmt.setString(17, boardPassword);
            pstmt.setInt(18, 0);

            if(boardNo!=0) {
                boardContent = boardContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(boardContent.length()>70) boardContent=boardContent.substring(0,70);

                AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
                alarmMasterDAO.writeReboardAlarm(this.boardName, boardNo, tmpNextNo, boardContent);

                hasReboardUpdate(boardNo);
            }
            pstmt.executeUpdate();

            return tmpNextNo;
        } catch(Exception e){
            CommonDAO.writeContentLog("boardWrite", boardContent);

            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardTitle:"+boardTitle, "boardAuthorize:"+boardAuthorize, "boardNo:"+boardNo, "boardContent:"+boardContent, "boardDAO.write", e.getMessage().toString(), boardMakeUser);
            e.printStackTrace();
        }
        return -1; //Database error
    }

    //count가 아니라 index인 이유 : 전체공개 or (비공개&&내가쓴 글)등 조건에 맞는 게시글들에 대해서만 counting해야하므로 실제 갯수를 나타내는 count보다는 참조주소값을 의미하는 index로 네이밍하였음.
    public int getTotalBoardIndex(String makeUser){
        String SQL = "SELECT COUNT(1) FROM " + this.tableName
                + " WHERE " + this.colDeleteYn + " = 1"
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))";

        return commonDAO.getTotalBoardIndex(SQL, makeUser);
    }

    public ArrayList<BoardVO> getList(int pageNumber, String makeUser){
        /*
        //전체 개시글 인덱스(갯수)
        int totalBoardIndex=getTotalBoardIndex(makeUser);
        */

        /*
        //전체 페이지 갯수(전체 게시글 수가 페이지당 게시글 수로 나누어떨어지지 않으면 나눈 몫에다가 +1
        int totalPageNo;
        if((totalBoardIndex%boardCountPerPage)==0) {totalPageNo = totalBoardIndex/boardCountPerPage;}
        else {totalPageNo = (totalBoardIndex/boardCountPerPage)+1;}
        */

        //해당 페이지에 불러올 첫 게시글의 index (boardNo가 아니라 query결과의 rowNum)
        //0부터 시작하여 페이지 넘어갈 때 마다 페이지당 게시글 갯수만큼 증가한다.
        int startBoardIndex = 0+((pageNumber-1)*boardCountPerPage);

        String SQL = "SELECT * from "+ this.tableName
                + " WHERE " + this.colDeleteYn +"=1 "
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))" +
                "AND is_reboard = 1"
                + " ORDER BY "+ this.colBoardNo +"  DESC LIMIT ?,?";
        ArrayList<BoardVO> list = new ArrayList<BoardVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);
            pstmt.setInt(2, startBoardIndex);
            pstmt.setInt(3, boardCountPerPage);

            rs = pstmt.executeQuery();

            while (rs.next()){
                BoardVO boardVO = new BoardVO();
                setBoardVO(boardVO, rs);

                list.add(boardVO);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("makeUser:"+makeUser, "pageNumber:"+pageNumber, "", "", "boardDAO.GetBoardList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return list; //Database error
    }

    public int getTotalPageNo(String makeUser){
        int totalBoardIndex=getTotalBoardIndex(makeUser);

        //전체 페이지 갯수(전체 게시글 수가 페이지당 게시글 수로 나누어떨어지지 않으면 나눈 몫에다가 +1
        int totalPageNo;
        if((totalBoardIndex%boardCountPerPage)==0) {totalPageNo = totalBoardIndex/boardCountPerPage;}
        else {totalPageNo = (totalBoardIndex/boardCountPerPage)+1;}

        return totalPageNo;
    }

    public boolean isNextPage(int pageNumber, String makeUser){
        int totalPageNo=getTotalPageNo(makeUser);

        if(pageNumber<totalPageNo) return true;
        else return false;
    }

    public BoardVO getBoardVO(int boardNo){
        String SQL = "SELECT * from "+ this.tableName +" WHERE "+ this.colBoardNo +" = ?";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()){
                BoardVO boardVO = new BoardVO();
                int readCount = rs.getInt(13);
                setBoardVO(boardVO, rs);

                boardVO.setBoardReadCount(readCount);
                readCount++;

                String countSQL = "UPDATE " + this.tableName + " SET " + this.colReadCount + " = " + readCount + " WHERE "+ this.colBoardNo +" = ?";
                try{
                    PreparedStatement innerPstmt = conn.prepareStatement(countSQL);
                    innerPstmt.setInt(1, boardNo);

                    innerPstmt.executeUpdate();
                }catch(Exception e){
                    e.printStackTrace();
                }
                return boardVO;
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "boardDAO.getBoardNo", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return null;
    }

    public int update(int boardNo, String boardTitle, String boardContent, int boardAuthorize, String boardPassword){
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colTitle +" =?, "+ this.colContent +" =?, "+ this.colAuthorize +" =?, "+ this.colBoardPassword + "= ? WHERE "+ this.colBoardNo +" =?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardTitle);
            pstmt.setString(2, boardContent);
            pstmt.setInt(3, boardAuthorize);
            pstmt.setString(4, boardPassword);
            pstmt.setInt(5, boardNo);


            pstmt.executeUpdate();
            return boardNo;

        } catch(Exception e){
            CommonDAO.writeContentLog("boardUpdate", boardContent);

            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "boardTitle"+boardTitle, "boardAuthorize:"+boardAuthorize, "boardContent:"+boardContent, "boardDAO.getBoardNo", e.getMessage().toString(), "boardDAO.update");
            e.printStackTrace();
        }
        return -1; //Database error
    }

    public int delete(int boardNo){
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colDeleteYn +" =2 WHERE "+ this.colBoardNo +" = "+ boardNo;
        return commonDAO.updateYn(SQL); //Database error
    }

    public int getReplyCnt(int boardNo) {
        String SQL = "SELECT COUNT(1) from "+ this.replyTableName +" WHERE "+ this.colBoardNo +" =? and reply_delete_yn=1";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int allReplyCnt = rs.getInt(1);
                allReplyCnt = allReplyCnt + getReReplyCnt(boardNo);

                return allReplyCnt;
            }
        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "boardDAO.getReplyCnt", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1;
    }

    public int getReReplyCnt(int boardNo) {
        String SQL = "SELECT COUNT(1) from "+ this.reReplyTableName +" WHERE "+ this.colBoardNo +" =? and re_reply_delete_yn=1";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int replyCnt = rs.getInt(1);

                return replyCnt;
            }
        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "boardDAO.getReReplyCnt", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1;
    }

    public int getReplyColor(int boardNo) {
        String SQL = "SELECT reply_make_dt from "+ this.replyTableName +" WHERE "+ this.colBoardNo +"=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";
        return getReplyColorFlag(SQL, boardNo);
    }

    public int getBoardColor(int boardNo) {
        String SQL = "SELECT "+ this.colMakeDt +" from "+ this.tableName +" WHERE "+ this.colBoardNo +"=? and "+ this.colDeleteYn +" =1 ORDER BY "+ this.colBoardNo +" DESC LIMIT 1";
        return getBoardColorFlag(SQL, boardNo);
    }

    public ArrayList<BoardVO> getReboardList(String makeUser, int boardNo){
        String SQL = "SELECT * from "+ this.tableName
                + " WHERE " + this.colDeleteYn +"=1 "
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))"
                + " AND is_reboard = 2 "
                + " AND org_board_no = ?";

        ArrayList<BoardVO> list = new ArrayList<BoardVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);
            pstmt.setInt(2, boardNo);

            rs = pstmt.executeQuery();

            while (rs.next()){
                BoardVO boardVO = new BoardVO();
                setBoardVO(boardVO, rs);

                list.add(boardVO);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "makeUser:"+makeUser, "", "", "boardDAO.getReboardList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return list; //Database error
    }

    public void hasReboardUpdate(int boardNo){
        String SQL = "UPDATE " + this.tableName + " SET has_reboard = 2 WHERE " + this.colBoardNo + "=?";
        ArrayList<BoardVO> list = new ArrayList<BoardVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            pstmt.executeUpdate();
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "boardDAO.hasReboardUpdate", e.getMessage().toString(), "");
            e.printStackTrace();
        }
    }


    //////////
    ////////// MyBoard 페이징처리
    //////////
    public int getMyTotalBoardIndex(String makeUser){
        String SQL = "SELECT count(1) FROM notify_master"
                + " WHERE notify_make_user=?" +
                " UNION" +
                " SELECT count(1) FROM mountain_master" +
                " WHERE mountain_make_user=?" +
                " UNION" +
                " SELECT count(1) FROM thread_master" +
                " WHERE thread_make_user=?";

        try{
            //조건에 맞는 전체 게시글 갯수
            int totalBoardCount =1;

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);
            pstmt.setString(2, makeUser);
            pstmt.setString(3, makeUser);

            rs = pstmt.executeQuery();

            while(rs.next()){
                totalBoardCount += rs.getInt(1);
            }
            return totalBoardCount;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("makeUser:"+makeUser, "", "", "", "boardDAO.getMyTotalBoardIndex", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1;
    }

    public int getMyTotalPageNo(String makeUser){
        int totalBoardIndex=getMyTotalBoardIndex(makeUser);

        //전체 페이지 갯수(전체 게시글 수가 페이지당 게시글 수로 나누어떨어지지 않으면 나눈 몫에다가 +1
        int totalPageNo;
        if((totalBoardIndex%boardCountPerPage)==0) {totalPageNo = totalBoardIndex/boardCountPerPage;}
        else {totalPageNo = (totalBoardIndex/boardCountPerPage)+1;}

        return totalPageNo;
    }

    public boolean isMyNextPage(int pageNumber, String makeUser){
        int totalPageNo=getMyTotalPageNo(makeUser);

        if(pageNumber<totalPageNo) return true;
        else return false;
    }

    public int getMyReplyColor(String tableName, int boardNo) {
        String SQL = "SELECT reply_make_dt from "+ tableName +"_reply WHERE "+ tableName + "_no=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";
        return getReplyColorFlag(SQL, boardNo);
    }

    public ArrayList<BoardVO> getMyList(int pageNumber, String makeUser){
               //해당 페이지에 불러올 첫 게시글의 index (boardNo가 아니라 query결과의 rowNum)
        //0부터 시작하여 페이지 넘어갈 때 마다 페이지당 게시글 갯수만큼 증가한다.
        int startBoardIndex = 0+((pageNumber-1)*boardCountPerPage);

        String SQL = "SELECT *, notify_make_dt as make_dt FROM notify_master"
                + " WHERE notify_make_user=?" +
                " AND notify_delete_yn = 1" +
                " UNION" +
                " SELECT *, mountain_make_dt as make_dt FROM mountain_master" +
                " WHERE mountain_make_user=?" +
                " AND mountain_delete_yn = 1" +
                " UNION" +
                " SELECT *, thread_make_dt as make_dt FROM thread_master" +
                " WHERE thread_make_user=?" +
                " AND thread_delete_yn = 1"
                + " ORDER BY make_dt DESC LIMIT ?,?";
        ArrayList<BoardVO> list = new ArrayList<BoardVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);
            pstmt.setString(2, makeUser);
            pstmt.setString(3, makeUser);
            pstmt.setInt(4, startBoardIndex);
            pstmt.setInt(5, boardCountPerPage);

            rs = pstmt.executeQuery();

            while (rs.next()){
                BoardVO boardVO = new BoardVO();
                setBoardVO(boardVO, rs);

                list.add(boardVO);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("pageNumber:"+pageNumber, "makeUser:"+makeUser, "", "", "boardDAO.getMyList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return list; //Database error
    }

    public int getMyReplyCnt(String tableName, int boardNo) {
        String SQL = "SELECT COUNT(1) from "+ tableName +"_reply WHERE "+ tableName + "_no =? and reply_delete_yn=1";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int replyCnt = rs.getInt(1);

                return replyCnt;
            }
        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "tableName:"+tableName, "", "", "boardDAO.getBoardNo", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1;
    }

    public int getMyBoardColor(String tableName, int boardNo) {
        String SQL = "SELECT "+ tableName +"_make_dt from "+ tableName +"_master WHERE "+ tableName + "_no =? and "+ tableName + "_delete_yn =1 ORDER BY "+ tableName +"_no DESC LIMIT 1";
        return getBoardColorFlag(SQL, boardNo);
    }

    //////////////////
    ///////// Fixed Board
    //////////////////
    public void writeFixedBoard(String boardMakeUser, String tableName, int boardNo){
        String SQL = "INSERT INTO fixed_board VALUES(?,?,?,1) ON DUPLICATE KEY UPDATE fixed_yn = 1 ";
        if(boardNo==0) boardNo = this._boardNo;

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardMakeUser);
            pstmt.setString(2, tableName);
            pstmt.setInt(3, boardNo);

            pstmt.executeUpdate();
            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("tableName:"+tableName, "boardNo:"+boardNo, "", "", "boardDAO.writeFixedBoard", e.getMessage().toString(), boardMakeUser);
            e.printStackTrace();
        }
        return;
    }

    public void deleteFixedBoard(String boardMakeUser, String tableName, int boardNo){
        String SQL = "UPDATE fixed_board SET fixed_yn=2 WHERE board_make_user=? AND table_name=? AND board_no=?";
        if(boardNo==0) boardNo = this._boardNo;

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardMakeUser);
            pstmt.setString(2, tableName);
            pstmt.setInt(3, boardNo);

            pstmt.executeUpdate();
            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("tableName:"+tableName, "boardNo:"+boardNo, "", "", "boardDAO.deleteFixedBoard", e.getMessage().toString(), boardMakeUser);
            e.printStackTrace();
        }
        return;
    }

    public int getFixedYn(String boardMakeUser, String tableName, int boardNo){
        String SQL = "SELECT fixed_yn FROM fixed_board WHERE board_make_user=? AND table_name=? AND board_no=?";
        if(boardNo==0) boardNo = this._boardNo;
        int result=0;


        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardMakeUser);
            pstmt.setString(2, tableName);
            pstmt.setInt(3, boardNo);

            rs = pstmt.executeQuery();

            while (rs.next()){
                result = rs.getInt(1);
                return result;
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("tableName:"+tableName, "boardNo:"+boardNo, "", "", "boardDAO.getFixedYn", e.getMessage().toString(), boardMakeUser);
            e.printStackTrace();
        }
        return result;
    }

    public ArrayList<BoardVO> getFixedList(String boardMakeUser, String tableName){
        String SQL = "SELECT * " +
                "FROM "+ tableName + "_master a " +
                "INNER JOIN fixed_board b " +
                "ON a." + tableName + "_make_user = b.board_make_user " +
                "AND a.table_name = b.table_name " +
                "AND a." + tableName + "_no = b.board_no " +
                "WHERE " + tableName + "_make_user = ? " +
                "AND b.fixed_yn = 1 " +
                "AND a." + tableName + "_delete_yn = 1";
        ArrayList<BoardVO> list = new ArrayList<>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardMakeUser);

            rs = pstmt.executeQuery();

            while (rs.next()){
                BoardVO boardVO = new BoardVO();
                setBoardVO(boardVO, rs);

                list.add(boardVO);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("tableName:"+tableName, "", "", "", "boardDAO.getFixedList", e.getMessage().toString(), boardMakeUser);
            e.printStackTrace();
        }
        return list; //Database error
    }

    ////////////////////
    ////////// 공통모듈
    ///////////////////

    private int getReplyColorFlag(String SQL, int boardNo) {
        int gapFlag=0;

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                String replyTime = rs.getString(1);
                Date replyTimeDt = formatter.parse(replyTime);

                Date nowTimeDt = new Date();

                long gap = (nowTimeDt.getTime() - replyTimeDt.getTime()) / 1000;

                long hourGap = gap / 60 / 60;
                long reminder = ((long) (gap / 60) % 60);
                long minuteGap = reminder;
                long secondGap = gap % 60;

                if (hourGap < 1) {
                    if (minuteGap < 1) {
                        if (secondGap <= 30) gapFlag = 1; // 30초-보라색
                        else gapFlag = 2;
                    } else if (minuteGap <= 3) gapFlag = 2; // 3분-빨간색
                    else if (minuteGap <= 10) gapFlag = 3; // 10분-주황색
                    else if (minuteGap <= 30) gapFlag = 4; // 30분-초록색
                    else gapFlag = 5;
                } else if (hourGap <= 2) gapFlag = 5; // 2시간-파란색
                else gapFlag = 6; // 검정색
            }
        }catch (Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("SQL: "+SQL, "boardNo: "+boardNo, "", "", "boardDAO.getReplyColorFlag", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return gapFlag;
    }

    private int getBoardColorFlag(String SQL, int boardNo){
        int gapFlag = 0;

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

                String boardMakeTime = rs.getString(1);
                Date boardMakeTimeDt = formatter.parse(boardMakeTime);

                Date nowTimeDt = new Date();

                long gap = (nowTimeDt.getTime() - boardMakeTimeDt.getTime()) / 1000;

                long hourGap = gap / 60 / 60;
                //long reminder = ((long) (gap / 60) % 60);

                if (hourGap < 2) {gapFlag=1;} // 2시간-빨간색
                else if (hourGap < 10) gapFlag = 2; // 10시간-초록색
                else if (hourGap < 24) gapFlag = 3; // 24시간-파란색
                else gapFlag = 4; // 검정색

                return gapFlag;
            }
        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "boardDAO.getBoardColor", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return gapFlag;
    }
}