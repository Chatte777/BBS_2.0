package board;

public class BoardVO {
    private int boardNo;
    private String boardTitle;
    private int boardTm;
    private String boardContent;
    private String boardMakeUser;
    private String boardMakeDt;
    private int boardReadCnt;
    private int boardLikeCnt;
    private int boardDislikeCnt;
    private int boardDeleteYn;
    private int boardAuthorize;

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
    public int getBoardReadCnt() {
        return boardReadCnt;
    }
    public void setBoardReadCnt(int boardReadCnt) {
        this.boardReadCnt = boardReadCnt;
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
}
