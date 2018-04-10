package errorMaster;

import dbConn.DbConn;

import java.io.FileWriter;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ErrorMasterDAO {
    private Connection conn;
    private DbConn dbConn=new DbConn();
    private ResultSet rs;

    public ErrorMasterDAO() {
        conn=dbConn.getDbConnection();
    }

    public int getNext() {
        String SQL = "SELECT error_no FROM error_master ORDER BY error_no DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        } catch (Exception e) {
            try {
                String location;
                InetAddress ip = InetAddress.getLocalHost();
                if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
                    location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";
                else location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";

                FileWriter writer = new FileWriter(location, true);
                writer.write("ErrorWrite Error \t ErrorMasterDAO.getNext() \t " + e.getMessage().toString() + "\r\n");
                writer.close();
            } catch (Exception innerE) {
                innerE.printStackTrace();
            }
            e.printStackTrace();
        }
        return -1; // Database error
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
            try {
                String location;
                InetAddress ip = InetAddress.getLocalHost();
                if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
                    location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";
                else location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";

                FileWriter writer = new FileWriter(location, true);
                writer.write("ErrorWrite Error \t ErrorMasterDAO.getDate() \t " + e.getMessage().toString() + "\r\n");
                writer.close();
            } catch (Exception innerE) {
                innerE.printStackTrace();
            }
            e.printStackTrace();
        }
        return ""; // Database error
    }

    public int write(String errorVar1, String errorVar2, String errorVar3, String errorVar4, String errorVar5, String errorContent, String errorUserId) {
        String SQL = "INSERT INTO error_master VALUES(?,?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, tmpNextNo);
            pstmt.setString(2, errorVar1);
            pstmt.setString(3, errorVar2);
            pstmt.setString(4, errorVar3);
            pstmt.setString(5, errorVar4);
            pstmt.setString(6, errorVar5);
            pstmt.setString(7, errorContent);
            pstmt.setString(8, errorUserId);
            pstmt.setString(9, getDate());

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch (Exception e) {
            try {
                String location;
                InetAddress ip = InetAddress.getLocalHost();
                if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
                    location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";
                else location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";

                FileWriter writer = new FileWriter(location, true);
                writer.write("ErrorWrite Error \t ErrorMasterDAO.write() \t " + e.getMessage().toString() + "\r\n");
                writer.close();
            } catch (Exception innerE) {
                innerE.printStackTrace();
            }
            e.printStackTrace();
        }
        return -1; // Database error
    }
}
