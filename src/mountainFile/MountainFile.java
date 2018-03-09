package mountainFile;

public class MountainFile {
	private int mountainNo;
	private int fileNo;
	private String fileClientName;
	private String fileServerName;
	private int fileTp;
	private int fileDeleteYn;

	public int getMountainNo() {
		return mountainNo;
	}

	public void setMountainNo(int mountainNo) {
		this.mountainNo = mountainNo;
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

	public MountainFile(int mountainNo, int fileNo, String fileClientName, String fileServerName, int fileTp,
			int fileDeleteYn) {
		super();
		this.mountainNo = mountainNo;
		this.fileNo = fileNo;
		this.fileClientName = fileClientName;
		this.fileServerName = fileServerName;
		this.fileTp = fileTp;
		this.fileDeleteYn = fileDeleteYn;
	}
}
