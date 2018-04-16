package reply;

public class ReplyVO {
	private int boardNo;
	private int replyNo;
    private String replyContent;
	private String replyMakeUser;
	private String replyMakeDt;
	private int replyLikeCnt;
	private int replyDislikeCnt;
	private int replyDeleteYn;
	private int hasReReply;

    public int getBoardNo() {
        return boardNo;
    }

    public void setBoardNo(int boardNo) {
        this.boardNo = boardNo;
    }

    public int getReplyNo() {
        return replyNo;
    }

    public void setReplyNo(int replyNo) {
        this.replyNo = replyNo;
    }

    public String getReplyContent() {
        return replyContent;
    }

    public void setReplyContent(String replyContent) {
        this.replyContent = replyContent;
    }

    public String getReplyMakeUser() {
        return replyMakeUser;
    }

    public void setReplyMakeUser(String replyMakeUser) {
        this.replyMakeUser = replyMakeUser;
    }

    public String getReplyMakeDt() {
        return replyMakeDt;
    }

    public void setReplyMakeDt(String replyMakeDt) {
        this.replyMakeDt = replyMakeDt;
    }

    public int getReplyLikeCnt() {
        return replyLikeCnt;
    }

    public void setReplyLikeCnt(int replyLikeCnt) {
        this.replyLikeCnt = replyLikeCnt;
    }

    public int getReplyDislikeCnt() {
        return replyDislikeCnt;
    }

    public void setReplyDislikeCnt(int replyDislikeCnt) {
        this.replyDislikeCnt = replyDislikeCnt;
    }

    public int getReplyDeleteYn() {
        return replyDeleteYn;
    }

    public void setReplyDeleteYn(int replyDeleteYn) {
        this.replyDeleteYn = replyDeleteYn;
    }

    public int getHasReReply() {
        return hasReReply;
    }

    public void setHasReReply(int hasReReply) {
        this.hasReReply = hasReReply;
    }
}
