package bbs;

import java.sql.Connection;		
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import dbConn.*;

public class BbsDAO {

	private Connection conn;
	private DbConn dbConn=new DbConn();
	private ResultSet rs;
	
	public BbsDAO() {
		conn=dbConn.getDbConnection();
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
		String SQL = "SELECT bbsID FROM bbs ORDER BY bbsID DESC";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
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
	
	public int write(String bbsTitle, String userID, String bbsContent){
		String SQL = "INSERT INTO bbs VALUES(?,?,?,?,?,?)";
		int tmpNextNo = getNext();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, tmpNextNo);
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, bbsContent);
			pstmt.setInt(6, 1);
			
			pstmt.executeUpdate();
			return tmpNextNo;
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public ArrayList<Bbs> getList(int pageNumber){
		String SQL = "SELECT * from BBS WHERE bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()){
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return list; //Database error
	}
	
	public boolean nextPage(int pageNumber){
		String SQL = "SELECT * from BBS WHERE bbsID < ? AND bbsAvailable = 1";
		
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
	
	public Bbs getBbs(int bbsID){
		String SQL = "SELECT * from BBS WHERE bbsID = ?";
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				Bbs bbs = new Bbs();
				bbs.setBbsID(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setUserID(rs.getString(3));
				bbs.setBbsDate(rs.getString(4));
				bbs.setBbsContent(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				
				return bbs;
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return null; 
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent){
		String SQL = "UPDATE BBS SET bbsTitle=?, bbsContent=? WHERE bbsID=?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			
			pstmt.executeUpdate();
			return bbsID;
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int delete(int bbsID){
		String SQL = "UPDATE BBS SET bbsAvailable=0 WHERE BBSid = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int getReplyCnt(int bbsID) {
		String SQL = "SELECT COUNT(1) from reply WHERE bbsID=? and replyAvailable=1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);

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
}
