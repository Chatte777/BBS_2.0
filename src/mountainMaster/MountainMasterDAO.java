package mountainMaster;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Timer;

public class MountainMasterDAO {

	private Connection conn;
	private ResultSet rs;

	public MountainMasterDAO() {
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

	public int getNext() {
		String SQL = "SELECT mountain_no FROM mountain_master ORDER BY mountain_no DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
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

	public int write(String mountainTitle, String mountainMakeUser, String mountainContent) {
		String SQL = "INSERT INTO mountain_master VALUES(?,?,?,?,?,?,?,?,?,?)";
		int tmpNextNo = getNext();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, tmpNextNo);
			pstmt.setString(2, mountainTitle);
			pstmt.setInt(3, 1);
			pstmt.setString(4, mountainContent);
			pstmt.setString(5, mountainMakeUser);
			pstmt.setString(6, getDate());
			pstmt.setInt(7, 1);
			pstmt.setInt(8, 1);
			pstmt.setInt(9, 1);
			pstmt.setInt(10, 1);

			pstmt.executeUpdate();

			return tmpNextNo;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}

	public ArrayList<MountainMaster> getList(int pageNumber) {
		String SQL = "SELECT * from mountain_master WHERE mountain_no < ? AND mountain_delete_yn = 1 ORDER BY mountain_no DESC LIMIT 10";
		ArrayList<MountainMaster> list = new ArrayList<MountainMaster>();

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);

			rs = pstmt.executeQuery();

			while (rs.next()) {
				MountainMaster mountainMaster = new MountainMaster();
				mountainMaster.setMountainNo(rs.getInt(1));
				mountainMaster.setMountainTitle(rs.getString(2));
				mountainMaster.setMountainTm(rs.getInt(3));
				mountainMaster.setMountainContent(rs.getString(4));
				mountainMaster.setMountainMakeUser(rs.getString(5));
				mountainMaster.setMountainMakeDt(rs.getString(6));
				mountainMaster.setMountainReadCnt(rs.getInt(7));
				mountainMaster.setMountainLikeCnt(rs.getInt(8));
				mountainMaster.setMountainDislikeCnt(rs.getInt(9));
				mountainMaster.setMountainDeleteYn(rs.getInt(10));
				list.add(mountainMaster);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list; // Database error
	}

	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * from mountain_master WHERE mountain_no < ? AND mountain_delete_yn = 1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext() - (pageNumber - 1) * 10);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	public MountainMaster getMountainMaster(int mountainNo) {
		String SQL = "SELECT * from mountain_master WHERE mountain_no = ?";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountainNo);

			rs = pstmt.executeQuery();

			if (rs.next()) {
				MountainMaster mountainMaster = new MountainMaster();
				mountainMaster.setMountainNo(rs.getInt(1));
				mountainMaster.setMountainTitle(rs.getString(2));
				mountainMaster.setMountainTm(rs.getInt(3));
				mountainMaster.setMountainContent(rs.getString(4));
				mountainMaster.setMountainMakeUser(rs.getString(5));
				mountainMaster.setMountainMakeDt(rs.getString(6));
				mountainMaster.setMountainReadCnt(rs.getInt(7));
				mountainMaster.setMountainLikeCnt(rs.getInt(8));
				mountainMaster.setMountainDislikeCnt(rs.getInt(9));
				mountainMaster.setMountainDeleteYn(rs.getInt(10));

				return mountainMaster;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public int update(int mountainNo, String mountainTitle, String mountainContent) {
		String SQL = "UPDATE mountain_master SET mountain_title=?, mountain_content=? WHERE mountain_no=?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, mountainTitle);
			pstmt.setString(2, mountainContent);
			pstmt.setInt(3, mountainNo);

			pstmt.executeUpdate();
			return mountainNo;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}

	public int delete(int mountaindNo) {
		String SQL = "UPDATE mountain_Master SET mountain_delete_yn=2 WHERE mountain_no = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountaindNo);

			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1; // Database error
	}

	public int getReplyCnt(int mountainNo) {
		String SQL = "SELECT COUNT(1) from mountain_reply WHERE mountain_no=? and reply_delete_yn=1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountainNo);

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

	public int getReplyColor(int mountainNo) {
		String SQL = "SELECT reply_make_dt from mountain_reply WHERE mountain_no=? and reply_delete_yn=1 ORDER BY reply_no DESC LIMIT 1";

		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, mountainNo);

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
