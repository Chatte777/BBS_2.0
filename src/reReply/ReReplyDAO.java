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
    private String tableReplyName;

    public ReReplyDAO(String boardName) {
        this.boardName = boardName;
        this.tableName = boardName+"_re_reply";
        this.colBoardNo = boardName+"_no";
        this.tableReplyName = boardName+"_reply";

        conn = dbConn.getDbConnection();
    }

    public ReReplyVO setReReplyVO(ReReplyVO reReplyVO, ResultSet rs){
        try{
            reReplyVO.setBoardNo(rs.getInt(1));
            reReplyVO.setReplyNo(rs.getInt(2));
            reReplyVO.setReReplyNo(rs.getInt(3));
            reReplyVO.setReReplyContent(rs.getString(4));
            reReplyVO.setReReplyMakeUser(rs.getString(5));
            reReplyVO.setReReplyMakeDt(rs.getString(6));
            reReplyVO.setReReplyLikeCnt(rs.getInt(7));
            reReplyVO.setReReplyDislikeCnt(rs.getInt(8));
            reReplyVO.setReReplyDeleteYn(rs.getInt(9));
        } catch (Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("reReplyVO:"+reReplyVO, "rs:"+rs, "", "", "reReplyDAO.setReReplyVO", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return reReplyVO;
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

    public int write(int boardNo, int replyNo, String replyMakeUser, String reReplyContent) {
        int tmpNextNo = getNext(boardNo, replyNo);
        reReplyContent = reReplyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");

        String SQL = "INSERT INTO "+ this.tableName +" VALUES(?,?,?,?,?,?,?,?,?)";
        String secondSQL = "UPDATE " + this.tableReplyName + " SET has_re_reply = 2 WHERE reply_no = " + replyNo;
        try {
            PreparedStatement pstmt = conn.prepareStatement(secondSQL);
            pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "reReplyNo:"+tmpNextNo, "", "reReplyDAO.write()_updateHasReReply", e.getMessage().toString(), "");
        }

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            pstmt.setInt(3, tmpNextNo);
            pstmt.setString(4, reReplyContent);
            pstmt.setString(5, replyMakeUser);
            pstmt.setString(6, getDate());
            pstmt.setInt(7, 1);
            pstmt.setInt(8, 1);
            pstmt.setInt(9, 1);

            if(boardNo!=0) {
                reReplyContent = reReplyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(reReplyContent.length()>70) reReplyContent=reReplyContent.substring(0,70);

                AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
                alarmMasterDAO.writeReReplyAlarm(this.boardName, boardNo, replyNo, tmpNextNo, reReplyContent);
            }
            return pstmt.executeUpdate();

        } catch (Exception e) {
            CommonDAO.writeContentLog("reReplyWrite", reReplyContent);

            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "reReplyNo:"+tmpNextNo, "", "reReplyDAO.write()_updateHasReReply", e.getMessage().toString(), "");
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
                setReReplyVO(reReplyVO, innerRs);

                innerList.add(reReplyVO);
            }

        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo"+boardNo, "replyNo"+replyNo, "", "", "reReplyDAO.GetList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return innerList; // Database error
    }

    public int update(int boardNo, int replyNo, int reReplyNo, String reReplyContent) {
        reReplyContent = reReplyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
        String SQL = "UPDATE "+ this.tableName +" SET re_reply_content=? WHERE "+ this.colBoardNo +" =? and reply_no=? and re_reply_no = ?";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, reReplyContent);
            pstmt.setInt(2, boardNo);
            pstmt.setInt(3, replyNo);
            pstmt.setInt(4, reReplyNo);

            return pstmt.executeUpdate();

        } catch (Exception e) {
            CommonDAO.writeContentLog("reReplyUpdate", reReplyContent);

            e.printStackTrace();
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "reReplyNo:"+reReplyNo, "", "reReplyDAO.update", e.getMessage().toString(), "");
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

    public ArrayList<ReReplyVO> getReReplyList(int boardNo, int replyNo){
        String SQL = "SELECT * from "+ this.boardName+"_re_reply" +" WHERE "+ this.colBoardNo +" = ? and reply_no = ? and re_reply_delete_yn = 1";
        ArrayList<ReReplyVO> reReplyList = new ArrayList<ReReplyVO>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);

            rs = pstmt.executeQuery();

            while (rs.next()){
                ReReplyVO reReplyVO = new ReReplyVO();
                setReReplyVO(reReplyVO, rs);

                reReplyList.add(reReplyVO);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "replyDAO.GetBoardList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return reReplyList; //Database error
    }

    public ReReplyVO getReReply(int boardNo, int replyNo, int reReplyNo){
        String SQL = "SELECT * from "+ this.boardName+"_re_reply" +" WHERE "+ this.colBoardNo +" = ? and reply_no = ? and re_reply_no=?";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);
            pstmt.setInt(3, reReplyNo);

            rs = pstmt.executeQuery();

            if (rs.next()){
                ReReplyVO reReplyVO = new ReReplyVO();
                setReReplyVO(reReplyVO, rs);
                return reReplyVO;
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "", "", "replyDAO.getReply", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return null;
    }
}