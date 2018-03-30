package reply;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import alarmMaster.AlarmMaster;
import alarmMaster.AlarmMasterDAO;
import dbConn.*;

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
			e.printStackTrace();
		}
		return -1; //Database error
	}

	
	public int write(int boardNo, String replyMakeUser, String replyContent){
		String SQL = "INSERT INTO "+ this.boardName+"_reply" +" VALUES(?,?,?,?,?,?,?,?)";
		int tmpNextNo = getNext(boardNo);
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

			replyContent = replyContent.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
			if(replyContent.length()>70) replyContent=replyContent.substring(0,70);
			AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
			alarmMasterDAO.writeReplyAlarm(this.boardName, boardNo, tmpNextNo, replyContent);

			return pstmt.executeUpdate();
		} catch(Exception e){
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
				ReplyVO reply = new ReplyVO();
				reply.setBoardNo(rs.getInt(1));
				reply.setReplyNo(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setReplyMakeUser(rs.getString(4));
				reply.setReplyMakeDt(rs.getString(5));
				reply.setReplyLikeCnt(rs.getInt(6));
				reply.setReplyDislikeCnt(rs.getInt(7));
				reply.setReplyDeleteYn(rs.getInt(8));
				list.add(reply);
			}
		} catch(Exception e){
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
				ReplyVO reply = new ReplyVO();
				reply.setBoardNo(rs.getInt(1));
				reply.setReplyNo(rs.getInt(2));
				reply.setReplyContent(rs.getString(3));
				reply.setReplyMakeUser(rs.getString(4));
				reply.setReplyMakeDt(rs.getString(5));
				reply.setReplyLikeCnt(rs.getInt(6));
				reply.setReplyDislikeCnt(rs.getInt(7));
				reply.setReplyDeleteYn(rs.getInt(8));

				return reply;
			}
		} catch(Exception e){
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
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int update(int boardNo, int replyNo, String replyContent){
		String SQL = "UPDATE "+ this.boardName+"_reply" +" SET reply_Content=? WHERE "+ this.colNo +" =? and reply_no=?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, boardNo);
			pstmt.setInt(3, replyNo);
			
			return pstmt.executeUpdate();
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
}
