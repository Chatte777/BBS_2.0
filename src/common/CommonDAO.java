package common;

import dbConn.DbConn;
import errorMaster.ErrorMasterDAO;

import java.io.FileWriter;
import java.net.InetAddress;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.text.SimpleDateFormat;

public class CommonDAO {
    private DbConn dbConn=new DbConn();
    private Connection conn=dbConn.getDbConnection();
    private ResultSet rs;

    public static void writeContentLog(String action, String content){
    try {
        String location;
        InetAddress ip = InetAddress.getLocalHost();
        if (ip.toString().equals("KoreaUniv-PC/192.168.219.90"))
            location = "E:\\Dropbox\\Workspace\\IntelliJ\\BBS\\BBS_2.0\\out\\log\\contentLog.txt";
        else location = "C:\\Users\\IMTSOFT\\Documents\\contentLog.txt";

        long curTimeLong = System.currentTimeMillis();
        SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        String curTimeStr = dayTime.format(new java.sql.Date(curTimeLong));

        FileWriter writer = new FileWriter(location, true);
        writer.write(curTimeStr + "\t"+ action +"\r\n" + content + "\r\n\r\n");
        writer.close();
    } catch (Exception innerE) {
        innerE.printStackTrace();
    }
    return;
    }

    public String getDate(){
        String SQL = "select now()";
        try{
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if(rs.next()){
                return rs.getString(1);
            }
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("", "", "", "", "commonDAO.getDate", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return ""; //Database error
    }

    public int getTotalBoardIndex(String SQL, String makeUser){
        int totalBoardCount =1;
        try{
            //조건에 맞는 전체 게시글 갯수
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);

            rs = pstmt.executeQuery();

            while(rs.next()){
                totalBoardCount = rs.getInt(1);
            }
            return totalBoardCount;
        } catch(Exception e){
            ErrorMasterDAO errorMasterDAO = new ErrorMasterDAO();
            errorMasterDAO.write("SQL: "+SQL, "makeUser: "+makeUser, "", "", "CommonDAO.getTotalBoardIndex", e.getMessage().toString(), "");
            e.printStackTrace();
        }
        return totalBoardCount;
    }
}
