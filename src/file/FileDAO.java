package file;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class FileDAO {
    private Connection conn;
    private String tableName;
    private String colNo;

    public FileDAO(String boardName) {
        this.tableName = boardName + "_file";
        this.colNo = boardName + "_no";

        try {
            String ipStr;
            InetAddress ip = InetAddress.getLocalHost();
            if (ip.toString().equals("KoreaUniv-PC/192.168.219.90")) ipStr = "localhost";
            else ipStr = "122.42.239.89";

            String dbURL = "jdbc:mysql://" + ipStr + ":3306/BBS";
            String dbID = "root";
            String dbPassword = "root";

            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getNext(int threadNo) {
        String SQL = "SELECT COUNT(1) FROM " + this.tableName + " WHERE " + this.colNo + " = ?";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, threadNo);
            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int upload(String fileClientName, String fileServerName, int boardName) {
        String SQL = "INSERT INTO " + this.tableName + " VALUES(?,?,?,?,?,?)";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardName);
            pstmt.setInt(2, getNext(boardName));
            pstmt.setString(3, fileClientName);
            pstmt.setString(4, fileServerName);
            pstmt.setInt(5, 1);
            pstmt.setInt(6, 1);

            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public int hit(String fileRealName) {
        String SQL = "UPDATE " + this.tableName + " SET downloadCount = downloadCount + 1 " + "WHERE fileRealName=?";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, fileRealName);
            return pstmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public ArrayList<FileVO> getList(int boardNo) {
        String SQL = "SELECT * FROM " + this.tableName + " WHERE " + this.colNo + " =?";
        ArrayList<FileVO> list = new ArrayList<FileVO>();

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            ResultSet rs = pstmt.executeQuery();

            while (rs.next()) {
                FileVO file = new FileVO(rs.getInt(1), rs.getInt(2), rs.getString(3), rs.getString(4), rs.getInt(5), rs.getInt(6));
                list.add(file);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

}
