package alarmMaster;

import board.BoardVO;
import common.CommonDAO;
import dbConn.DbConn;
import reply.ReplyVO;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class AlarmMasterDAO {
    private int boardCountPerPage = 15;

    private Connection conn;
    private DbConn dbConn = new DbConn();
    private ResultSet rs;
    private CommonDAO commonDAO = new CommonDAO();

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

    public int writeReboardAlarm(String alarmOrgBoardName, int alarmOrgBoardNo, int alarmNewBoardNo, String alarmNewContent) {
        String SQL = "INSERT INTO alarm_master (alarm_no, alarm_target_user, alarm_type, alarm_org_board_name, alarm_org_board_no, alarm_org_content, alarm_new_board_no, alarm_new_content)" +
                " VALUES(?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try {
            BoardVO boardVO = getOrgBoard(alarmOrgBoardName, alarmOrgBoardNo);

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext()); //alarm_no
            pstmt.setString(2, boardVO.getBoardMakeUser()); //alarm_taraget_user
            pstmt.setInt(3, 1);  //alarm_type
            pstmt.setString(4, alarmOrgBoardName); //alarm_org_board_name
            pstmt.setInt(5, alarmOrgBoardNo);  //alarm_org_board_no
            pstmt.setString(6, boardVO.getBoardTitle());  //alarm_content
            pstmt.setInt(7, alarmNewBoardNo);  //alarm_new_board_no
            pstmt.setString(8, alarmNewContent);  //alarm_new_content


            pstmt.executeUpdate();

            return tmpNextNo;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int writeReplyAlarm(String alarmOrgBoardName, int alarmOrgBoardNo, int alarmNewReplydNo, String alarmNewContent) {
        String SQL = "INSERT INTO alarm_master (alarm_no, alarm_target_user, alarm_type, alarm_org_board_name, alarm_org_board_no, alarm_org_content, alarm_new_reply_no, alarm_new_content)" +
                " VALUES(?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try {
            BoardVO boardVO = getOrgBoard(alarmOrgBoardName, alarmOrgBoardNo);

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext()); //alarm_no
            pstmt.setString(2, boardVO.getBoardMakeUser()); //alarm_taraget_user
            pstmt.setInt(3, 2);  //alarm_type
            pstmt.setString(4, alarmOrgBoardName); //alarm_org_board_name
            pstmt.setInt(5, alarmOrgBoardNo);  //alarm_org_board_no
            pstmt.setString(6, boardVO.getBoardTitle());  //alarm_org_content
            pstmt.setInt(7, alarmNewReplydNo);  //alarm_new_board_no
            pstmt.setString(8, alarmNewContent);

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int writeReReplyAlarm(String alarmOrgBoardName, int alarmOrgBoardNo, int alarmOrgReplyNo, int alarmNewReReplydNo, String alarmNewContent) {
        String SQL = "INSERT INTO alarm_master (alarm_no, alarm_target_user, alarm_type, alarm_org_board_name, alarm_org_board_no, alarm_org_reply_no, alarm_org_content, alarm_new_reply_no, alarm_new_content)" +
                " VALUES(?,?,?,?,?,?,?,?,?)";
        int tmpNextNo = getNext();

        try {
            ReplyVO replyVO = getOrgReply(alarmOrgBoardName, alarmOrgBoardNo, alarmOrgReplyNo);

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, getNext()); //alarm_no
            pstmt.setString(2, replyVO.getReplyMakeUser()); //alarm_taraget_user
            pstmt.setInt(3, 3);  //alarm_type
            pstmt.setString(4, alarmOrgBoardName); //alarm_org_board_name
            pstmt.setInt(5, alarmOrgBoardNo);  //alarm_org_board_no
            pstmt.setInt(6, alarmOrgReplyNo); // alarm_org_replyNo
            pstmt.setString(7, replyVO.getReplyContent());  //alarm_org_content
            pstmt.setInt(8, alarmNewReReplydNo);  //alarm_new_board_no
            pstmt.setString(9, alarmNewContent);

            pstmt.executeUpdate();

            return tmpNextNo;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1; // Database error
    }

    public int getTotalAlarmIndex(String alarmTargetUser) {
        String SQL = "SELECT COUNT(1) FROM alarm_master" +
                " WHERE alarm_delete_yn = 1 " +
                " AND alarm_target_user = ? ";

        return commonDAO.getTotalBoardIndex(SQL, alarmTargetUser);
    }

    public boolean isNextPage(int pageNumber, String alarmTargetUser) {
        int totalBoardIndex = getTotalAlarmIndex(alarmTargetUser);

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
                " AND alarm_delete_yn=1 " +
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
                alarmMaster.setAlarmOrgContent(rs.getString(7));
                alarmMaster.setAlarmNewboardName(rs.getString(8));
                alarmMaster.setAlarmNewBoardNo(rs.getInt(9));
                alarmMaster.setAlarmNewReplyNo(rs.getInt(10));
                alarmMaster.setAlarmNewReReplyNo(rs.getInt(11));
                alarmMaster.setAlarmNewContent(rs.getString(12));
                alarmMaster.setAlarmReadYn(rs.getInt(13));
                alarmMaster.setAlarmDeleteYn(rs.getInt(14));

                list.add(alarmMaster);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list; //Database error
    }

    public BoardVO getOrgBoard(String boardName, int boardNo) {
        String colBoardNo = boardName + "_no";
        String title = null;
        String content = null;

        BoardVO boardVO = new BoardVO();

        String SQL = "SELECT * FROM " + boardName + "_master" +
                " WHERE " + colBoardNo + " = ? ";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                //title을 받아온다.
                title = rs.getString(3);
                title = title.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(title.length()>70) title = title.substring(0, 70);
                boardVO.setBoardTitle(title);

                //content를 받아온다.
                content = rs.getString(5);
                content = content.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(content.length()>70) content = content.substring(0, 70);
                boardVO.setBoardContent(content);

                //makeUser를 받아온다.
                boardVO.setBoardMakeUser(rs.getString(6));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return boardVO;
    }

    public ReplyVO getOrgReply(String boardName, int boardNo, int replyNo) {
        String colBoardNo = boardName + "_no";
        String content = null;

        ReplyVO replyVO = new ReplyVO();

        String SQL = "SELECT * FROM " + boardName + "_reply" +
                " WHERE " + colBoardNo + " = ? " +
                "AND reply_no = ?";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, boardNo);
            pstmt.setInt(2, replyNo);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                //content를 받아온다.
                content = rs.getString(3);
                content = content.replaceAll("<br>", "&nbsp;").replaceAll("<p>", "&nbsp;").replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
                if(content.length()>70) content = content.substring(0, 70);
                replyVO.setReplyContent(content);

                //makeUser를 받아온다.
                replyVO.setReplyMakeUser(rs.getString(4));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return replyVO;
    }

    public AlarmMaster getAlarmMaster(int alarmNo) {
        AlarmMaster alarmMaster = new AlarmMaster();
        String SQL = "SELECT * FROM alarm_master WHERE alarm_no = ?";

        try {
            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setInt(1, alarmNo);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                alarmMaster.setAlarmNo(rs.getInt(1));
                alarmMaster.setAlarmTargetUser(rs.getString(2));
                alarmMaster.setAlarmType(rs.getInt(3));
                alarmMaster.setAlarmOrgboardName(rs.getString(4));
                alarmMaster.setAlarmOrgBoardNo(rs.getInt(5));
                alarmMaster.setAlarmOrgReplyNo(rs.getInt(6));
                alarmMaster.setAlarmOrgContent(rs.getString(7));
                alarmMaster.setAlarmNewboardName(rs.getString(8));
                alarmMaster.setAlarmNewBoardNo(rs.getInt(9));
                alarmMaster.setAlarmNewReplyNo(rs.getInt(10));
                alarmMaster.setAlarmNewReReplyNo(rs.getInt(11));
                alarmMaster.setAlarmNewContent(rs.getString(12));
                alarmMaster.setAlarmReadYn(rs.getInt(13));
                alarmMaster.setAlarmDeleteYn(rs.getInt(14));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return alarmMaster;
    }

    public int updateAlarmReadYn(int alarmNo) {
        String SQL = "UPDATE alarm_master SET alarm_read_yn = 2 WHERE alarm_no = " + alarmNo;
        return commonDAO.updateYn(SQL);
    }

    public int updateAlarmAllReadYn(String alarmTargetUser) {
        String SQL = "UPDATE alarm_master SET alarm_read_yn = 2 WHERE alarm_target_user = " + alarmTargetUser;
        return commonDAO.updateYn(SQL);
    }

    public int updateAlarmAllDeleteYn(String alarmTargetUser) {
        String SQL = "UPDATE alarm_master SET alarm_delete_yn = 2 WHERE alarm_target_user = " + alarmTargetUser;
        return commonDAO.updateYn(SQL);
    }

    public int updateAlarmDeleteYn(int alarmNo) {
        String SQL = "UPDATE alarm_master SET alarm_delete_yn = 2 WHERE alarm_no = " + alarmNo;
        return commonDAO.updateYn(SQL);
    }

    public int getAlarmCount(String alarmTargetUser) {
        String SQL = "SELECT COUNT(1) FROM alarm_master" +
                " WHERE alarm_delete_yn = 1 " +
                " AND alarm_read_yn=1 " +
                " AND alarm_target_user = ? ";

        try {
            int alarmCount=0;

            PreparedStatement pstmt = conn.prepareStatement(SQL);
            pstmt.setString(1, alarmTargetUser);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                alarmCount = rs.getInt(1);
            }
            return alarmCount;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return -1;
    }
}
