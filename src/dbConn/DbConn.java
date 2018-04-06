package dbConn;

import errorMaster.ErrorMasterDAO;

import java.net.InetAddress;
import java.sql.Connection;
import java.sql.DriverManager;

public class DbConn {
    private Connection conn;

    public Connection getDbConnection() {
        try {
            String ipStr;
            InetAddress ip = InetAddress.getLocalHost();
            if (ip.toString().equals("KoreaUniv-PC/192.168.219.90")) ipStr = "localhost:3306";
            else ipStr = "localhost:63306";

            String dbURL = "jdbc:mysql://" + ipStr + "/BBS";
            String dbID = "root";
            String dbPassword = "root";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e) {
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("", "", "", "", "DbConn.getDbConnection", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return conn;
    }
}
