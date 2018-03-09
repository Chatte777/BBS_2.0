package file;

public class FileVO {
    private int boardNo;
    private int fileNo;
    private String fileClientName;
    private String fileServerName;
    private int fileTp;
    private int fileDeleteYn;

    public int getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(int boardNo) {
        this.boardNo = boardNo;
    }

    public int getFileNo() {
        return fileNo;
    }

    public void setFileNo(int fileNo) {
        this.fileNo = fileNo;
    }

    public String getFileClientName() {
        return fileClientName;
    }

    public void setFileClientName(String fileClientName) {
        this.fileClientName = fileClientName;
    }

    public String getFileServerName() {
        return fileServerName;
    }

    public void setFileServerName(String fileServerName) {
        this.fileServerName = fileServerName;
    }

    public int getFileTp() {
        return fileTp;
    }

    public void setFileTp(int fileTp) {
        this.fileTp = fileTp;
    }

    public int getFileDeleteYn() {
        return fileDeleteYn;
    }

    public void setFileDeleteYn(int fileDeleteYn) {
        this.fileDeleteYn = fileDeleteYn;
    }

    public FileVO(int boardNo, int fileNo, String fileClientName, String fileServerName, int fileTp,
                  int fileDeleteYn) {
        super();
        this.boardNo = boardNo;
        this.fileNo = fileNo;
        this.fileClientName = fileClientName;
        this.fileServerName = fileServerName;
        this.fileTp = fileTp;
        this.fileDeleteYn = fileDeleteYn;
    }
}
