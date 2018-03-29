package reReply;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dbConn.*;

public class ReReplyDAO {

    private Connection conn;
    private DbConn dbConn = new DbConn();
    private ResultSet rs;
    private String tableName;
    private String colBoardNo;
    private String colReplyNo;
    private String colReReplyNo;

    public ReReplyDAO(String boardName) {
        this.tableName = boardName+"_re_reply";
        this.colBoardNo = boardName+"_no";

        conn = dbConn.getDbConnection();
    }

    public String getDate() {
        String SQL = "select now()";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getString(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return ""; // Database error
    }

    public int getNext(int boardNo, int replyNo) {
        String SQL = "SELECT count(1) FROM "+ this.tableName +" WHERE "+ this.colBoardNo +" = ? and reply_no=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1; // Database오류
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int write(int boardNo, int replyNo, String replyMakeUser, String replyContent) {
        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            pstmt.setInt(3, getNext(boardNo, replyNo));
            pstmt.setString(4, replyContent);
            pstmt.setString(5, replyMakeUser);
            pstmt.setString(6, getDate());
            pstmt.setInt(7, 1);
            pstmt.setInt(8, 1);
            pstmt.setInt(9, 1);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public ArrayList<ReReplyVO> getList(int boardNo, int replyNo) {
        String innerSQL = "SELECT * from "+ this.tableName +" WHERE "+ this.colBoardNo +" =? and reply_no=? and re_reply_delete_yn=1";
        ArrayList<ReReplyVO> innerList = new ArrayList<ReReplyVO>();

        try {
            PreparedStatement innerPstmt = conn.prepareStatement(innerSQL);
            innerPstmt.setInt(1, boardNo);
            innerPstmt.setInt(2, replyNo);

            ResultSet innerRs = innerPstmt.executeQuery();

            while (innerRs.next()) {
                ReReplyVO reReplyVO = new ReReplyVO();
                reReplyVO.setBoardNo(innerRs.getInt(1));
                reReplyVO.setReplyNo(innerRs.getInt(2));
                reReplyVO.setReReplyNo(innerRs.getInt(3));
                reReplyVO.setReReplyContent(innerRs.getString(4));
                reReplyVO.setReReplyMakeUser(innerRs.getString(5));
                reReplyVO.setReReplyMakeDt(innerRs.getString(6));
                reReplyVO.setReReplyLikeCnt(innerRs.getInt(7));
                reReplyVO.setReReplyDislikeCnt(innerRs.getInt(8));
                reReplyVO.setReReplyDeleteYn(innerRs.getInt(9));
                innerList.add(reReplyVO);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return innerList; // Database error
    }

    /*
     * public MountainReply getReply(int mountainNo, int replyNo){ String SQL =
     * "SELECT * from mountain_reply WHERE mountain_no = ? and reply_no = ?";
     *
     * try{ PreparedStatement pstmt = conn.prepareStatement(SQL);
     * pstmt.setInt(1, mountainNo); pstmt.setInt(2, replyNo);
     *
     * rs = pstmt.executeQuery();
     *
     * if (rs.next()){ MountainReply mountainReply = new MountainReply();
     * mountainReply.setMountainNo(rs.getInt(1));
     * mountainReply.setReplyNo(rs.getInt(2));
     * mountainReply.setReplyContent(rs.getString(3));
     * mountainReply.setReplyMakeUser(rs.getString(4));
     * mountainReply.setReplyMakeDt(rs.getString(5));
     * mountainReply.setReplyLikeCnt(rs.getInt(6));
     * mountainReply.setReplyDislikeCnt(rs.getInt(7));
     * mountainReply.setReplyDeleteYn(rs.getInt(8));
     *
     * return mountainReply; } } catch(Exception e){ e.printStackTrace(); }
     * return null; }
     *
     * public int delete(int mountainNo, int replyNo){ String SQL =
     * "UPDATE mountain_reply SET reply_delete_yn=2 WHERE mountain_no = ? and reply_no = ?"
     * ; try{ PreparedStatement pstmt = conn.prepareStatement(SQL);
     * pstmt.setInt(1, mountainNo); pstmt.setInt(2, replyNo);
     *
     * return pstmt.executeUpdate(); } catch(Exception e){ e.printStackTrace();
     * } return -1; //Database error }
     */

    public int update(int boardNo, int replyNo, int reReplyNo, String replyContent) {
        String SQL = "UPDATE "+ this.tableName +" SET re_reply_content=? WHERE "+ this.colBoardNo +" =? and reply_no=? and re_reply_no = ?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, replyContent);
            pstmt.setInt(2, boardNo);
            pstmt.setInt(3, replyNo);
            pstmt.setInt(4, reReplyNo);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }
}
