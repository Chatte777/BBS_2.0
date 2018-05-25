package image;

import common.CommonDAO;
import dbConn.DbConn;
import errorMaster.ErrorMasterDAO;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class UploadImageDAO {
    private DbConn dbConn = new DbConn();
    private Connection conn = dbConn.getDbConnection();
    private ResultSet rs;
    private CommonDAO commonDAO = new CommonDAO();

    public void writeUploadImageStatus(String boardName, int boardNo, String fileName){
        String SQL = "INSERT IGNORE INTO upload_image_status VALUES(?,?,?,?,?,?)";

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
        String SQL = "UPDATE upload_image_status SET delete_yn=2, update_dttm=? where board_name=? and board_no = ? and file_name = ?";

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

    public ArrayList<UploadImageStatus> getUploadImageList(String boardName, int boardNo){
        String SQL = "SELECT * FROM upload_image_status WHERE board_name=? AND board_no=? AND delete_yn=1";
        ArrayList<UploadImageStatus> list = new ArrayList<>();

        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, boardName);
            pstmt.setInt(2, boardNo);

            rs = pstmt.executeQuery();

            while (rs.next()){
                UploadImageStatus uploadImageStatus = new UploadImageStatus();
                uploadImageStatus.setBoardName(rs.getString(1));
                uploadImageStatus.setBoardNo(rs.getInt(2));
                uploadImageStatus.setFileName(rs.getString(3));
                uploadImageStatus.setDeleteYn(rs.getInt(4));
                uploadImageStatus.setInsertDttm(rs.getString(5));
                uploadImageStatus.setUpdateDttm(rs.getString(6));

                list.add(uploadImageStatus);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("boardName:"+boardName, "boardNo:"+boardNo, "", "", "UploadImageDAO.getUploadImageList", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return list; //Database error
    }

}
