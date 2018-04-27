package user;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import dbConn.*;
import errorMaster.ErrorMasterDAO;

public class UserDAO {

	private Connection conn;
	private DbConn dbConn = new DbConn();
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		conn = dbConn.getDbConnection();
	}
	
	public int login(String userId, String userPassword){
		String SQL = "SELECT userPassword FROM USER WHERE userId= ?";
		try{
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				if(rs.getString(1).equals(userPassword)){
					return 1; // Login successs
				}
				else
					return 0;
			}
			return -1; // no ID
		}catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("userId"+userId, "userPassWord"+userPassword, "", "", "userDAO.login", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -2; //Database error
	}
	
	public int join(User user){
		String SQL = "INSERT INTO USER VALUES (?,?,?,?,?)";
		
		try{
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, user.getuserId());
			pstmt.setString(2, user.getUserPassword());
			pstmt.setString(3, user.getUserName());
			pstmt.setString(4, user.getUserGender());
			pstmt.setString(5, user.getUserEmail());
			return pstmt.executeUpdate();
		}catch(Exception e){
			ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
			errorMasterDAO.write("userId"+user.getuserId(), "userPassWord"+user.getUserPassword(), "userName"+user.getUserName(), "userEmail"+user.getUserEmail(), "userDAO.join", e.getMessage().toString(), "");
			e.printStackTrace();
		}
		return -1; //Database error
	}
}