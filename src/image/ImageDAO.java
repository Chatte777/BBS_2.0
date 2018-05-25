package image;

import common.CommonDAO;
import dbConn.*;
import errorMaster.ErrorMasterDAO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ImageDAO {
    private Connection conn;
    private DbConn dbConn=new DbConn();
    private ResultSet rs;

    public void uploadImageStatus(String boardName, int boardNo, String fileName){
        String SQL = "INSERT INTO upload_image_status VALUES(?,?,?,?,?)";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardName); //boardName
            pstmt.setInt(2, boardNo); //boardNo
            pstmt.setString(3, fileName);  //fileName
            pstmt.setInt(4, 1);  //deleteYn

            pstmt.executeUpdate();

            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardName:"+boardName, "boardNo:"+boardNo, "fileName:"+fileName, "", "ImageDAO.uploadImageStatus", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return; //Database error
    }

    public void updateImageStatus(String boardName, int boardNo, String fileName){
        String SQL = "UPDATE upload_image_status SET delete_yn=2 WHERE boardName=? AND board_no=? AND fileName=?";

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardName); //boardName
            pstmt.setInt(2, boardNo); //boardNo
            pstmt.setString(3, fileName);  //fileName

            pstmt.executeUpdate();

            return;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardName:"+boardName, "boardNo:"+boardNo, "fileName:"+fileName, "", "ImageDAO.updateImageStatus", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return; //Database error
    }
}
