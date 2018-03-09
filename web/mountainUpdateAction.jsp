<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="mountainMaster.MountainMasterDAO"%>
<%@ page import="mountainMaster.MountainMaster"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="mountainFile.MountainFileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.util.Enumeration"%>

<%
	request.setCharacterEncoding("UTF-8");
%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DREAMY CAT</title>
</head>
<body>
	<%
		String userID = null;
		String mountainTitle = null;
		String mountainContent = null;

		String tmpDirDesktop = "E:/Dropbox/Workspace/Eclipse/BBS/WebContent/images/uploadFile/mountainFile/";
		String tmpDirLaptop = "C:/Workspace/Eclipse/BBS/WebContent/images/uploadFile/mountainFile/";
		String directory = tmpDirDesktop;
		int maxSize = 1024 * 1024 * 100;
		String encoding = "UTF-8";

		MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
				new DefaultFileRenamePolicy());

		if (session.getAttribute("userID") != null) {
			userID = (String) session.getAttribute("userID");
		}
		if (userID == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		}

		int mountainNo = 0;
		if (request.getParameter("mountainNo") != null) {
			mountainNo = Integer.parseInt(request.getParameter("mountainNo"));
		}

		if (mountainNo == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'mountain.jsp'");
			script.println("</script>");
		}

		MountainMaster mountainMaster = new MountainMasterDAO().getMountainMaster(mountainNo);
		if (!userID.equals(mountainMaster.getMountainMakeUser())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {
			if (multipartRequest.getParameterValues("mountainTitle")[0] == null
					|| multipartRequest.getParameterValues("mountainContent")[0] == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				MountainMasterDAO mountainMasterDAO = new MountainMasterDAO();
				int result = mountainMasterDAO.update(
						Integer.parseInt(multipartRequest.getParameterValues("mountainNo")[0]),
						multipartRequest.getParameterValues("mountainTitle")[0],
						multipartRequest.getParameterValues("mountainContent")[0]);

				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글 수정에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {
					int successsFlag = 1;
					Enumeration fileNames = multipartRequest.getFileNames();

					while (fileNames.hasMoreElements()) {
						String parameter = (String) fileNames.nextElement();

						String fileClientName = multipartRequest.getOriginalFileName(parameter);
						String fileServerName = multipartRequest.getFilesystemName(parameter);
						if (fileClientName == null)
							continue;

						String fileNameLowerCase = fileClientName.toLowerCase();
						if (!fileNameLowerCase.endsWith(".doc") && !fileNameLowerCase.endsWith(".hwp")
								&& !fileNameLowerCase.endsWith(".jpg") && !fileNameLowerCase.endsWith(".gif")
								&& !fileNameLowerCase.endsWith(".png") && !fileNameLowerCase.endsWith(".pdf")
								&& !fileNameLowerCase.endsWith(".xls") && !fileNameLowerCase.endsWith(".jpeg")) {
							File file = new File(directory + fileServerName);
							System.gc();
							file.delete();

							//out.write("업로드할 수 없는 확장자입니다.");
							PrintWriter script = response.getWriter();
							successsFlag = 2;
							script.println("<script>");
							script.println("alert('업로드할 수 없는 확장자입니다.')");
							script.println("history.back()");
							script.println("</script>");
							break;
						} else {
							new MountainFileDAO().upload(fileClientName, fileServerName, result);
							//out.write("파일명: " + fileName + "<br>");
							//out.write("실제파일명: " + fileRealName + "<br>");

						}
					}
					if (successsFlag == 1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('수정 되었습니다..')");
						script.println("location.href='mountain.jsp'");
						script.println("</script>");
					}
				}
			}

		}
	%>
</body>
</html>