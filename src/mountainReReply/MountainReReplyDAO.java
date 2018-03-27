package mountainReReply;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class MountainReReplyDAO {

	private Connection conn;
	private ResultSet rs;

	public MountainReReplyDAO() {
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
		} catch (Exception e) {
			e.printStackTrace();
		}
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

	public int getNext(int mountainNo) {
		String SQL = "SELECT count(1) FROM mountain_reply WHERE mountain_no = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountainNo);
			rs = pstmt.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // ù �Խù��� ���.
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}

	public int write(int mountainNo, String replyMakeUser, String replyContent) {
		String SQL = "INSERT INTO mountain_reply VALUES(?,?,?,?,?,?,?,?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountainNo);
			pstmt.setInt(2, getNext(mountainNo));
			pstmt.setString(3, replyContent);
			pstmt.setString(4, replyMakeUser);
			pstmt.setString(5, getDate());
			pstmt.setInt(6, 1);
			pstmt.setInt(7, 1);
			pstmt.setInt(8, 1);

			return pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}

	public ArrayList<MountainReReply> getInnerList(int mountainNo, int replyNo) {
		String innerSQL = "SELECT * from mountain_re_reply WHERE mountain_no=? and reply_no=? and reply_delete_yn=1";
		ArrayList<MountainReReply> innerList = new ArrayList<MountainReReply>();

		try {
			PreparedStatement innerPstmt = conn.prepareStatement(innerSQL);
			innerPstmt.setInt(1, mountainNo);
			innerPstmt.setInt(2, replyNo);

			ResultSet innerRs = innerPstmt.executeQuery();

			while (innerRs.next()) {
				MountainReReply mountainReReply = new MountainReReply();
				mountainReReply.setMountainNo(innerRs.getInt(1));
				mountainReReply.setReplyNo(innerRs.getInt(2));
				mountainReReply.setReReplyNo(innerRs.getInt(3));
				mountainReReply.setReReplyContent(innerRs.getString(4));
				mountainReReply.setReReplyMakeUser(innerRs.getString(5));
				mountainReReply.setReReplyMakeDt(innerRs.getString(6));
				mountainReReply.setReReplyLikeCnt(innerRs.getInt(7));
				mountainReReply.setReReplyDislikeCnt(innerRs.getInt(8));
				mountainReReply.setReReplyDeleteYn(innerRs.getInt(9));
				innerList.add(mountainReReply);
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

	public int update(int mountainNo, int replyNo, String replyContent) {
		String SQL = "UPDATE mountain_reply SET reply_content=? WHERE mountain_no=? and reply_no=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, replyContent);
			pstmt.setInt(2, mountainNo);
			pstmt.setInt(3, replyNo);

			return pstmt.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}
}
