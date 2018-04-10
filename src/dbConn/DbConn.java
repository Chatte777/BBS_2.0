package dbConn;

import java.io.FileWriter;
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
            try {
                String location;
                InetAddress ip = InetAddress.getLocalHost();
                if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
                    location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";
                else location = "C:\\Users\\IMTSOFT\\Documents\\log.txt";

                FileWriter writer = new FileWriter(location, true);
                writer.write("DbConnection Error \t DbConn.getDbConnection() \t " + e.getMessage().toString() + "\r\n");
                writer.close();
            } catch (Exception innerE) {
                innerE.printStackTrace();
            }
            e.printStackTrace();
        }
        return conn;
    }
}
