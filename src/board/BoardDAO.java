package board;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class BoardDAO {

    private Connection conn;
    private ResultSet rs;
    
    private String boardName;
    private String tableName;
    private String colBoardNo;
    private String colTitle;
    private String colTm;
    private String colContent;
    private String colMakeUser;
    private String colMakeDt;
    private String colReplyCnt;
    private String colLikeCnt;
    private String colDisLikeCnt;
    private String colDeleteYn;
    private String colAuthorize;
    private String colReadCount;

    private String replyTableName;

    private int boardCountPerPage=15;

    public BoardDAO(String boardName) {
        this.boardName = boardName;
        this.tableName = boardName+"_master";
        this.colBoardNo = boardName+"_no";
        this.colTitle = boardName+"_title";
        this.colTm = boardName+"_tm";
        this.colContent = boardName+"_content";
        this.colMakeUser = boardName+"_make_user";
        this.colMakeDt = boardName+"_make_dt";
        this.colReplyCnt = boardName+"_reply_cnt";
        this.colLikeCnt = boardName+"_like_cnt";
        this.colDisLikeCnt = boardName+"_dislike_cnt";
        this.colDeleteYn = boardName+"_delete_yn";
        this.colAuthorize = boardName+"_authorize";
        this.colReadCount = boardName+"_read_count";
        this.replyTableName = boardName+"_reply";

        try {
            String ipStr;
            InetAddress ip = InetAddress.getLocalHost();
            if(ip.toString().equals("KoreaUniv-PC/192.168.219.90")) ipStr="localhost";
            else ipStr = "122.42.239.89";

            String dbURL = "jdbc:mysql://" +ipStr+ ":3306/BBS";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    public String getDate(){
        String SQL = "select now()";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if(rs.next()){
                return rs.getString(1);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return ""; //Database error
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
            e.printStackTrace();
        }
        return -1; //Database error
    }

    public int write(String boardTitle, String boardMakeUser, String boardContent, int boardAuthorize){
        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1,this.tableName);
            pstmt.setInt(2, tmpNextNo);
            pstmt.setString(3, boardTitle);
            pstmt.setInt(4, 1);
            pstmt.setString(5, boardContent);
            pstmt.setString(6, boardMakeUser);
            pstmt.setString(7, getDate());
            pstmt.setInt(8, 1);
            pstmt.setInt(9, 1);
            pstmt.setInt(10, 1);
            pstmt.setInt(11, 1);
            pstmt.setInt(12, boardAuthorize);
            pstmt.setInt(13, 0);

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch(Exception e){
            e.printStackTrace();
        }
        return -1; //Database error
    }

    //count가 아니라 index인 이유 : 전체공개 or (비공개&&내가쓴 글)등 조건에 맞는 게시글들에 대해서만 counting해야하므로 실제 갯수를 나타내는 count보다는 참조주소값을 의미하는 index로 네이밍하였음.
    public int getTotalBoardIndex(String makeUser){
        String SQL = "SELECT COUNT(1) FROM " + this.tableName
                + " WHERE " + this.colDeleteYn + " = 1"
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))";

        try{
            //조건에 맞는 전체 게시글 갯수
            int totalBoardCount =1;

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);

            rs = pstmt.executeQuery();

            while(rs.next()){
                totalBoardCount = rs.getInt(1);
            }
            return totalBoardCount;
        } catch(Exception e){
            e.printStackTrace();
        }
        return -1;
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
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))"
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

                list.add(boardVO);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list; //Database error
    }

    public boolean isNextPage(int pageNumber, String makeUser){
        int totalBoardIndex=getTotalBoardIndex(makeUser);

        //전체 페이지 갯수(전체 게시글 수가 페이지당 게시글 수로 나누어떨어지지 않으면 나눈 몫에다가 +1
        int totalPageNo;
        if((totalBoardIndex%boardCountPerPage)==0) {totalPageNo = totalBoardIndex/boardCountPerPage;}
        else {totalPageNo = (totalBoardIndex/boardCountPerPage)+1;}

        //변수로 받은 pageNumber가 totalPageNumber보다 작으면 다음 페이지가 있다.(true)
        //같아질 때 부터(같거나 크면) 다음 페이지가 없다.(false)
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
                int readCount = rs.getInt(12);

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
            e.printStackTrace();
        }
        return null;
    }

    public int update(int boardNo, String boardTitle, String boardContent, int boardAuthorize){
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colTitle +" =?, "+ this.colContent +" =?, "+ this.colAuthorize +" =? WHERE "+ this.colBoardNo +" =?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardTitle);
            pstmt.setString(2, boardContent);
            pstmt.setInt(3, boardAuthorize);
            pstmt.setInt(4, boardNo);

            pstmt.executeUpdate();
            return boardNo;

        } catch(Exception e){
            e.printStackTrace();
        }
        return -1; //Database error
    }

    public int delete(int boardNo){
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colDeleteYn +" =2 WHERE "+ this.colBoardNo +" = ?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            return pstmt.executeUpdate();
        } catch(Exception e){
            e.printStackTrace();
        }
        return -1; //Database error
    }

    public int getReplyCnt(int boardNo) {
        String SQL = "SELECT COUNT(1) from "+ this.replyTableName +" WHERE "+ this.colBoardNo +" =? and reply_delete_yn=1";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int replyCnt = rs.getInt(1);

                return replyCnt;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int getReplyColor(int boardNo) {
        String SQL = "SELECT reply_make_dt from "+ this.replyTableName +" WHERE "+ this.colBoardNo +"=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";

        try {
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

                int gapFlag = 0;

                /*
                if (hourGap < 1) {
                    if (minuteGap < 1) {
                        if (secondGap <= 30) gapFlag = 1; // 30초-보라색
                        else gapFlag = 2;
                    } else if (minuteGap <= 3)  gapFlag = 2; // 3분-빨간색
                    else if (minuteGap <= 10) gapFlag = 3; // 10분-주황색
                    else if (minuteGap <= 30) gapFlag = 4; // 30분-초록색
                    else gapFlag = 5;
                } else if (hourGap <= 2) gapFlag = 5; // 2시간-파란색
                else gapFlag = 6; // 검정색
                */

                if (hourGap < 1) {
                    if (minuteGap < 1) {
                        if (secondGap <= 30) gapFlag = 1; // 30초-보라색
                        else gapFlag = 2;
                    } else if (minuteGap <= 3)  gapFlag = 2; // 3분-빨간색
                    else if (minuteGap <= 10) gapFlag = 3; // 10분-주황색
                    else if (minuteGap <= 30) gapFlag = 4; // 30분-초록색
                    else gapFlag = 5;
                } else if (hourGap <= 2) gapFlag = 5; // 2시간-파란색
                else gapFlag = 6; // 검정색

                return gapFlag;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int getBoardColor(int boardNo) {
        String SQL = "SELECT "+ this.colMakeDt +" from "+ this.tableName +" WHERE "+ this.colBoardNo +"=? and "+ this.colDeleteYn +" =1 ORDER BY "+ this.colBoardNo +" DESC LIMIT 1";

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
                long reminder = ((long) (gap / 60) % 60);
                long minuteGap = reminder;
                long secondGap = gap % 60;

                int gapFlag = 0;

                if (hourGap < 2) {gapFlag=1;} // 2시간-빨간색
                else if (hourGap < 10) gapFlag = 2; // 10시간-초록색
                else if (hourGap < 24) gapFlag = 3; // 24시간-파란색
                else gapFlag = 4; // 검정색

                return gapFlag;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
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
                boardVO.setBoardNo(rs.getInt(1));
                boardVO.setBoardTitle(rs.getString(2));
                boardVO.setBoardTm(rs.getInt(3));
                boardVO.setBoardContent(rs.getString(4));
                boardVO.setBoardMakeUser(rs.getString(5));
                boardVO.setBoardMakeDt(rs.getString(6));
                boardVO.setBoardReplyCnt(rs.getInt(7));
                boardVO.setBoardLikeCnt(rs.getInt(8));
                boardVO.setBoardDislikeCnt(rs.getInt(9));
                boardVO.setBoardDeleteYn(rs.getInt(10));
                boardVO.setBoardAuthorize(rs.getInt(11));
                boardVO.setBoardReadCount(rs.getInt(12));

                list.add(boardVO);
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return list; //Database error
    }
}