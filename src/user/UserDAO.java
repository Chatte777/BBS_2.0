package user;

import java.net.InetAddress;	
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
	
	public int login(String userID, String userPassword){
		String SQL = "SELECT userPassword FROM USER WHERE userID= ?";
		try{
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				if(rs.getString(1).equals(userPassword)){
					return 1; // Login successs
				}
				else
					return 0; // Password ����ġ
			}
			return -1; // no ID
		}catch(Exception e){
			e.printStackTrace();
		}
		return -2; //Database error
	}
	
	public int join(User user){
		String SQL = "INSERT INTO USER VALUES (?,?,?,?,?)";
		
		try{
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getUserID());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}
		return -1; //Database error
	}
}
