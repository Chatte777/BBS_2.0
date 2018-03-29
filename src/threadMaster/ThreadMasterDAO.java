package threadMaster;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import dbConn.*;

public class ThreadMasterDAO {

	private Connection conn;
	private DbConn dbConn = new DbConn();
	private ResultSet rs;
	
	public ThreadMasterDAO() {
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
	
	public int getNext(){
		String SQL = "SELECT thread_no FROM thread_master ORDER BY thread_no DESC";
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
	
	public int write(String threadTitle, String threadMakeUser, String threadContent, int threadAuthorize){
		String SQL = "INSERT INTO thread_master VALUES(?,?,?,?,?,?,?,?,?,?,?)";
		int tmpNextNo = getNext();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, tmpNextNo);
			pstmt.setString(2, threadTitle);
			pstmt.setInt(3, 1);
			pstmt.setString(4, threadContent);
			pstmt.setString(5, threadMakeUser);
			pstmt.setString(6, getDate());
			pstmt.setInt(7, 1);
			pstmt.setInt(8, 1);
			pstmt.setInt(9, 1);
			pstmt.setInt(10, 1);
			pstmt.setInt(11, threadAuthorize);

			pstmt.executeUpdate();
			
			return tmpNextNo;
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	
	public ArrayList<ThreadMaster> getList(int pageNumber, String userId){
		String SQL = "SELECT * from thread_master "
				+ "WHERE thread_no < ? "
				+ "AND thread_delete_yn=1 "
				+ "AND (thread_authorize = 1 OR (thread_authorize=2 and thread_make_user=?))"
				+ "ORDER BY thread_no DESC LIMIT 10";
		ArrayList<ThreadMaster> list = new ArrayList<ThreadMaster>();
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext()-(pageNumber-1)*10);
			pstmt.setString(2, userId);
			
			rs = pstmt.executeQuery();
			
			while (rs.next()){
				ThreadMaster threadMaster = new ThreadMaster();
				threadMaster.setThreadNo(rs.getInt(1));
				threadMaster.setThreadTitle(rs.getString(2));
				threadMaster.setThreadTm(rs.getInt(3));
				threadMaster.setThreadContent(rs.getString(4));
				threadMaster.setThreadMakeUser(rs.getString(5));
				threadMaster.setThreadMakeDt(rs.getString(6));
				threadMaster.setThreadReadCnt(rs.getInt(7));
				threadMaster.setThreadLikeCnt(rs.getInt(8));
				threadMaster.setThreadDislikeCnt(rs.getInt(9));
				threadMaster.setThreadDeleteYn(rs.getInt(10));
				threadMaster.setThreadAuthorize(rs.getInt(11));
				list.add(threadMaster);
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return list; //Database error
	}
	
	public boolean nextPage(int pageNumber){
		String SQL = "SELECT * from thread_master WHERE thread_no < ? AND thread_delete_yn = 1";
		
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
	
	public ThreadMaster getThreadMaster(int threadNo){
		String SQL = "SELECT * from thread_master WHERE thread_no = ?";
		
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			
			rs = pstmt.executeQuery();
			
			if (rs.next()){
				ThreadMaster threadMaster = new ThreadMaster();
				threadMaster.setThreadNo(rs.getInt(1));
				threadMaster.setThreadTitle(rs.getString(2));
				threadMaster.setThreadTm(rs.getInt(3));
				threadMaster.setThreadContent(rs.getString(4));
				threadMaster.setThreadMakeUser(rs.getString(5));
				threadMaster.setThreadMakeDt(rs.getString(6));
				threadMaster.setThreadReadCnt(rs.getInt(7));
				threadMaster.setThreadLikeCnt(rs.getInt(8));
				threadMaster.setThreadDislikeCnt(rs.getInt(9));
				threadMaster.setThreadDeleteYn(rs.getInt(10));
				threadMaster.setThreadAuthorize(rs.getInt(11));
				
				return threadMaster;
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return null; 
	}
	
	public int update(int threadNo, String threadTitle, String threadContent, int threadAuthorize){
		String SQL = "UPDATE thread_master SET thread_title=?, thread_content=?, thread_authorize=? WHERE thread_no=?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, threadTitle);
			pstmt.setString(2, threadContent);
			pstmt.setInt(3, threadAuthorize);
			pstmt.setInt(4, threadNo);
			
			pstmt.executeUpdate();
			return threadNo;
			
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
	
	public int delete(int threadNo){
		String SQL = "UPDATE thread_Master SET thread_delete_yn=2 WHERE thread_no = ?";
		try{
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);
			
			return pstmt.executeUpdate();
		} catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}

	public int getReplyCnt(int threadNo) {
		String SQL = "SELECT COUNT(1) from thread_reply WHERE thread_no=? and reply_delete_yn=1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);

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
	
	public int getReplyColor(int threadNo) {
		String SQL = "SELECT reply_make_dt from thread_reply WHERE thread_no=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, threadNo);

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
						if (secondGap <= 30) gapFlag = 1; // 30��-�����
						else gapFlag = 2;
					} else if (minuteGap <= 3)  gapFlag = 2; // 3��-������
					  else if (minuteGap <= 10) gapFlag = 3; // 10��-��Ȳ��
					  else if (minuteGap <= 30) gapFlag = 4; // 30��-�ʷϻ�
					  else gapFlag = 5;
				} else if (hourGap <= 2) gapFlag = 5; // 2�ð�-�Ķ���
				  else gapFlag = 6; // ������

				return gapFlag;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
