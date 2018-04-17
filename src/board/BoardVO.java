package board;

public class BoardVO {
    private String tableName;
    private int boardNo;
    private String boardTitle;
    private int boardTm;
    private String boardContent;
    private String boardMakeUser;
    private String boardMakeDt;
    private int boardReplyCnt;
    private int boardLikeCnt;
    private int boardDislikeCnt;
    private int boardDeleteYn;
    private int boardAuthorize;
    private int boardReadCount;
    private int isRebaord;
    private int hasReboard;
    private int orgBoardNo;
    private String boardPassword;
    private int boardPriority;

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
    public String getBoardTitle() {
        return boardTitle;
    }
    public void setBoardTitle(String boardTitle) {
        this.boardTitle = boardTitle;
    }
    public int getBoardTm() {
        return boardTm;
    }
    public void setBoardTm(int boardTm) {
        this.boardTm = boardTm;
    }
    public String getBoardContent() {
        return boardContent;
    }
    public void setBoardContent(String boardContent) {
        this.boardContent = boardContent;
    }
    public String getBoardMakeUser() {
        return boardMakeUser;
    }
    public void setBoardMakeUser(String boardMakeUser) {
        this.boardMakeUser = boardMakeUser;
    }
    public String getBoardMakeDt() {
        return boardMakeDt;
    }
    public void setBoardMakeDt(String boardMakeDt) {
        this.boardMakeDt = boardMakeDt;
    }
    public int getBoardReplyCnt() {
        return boardReplyCnt;
    }
    public void setBoardReplyCnt(int boardReplyCnt) {
        this.boardReplyCnt = boardReplyCnt;
    }
    public int getBoardLikeCnt() {
        return boardLikeCnt;
    }
    public void setBoardLikeCnt(int boardLikeCnt) {
        this.boardLikeCnt = boardLikeCnt;
    }
    public int getBoardDislikeCnt() {
        return boardDislikeCnt;
    }
    public void setBoardDislikeCnt(int boardDislikeCnt) {
        this.boardDislikeCnt = boardDislikeCnt;
    }
    public int getBoardDeleteYn() {
        return boardDeleteYn;
    }
    public void setBoardDeleteYn(int boardDeleteYn) {
        this.boardDeleteYn = boardDeleteYn;
    }
    public int getBoardAuthorize() {
        return boardAuthorize;
    }
    public void setBoardAuthorize(int boardAuthorize) {
        this.boardAuthorize = boardAuthorize;
    }
    public int getBoardReadCount() {
        return boardReadCount;
    }
    public void setBoardReadCount(int boardReadCount) {
        this.boardReadCount = boardReadCount;
    }
    public int getIsRebaord() {
        return isRebaord;
    }

    public void setIsRebaord(int isRebaord) {
        this.isRebaord = isRebaord;
    }

    public int getHasReboard() {
        return hasReboard;
    }

    public void setHasReboard(int hasReboard) {
        this.hasReboard = hasReboard;
    }

    public int getOrgBoardNo() {
        return orgBoardNo;
    }

    public void setOrgBoardNo(int orgBoardNo) {
        this.orgBoardNo = orgBoardNo;
    }

    public String getBoardPassword() {
        return boardPassword;
    }

    public void setBoardPassword(String boardPassword) {
        this.boardPassword = boardPassword;
    }

    public int getBoardPriority() {
        return boardPriority;
    }

    public void setBoardPriority(int boardPriority) {
        this.boardPriority = boardPriority;
    }
}