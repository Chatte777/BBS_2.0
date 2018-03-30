package alarmMaster;

import board.BoardVO;
import dbConn.DbConn;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class AlarmMasterDAO {
    private int boardCountPerPage=15;

    private Connection conn;
    private DbConn dbConn = new DbConn();
    private ResultSet rs;

    public AlarmMasterDAO() {
        conn = dbConn.getDbConnection();
    }

    public int getNext() {
        String SQL = "SELECT alarm_no FROM alarm_master ORDER BY alarm_no DESC";
        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) + 1;
            }
            return 1;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int writeReboardAlarm(String alarmOrgBoardName, int alarmOrgBoardNo, int alarmNewBoardNo) {
        String SQL = "INSERT INTO alarm_master (alarm_no, alarm_target_user, alarm_type, alarm_org_board_name, alarm_org_board_no, alarm_new_board_name, alarm_new_board_no, alarm_content)" +
                " VALUES(?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try {
            BoardVO boardVO = getOrgBoard(alarmOrgBoardName, alarmOrgBoardNo);

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext());
            pstmt.setString(2, boardVO.getBoardMakeUser());
            pstmt.setInt(3, 1);
            pstmt.setString(4, alarmOrgBoardName);
            pstmt.setInt(5, alarmOrgBoardNo);
            pstmt.setString(6, alarmOrgBoardName);
            pstmt.setInt(7, alarmNewBoardNo);
            pstmt.setString(8, boardVO.getBoardTitle());

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int getTotalBoardIndex(String makeUser) {
        String SQL = "SELECT COUNT(1) FROM alarm_masetr" +
                " WH`te_yn = 1 " +
                " AND alarm_read_yn=1 " +
                " AND alarm_target_user = ? " +
                " ORDER BY alarm_no";

        try {
            //조건에 맞는 전체 게시글 갯수
            int totalBoardCount = 1;

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                totalBoardCount = rs.getInt(1);
            }
            return totalBoardCount;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean isNextPage(int pageNumber, String makeUser) {
        int totalBoardIndex = getTotalBoardIndex(makeUser);

        //전체 페이지 갯수(전체 게시글 수가 페이지당 게시글 수로 나누어떨어지지 않으면 나눈 몫에다가 +1
        int totalPageNo;
        if ((totalBoardIndex % boardCountPerPage) == 0) {
            totalPageNo = totalBoardIndex / boardCountPerPage;
        } else {
            totalPageNo = (totalBoardIndex / boardCountPerPage) + 1;
        }

        //변수로 받은 pageNumber가 totalPageNumber보다 작으면 다음 페이지가 있다.(true)
        //같아질 때 부터(같거나 크면) 다음 페이지가 없다.(false)
        if (pageNumber < totalPageNo) return true;
        else return false;
    }

    public ArrayList<AlarmMaster> getList(int pageNumber, String makeUser) {
        int startBoardIndex = 0 + ((pageNumber - 1) * boardCountPerPage);

        String SQL = "SELECT * FROM alarm_master" +
                " WHERE alarm_delete_yn = 1 " +
                " AND alarm_read_yn=1 " +
                " AND alarm_target_user = ? " +
                " ORDER BY alarm_no DESC LIMIT ?,?";

        ArrayList<AlarmMaster> list = new ArrayList<AlarmMaster>();

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, makeUser);
            pstmt.setInt(2, startBoardIndex);
            pstmt.setInt(3, boardCountPerPage);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                AlarmMaster alarmMaster = new AlarmMaster();
                alarmMaster.setAlarmNo(rs.getInt(1));
                alarmMaster.setAlarmTargetUser(rs.getString(2));
                alarmMaster.setAlarmType(rs.getInt(3));
                alarmMaster.setAlarmOrgboardName(rs.getString(4));
                alarmMaster.setAlarmOrgBoardNo(rs.getInt(5));
                alarmMaster.setAlarmOrgReplyNo(rs.getInt(6));
                alarmMaster.setAlarmNewboardName(rs.getString(7));
                alarmMaster.setAlarmNewBoardNo(rs.getInt(8));
                alarmMaster.setAlarmNewReplyNo(rs.getInt(9));
                alarmMaster.setAlarmNewReReplyNo(rs.getInt(10));
                alarmMaster.setAlarmContent(rs.getString(11));
                alarmMaster.setAlarmReadYn(rs.getInt(12));
                alarmMaster.setAlarmDeleteYn(rs.getInt(13));

                list.add(alarmMaster);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; //Database error
    }

    public BoardVO getOrgBoard(String boardName, int boardNo){
        String TableName = boardName+"_master";
        String colBoardNo = boardName+"_no";
        String title=null;

        BoardVO boardVO = new BoardVO();

        String SQL = "SELECT * FROM " + TableName +
                " WHERE "+ colBoardNo +" = ? ";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                //title을 받아온다.
                title = rs.getString(3);
                title = title.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                //title = title.substring(0, 70);
                boardVO.setBoardTitle(title);

                //makeUser를 받아온다.
                boardVO.setBoardMakeUser(rs.getString(6));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return boardVO;
    }
}
