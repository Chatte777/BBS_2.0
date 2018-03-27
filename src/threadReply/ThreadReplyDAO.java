package threadReply;

import java.net.InetAddress;
import java.sql.Connection;	
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class ThreadReplyDAO {

	private Connection conn;
	private ResultSet rs;
	
	public ThreadReplyDAO() {
		try {
			String ipStr;
			InetAddress ip = InetAddress.getLocalHost();
			if(ip.toString().equals("KoreaUniv-PC/192.168.219.90")) ipStr="localhost:3306";
			else ipStr = "localhost:63306";

			String dbURL = "jdbc:mysql://" +ipStr+ "/BBS";
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
	
	public int getNext(int threadNo){
		String SQL = "SELECT count(1) FROM thread_reply WHERE thread_no = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				return rs.getInt(1)+1;
			}
			return 1; // ù �Խù��� ���.
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int write(int threadNo, String replyMakeUser, String replyContent){
		String SQL = "INSERT INTO thread_reply VALUES(?,?,?,?,?,?,?,?)";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			pstmt.setInt(2, getNext(threadNo));
			pstmt.setString(3, replyContent);
			pstmt.setString(4, replyMakeUser);
			pstmt.setString(5, getDate());
			pstmt.setInt(6, 1);
			pstmt.setInt(7, 1);
			pstmt.setInt(8, 1);
			
			return pstmt.executeUpdate();
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	

	public ArrayList<ThreadReply> getList(int threadNo){
		String SQL = "SELECT * from thread_reply WHERE thread_no = ? and reply_delete_yn = 1";
		ArrayList<ThreadReply> list = new ArrayList<ThreadReply>();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);			
			
			rs = pstmt.executeQuery();
			
			while (rs.next()){
				ThreadReply threadReply = new ThreadReply();
				threadReply.setThreadNo(rs.getInt(1));
				threadReply.setReplyNo(rs.getInt(2));
				threadReply.setReplyContent(rs.getString(3));
				threadReply.setReplyMakeUser(rs.getString(4));
				threadReply.setReplyMakeDt(rs.getString(5));
				threadReply.setReplyLikeCnt(rs.getInt(6));
				threadReply.setReplyDislikeCnt(rs.getInt(7));
				threadReply.setReplyDeleteYn(rs.getInt(8));
				list.add(threadReply);
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return list; //Database error
	}
	

	public ThreadReply getReply(int threadNo, int replyNo){
		String SQL = "SELECT * from thread_reply WHERE thread_no = ? and reply_no = ?";
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			pstmt.setInt(2, replyNo);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				ThreadReply threadReply = new ThreadReply();
				threadReply.setThreadNo(rs.getInt(1));
				threadReply.setReplyNo(rs.getInt(2));
				threadReply.setReplyContent(rs.getString(3));
				threadReply.setReplyMakeUser(rs.getString(4));
				threadReply.setReplyMakeDt(rs.getString(5));
				threadReply.setReplyLikeCnt(rs.getInt(6));
				threadReply.setReplyDislikeCnt(rs.getInt(7));
				threadReply.setReplyDeleteYn(rs.getInt(8));
				
				return threadReply;
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return null; 
	}
	
	public int delete(int threadNo, int replyNo){
		String SQL = "UPDATE thread_reply SET reply_delete_yn=0 WHERE thread_no = ? and reply_no = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			pstmt.setInt(2, replyNo);
			
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int update(int threadNo, int replyNo, String replyContent){
		String SQL = "UPDATE thread_reply SET reply_content=? WHERE thread_no=? and reply_no=?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, threadNo);
			pstmt.setInt(3, replyNo);
			
			return pstmt.executeUpdate();
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
}
