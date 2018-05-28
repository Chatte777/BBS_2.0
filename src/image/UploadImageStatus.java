package image;

public class UploadImageStatus {
    private String boardName;
    private int boardNo;
    private String fileName;
    private int deleteYn;
    private String insertDttm;
    private String updateDttm;

    public String getBoardName() {
        return boardName;
    }

    public void setBoardName(String boardName) {
        this.boardName = boardName;
    }

    public int getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(int boardNo) {
        this.boardNo = boardNo;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public int getDeleteYn() {
        return deleteYn;
    }

    public void setDeleteYn(int deleteYn) {
        this.deleteYn = deleteYn;
    }

    public String getInsertDttm() {
        return insertDttm;
    }

    public void setInsertDttm(String insertDttm) {
        this.insertDttm = insertDttm;
    }

    public String getUpdateDttm() {
        return updateDttm;
    }

    public void setUpdateDttm(String updateDttm) {
        this.updateDttm = updateDttm;
    }
}
