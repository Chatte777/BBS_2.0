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
    private String colNo;
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

    public BoardDAO(String boardName) {
        this.boardName = boardName;
        this.tableName = boardName+"_master";
        this.colNo = boardName+"_no";
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
        String SQL = "SELECT " + this.colNo + " FROM "+ this.tableName +" ORDER BY "+ this.colNo +" DESC";
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
        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, tmpNextNo);
            pstmt.setString(2, boardTitle);
            pstmt.setInt(3, 1);
            pstmt.setString(4, boardContent);
            pstmt.setString(5, boardMakeUser);
            pstmt.setString(6, getDate());
            pstmt.setInt(7, 1);
            pstmt.setInt(8, 1);
            pstmt.setInt(9, 1);
            pstmt.setInt(10, 1);
            pstmt.setInt(11, boardAuthorize);

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch(Exception e){
            e.printStackTrace();
        }
        return -1; //Database error
    }


    public ArrayList<BoardVO> getList(int pageNumber, String userId){
        String SQL = "SELECT * from "+ this.tableName
                + " WHERE "+ this.colNo +" < ? "
                + " AND "+ this.colDeleteYn +"=1 "
                + " AND ("+ this.colAuthorize +"= 1 OR ("+ this.colAuthorize +"=2 and "+ this.colMakeUser +"=?))"
                + " ORDER BY "+ this.colNo +" DESC LIMIT 10";
        ArrayList<BoardVO> list = new ArrayList<BoardVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext()-(pageNumber-1)*10);
            pstmt.setString(2, userId);

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

    public boolean nextPage(int pageNumber){
        String SQL = "SELECT * from "+ this.tableName +" WHERE "+ this.colNo +" < ? AND "+ this.colDeleteYn +" = 1";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext()-(pageNumber-1)*10);

            rs = pstmt.executeQuery();

            if (rs.next()){
                return true;
            }
        } catch(Exception e){
            e.printStackTrace();
        }
        return false;
    }

    public BoardVO getBoardVO(int boardNo){
        String SQL = "SELECT * from "+ this.tableName +" WHERE "+ this.colNo +" = ?";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            if (rs.next()){
                BoardVO boardVO = new BoardVO();
                int readCount = rs.getInt(12);

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
                boardVO.setBoardReadCount(readCount);
                readCount++;

                String countSQL = "UPDATE " + this.tableName + " SET " + this.colReadCount + " = " + readCount + " WHERE "+ this.colNo +" = ?";
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
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colTitle +" =?, "+ this.colContent +" =?, "+ this.colAuthorize +" =? WHERE "+ this.colNo +" =?";
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
        String SQL = "UPDATE "+ this.tableName +" SET "+ this.colDeleteYn +" =2 WHERE "+ this.colNo +" = ?";
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
        String SQL = "SELECT COUNT(1) from "+ this.replyTableName +" WHERE "+ this.colNo +" =? and reply_delete_yn=1";

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
        String SQL = "SELECT reply_make_dt from "+ this.replyTableName +" WHERE "+ this.colNo +"=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";

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
}