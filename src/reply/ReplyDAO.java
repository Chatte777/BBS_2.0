package reply;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import alarmMaster.AlarmMasterDAO;
import dbConn.*;
import errorMaster.ErrorMasterDAO;
import common.*;

public class ReplyDAO {

	private Connection conn;
	private DbConn dbConn = new DbConn();
	private ResultSet rs;
	private String boardName;
	private String colNo;
	
	public ReplyDAO(String boardName) {
		this.boardName = boardName;
		this.colNo = boardName+"_no";

		conn = dbConn.getDbConnection();
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
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("", "", "", "", "replyDAO.getDate", e.getMessage().toString(), "");

			e.printStackTrace();
		}
		return ""; //Database error
	}
	
	public int getNext(int boardNo){
		String SQL = "SELECT count(1) FROM "+ this.boardName+"_reply" +" WHERE "+ this.colNo +" = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				return rs.getInt(1)+1;
			}
			return 1; // Database오류
		} catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "replyDAO.getNext", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}

	public ReplyVO setReplyVO(ReplyVO replyVO, ResultSet rs) {
		try{
			replyVO.setBoardNo(rs.getInt(1));
			replyVO.setReplyNo(rs.getInt(2));
			replyVO.setReplyContent(rs.getString(3));
			replyVO.setReplyMakeUser(rs.getString(4));
			replyVO.setReplyMakeDt(rs.getString(5));
			replyVO.setReplyLikeCnt(rs.getInt(6));
			replyVO.setReplyDislikeCnt(rs.getInt(7));
			replyVO.setReplyDeleteYn(rs.getInt(8));
			replyVO.setHasReReply(rs.getInt(9));
		}catch (Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("replyVO:"+replyVO, "rs:"+rs, "", "", "replyDAO.setReplyVO", e.getMessage().toString(), "");
			e.printStackTrace();
		}

		return replyVO;
	}

	
	public int write(int boardNo, String replyMakeUser, String replyContent){
		String SQL = "INSERT INTO "+ this.boardName+"_reply" +" VALUES(?,?,?,?,?,?,?,?,?)";
		int tmpNextNo = getNext(boardNo);
			replyContent = replyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");

		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			pstmt.setInt(2, tmpNextNo);
			pstmt.setString(3, replyContent);
			pstmt.setString(4,replyMakeUser);
			pstmt.setString(5, getDate());
			pstmt.setInt(6,1);
			pstmt.setInt(7,1);
			pstmt.setInt(8,1);
			pstmt.setInt(9, 1);

			if(replyContent.length()>70) replyContent=replyContent.substring(0,70);
			AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
			alarmMasterDAO.writeReplyAlarm(this.boardName, boardNo, tmpNextNo, replyContent);

			return pstmt.executeUpdate();
		} catch(Exception e){
			CommonDAO.writeContentLog("replyWrite", replyContent);

			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "replyMakeUser:"+replyMakeUser, "", "replyContent:"+replyContent, "replyDAO.write", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}
	

	public ArrayList<ReplyVO> getList(int boardNo){
		String SQL = "SELECT * from "+ this.boardName+"_reply" +" WHERE "+ this.colNo +" = ? and reply_delete_yn = 1";
		ArrayList<ReplyVO> list = new ArrayList<ReplyVO>();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()){
				ReplyVO replyVO = new ReplyVO();
				setReplyVO(replyVO, rs);
				list.add(replyVO);
			}
		} catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "", "", "", "replyDAO.GetBoardList", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return list; //Database error
	}
	

	public ReplyVO getReply(int boardNo, int replyNo){
		String SQL = "SELECT * from "+ this.boardName+"_reply" +" WHERE "+ this.colNo +" = ? and reply_no = ?";
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			pstmt.setInt(2, replyNo);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				ReplyVO replyVO = new ReplyVO();
				setReplyVO(replyVO, rs);
				return replyVO;
			}
		} catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "", "", "replyDAO.getReply", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return null; 
	}

	public int delete(int boardNo, int replyNo){
		String SQL = "UPDATE "+ this.boardName+"_reply" +" SET reply_delete_yn=0 WHERE "+ this.colNo +" = ? and reply_no = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			pstmt.setInt(2, replyNo);

			return pstmt.executeUpdate();
		} catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "", "", "replyDAO.delete", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}

	public int deleteFail(int boardNo, int replyNo){
		String SQL = "UPDATE "+ this.boardName+"_reply" +" SET reply_content='<<삭제된 댓글입니다.>>' WHERE "+ this.colNo +" = ? and reply_no = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardNo);
			pstmt.setInt(2, replyNo);

			return pstmt.executeUpdate();
		} catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "replyNo:"+replyNo, "", "", "replyDAO.deleteFail", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int update(int boardNo, int replyNo, String replyContent){
		replyContent = replyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
		String SQL = "UPDATE "+ this.boardName+"_reply" +" SET reply_Content=? WHERE "+ this.colNo +" =? and reply_no=?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, boardNo);
			pstmt.setInt(3, replyNo);
			
			return pstmt.executeUpdate();
			
		} catch(Exception e){
			CommonDAO.writeContentLog("replyWrite", replyContent);

			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("boardNo:"+boardNo, "replyNo"+replyNo, "", "replyContent:"+replyContent, "replyDAO.update", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}
}
