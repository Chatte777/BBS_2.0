package reReply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import alarmMaster.AlarmMasterDAO;
import dbConn.*;
import errorMaster.ErrorMasterDAO;
import common.*;

public class ReReplyDAO {

    private Connection conn;
    private DbConn dbConn = new DbConn();
    private ResultSet rs;
    private String boardName;
    private String tableName;
    private String colBoardNo;

    public ReReplyDAO(String boardName) {
        this.boardName = boardName;
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
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("", "", "", "", "reReplyDAO.getDate", e.getMessage().toString(), "");
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
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo"+replyNo, "", "", "reReplyDAO.getNext", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int write(int boardNo, int replyNo, String replyMakeUser, String replyContent) {
        int tmpNextNo = getNext(boardNo, replyNo);

        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            pstmt.setInt(3, tmpNextNo);
            pstmt.setString(4, replyContent);
            pstmt.setString(5, replyMakeUser);
            pstmt.setString(6, getDate());
            pstmt.setInt(7, 1);
            pstmt.setInt(8, 1);
            pstmt.setInt(9, 1);

            if(boardNo!=0) {
                replyContent = replyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(replyContent.length()>70) replyContent=replyContent.substring(0,70);

                AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
                alarmMasterDAO.writeReReplyAlarm(this.boardName, boardNo, replyNo, tmpNextNo, replyContent);
            }
            return pstmt.executeUpdate();

        } catch (Exception e) {
            CommonDAO.writeContentLog("reReplyWrite", replyContent);

            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo"+boardNo, "replyNo"+replyNo, "reReplyMakeUser"+replyMakeUser, "reReplyContent"+replyContent, "reReplyDAO.getDate", e.getMessage().toString(), "");
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
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo"+boardNo, "replyNo"+replyNo, "", "", "reReplyDAO.getList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return innerList; // Database error
    }

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
            CommonDAO.writeContentLog("reReplyUpdate", replyContent);

            e.printStackTrace();
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "reReplyDAO.getDate", e.getMessage().toString(), "");
        }
        return -1; // Database error
    }

    public int delete(int boardNo, int replyNo, int reReplyNo){
        String SQL = "UPDATE "+ this.tableName +" SET re_reply_delete_yn=0 WHERE "+ this.colBoardNo +" = ? and reply_no = ? and re_reply_no=?";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            pstmt.setInt(3, reReplyNo);

            return pstmt.executeUpdate();
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "", "", "replyDAO.delete", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return -1; //Database error
    }
}