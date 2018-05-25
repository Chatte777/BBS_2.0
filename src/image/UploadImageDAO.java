package image;

import common.CommonDAO;
import dbConn.DbConn;
import errorMaster.ErrorMasterDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UploadImageDAO {
    private DbConn dbConn = new DbConn();
    private Connection conn = dbConn.getDbConnection();
    private ResultSet rs;
    private CommonDAO commonDAO = new CommonDAO();

    public void writeUploadImageStatus(String boardName, int boardNo, String fileName){
        String SQL = "INSERT INTO upload_image_status VALUES(?,?,?,?,?,?)";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);

            pstmt.setString(1, boardName); //boardName
            pstmt.setInt(2, boardNo); //boardNo
            pstmt.setString(3, fileName);  //fileName
            pstmt.setInt(4, 1);  //deleteYn
            pstmt.setString(5, commonDAO.getDate());  //insert Dttm
            pstmt.setString(6, commonDAO.getDate());  //update Dttm

            pstmt.executeUpdate();

            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardName: "+boardName, "boardNo: "+boardNo, "fileName:"+fileName, "", "writeUploadImageDAO.uploadImageStatus", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return; //Database error
    }

    public void deleteUploadImageStatus(String boardName, int boardNo, String fileName){
        String SQL = "UPDATE upload_image_status SET delete_yn=2 and update_dttm=? where board_name=? and board_no = ? and file_name = ?";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);

            pstmt.setString(1, commonDAO.getDate());  //update Dttm
            pstmt.setString(2, boardName); //boardName
            pstmt.setInt(3, boardNo); //boardNo
            pstmt.setString(4, fileName);  //fileName

            pstmt.executeUpdate();

            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardName: "+boardName, "boardNo: "+boardNo, "fileName:"+fileName, "", "UploadImageDAO.updateUploadImageStatus", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return; //Database error
    }

}
