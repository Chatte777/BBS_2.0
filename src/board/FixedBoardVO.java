package board;

public class FixedBoardVO {
    private String makeUser;
    private String tableName;
    private int boardNo;
    private int fixedYn;

    public int getFixedYn() {
        return fixedYn;
    }

    public void setFixedYn(int deleteYn) {
        this.fixedYn = deleteYn;
    }

    public String getMakeUser() {
        return makeUser;
    }

    public void setMakeUser(String makeUser) {
        this.makeUser = makeUser;
    }

    public String getTableName() {
        return tableName;
    }

    public void setTableName(String tableName) {
        this.tableName = tableName;
    }

    public int getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(int boardNo) {
        this.boardNo = boardNo;
    }
}
