<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="threadMaster.ThreadMasterDAO"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="threadFile.ThreadFileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.util.Enumeration"%>


<%
	request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="threadMaster" class="threadMaster.ThreadMaster" scope="page" />
<jsp:setProperty name="threadMaster" property="threadTitle" />
<jsp:setProperty name="threadMaster" property="threadContent" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>DREAMY CAT</title>
</head>
<body>
	<%
		String userID = null;
		String threadTitle = null;
		String threadContent = null;

		String tmpDirDesktop = "E:/Dropbox/Workspace/Eclipse/BBS/WebContent/images/uploadFile/threadFile/";
		String tmpDirLaptop = "C:/Workspace/Eclipse/BBS/WebContent/images/uploadFile/threadFile/";
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
		} else {
			if (multipartRequest.getParameterValues("threadTitle")[0] == null
					|| multipartRequest.getParameterValues("threadContent")[0] == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
				ThreadMasterDAO threadMasterDAO = new ThreadMasterDAO();
				int result = threadMasterDAO.write(multipartRequest.getParameterValues("threadTitle")[0], userID,
						multipartRequest.getParameterValues("threadContent")[0],
						Integer.parseInt(multipartRequest.getParameterValues("threadAuthorize")[0]));

				if (result == -1) {
					PrintWriter script = response.getWriter();
					script.println("<script>");
					script.println("alert('글쓰기에 실패했습니다.')");
					script.println("history.back()");
					script.println("</script>");
				} else {

					Enumeration fileNames = multipartRequest.getFileNames();
					int successFlag = 1;

					while (fileNames.hasMoreElements()) {
						String parameter = (String) fileNames.nextElement();

						String fileClientName = multipartRequest.getOriginalFileName(parameter);
						String fileServerName = multipartRequest.getFilesystemName(parameter);
						if (fileClientName == null)
							continue;

						String fileNameLowerCase = fileClientName.toLowerCase();
						if (!fileNameLowerCase.endsWith(".jpg") && !fileNameLowerCase.endsWith(".gif")
								&& !fileNameLowerCase.endsWith(".png") && !fileNameLowerCase.endsWith(".jpeg")) {
							File file = new File(directory + fileServerName);
							System.gc();
							file.delete();

							//out.write("업로드할 수 없는 확장자입니다.");
							successFlag = 2;
							PrintWriter script = response.getWriter();
							script.println("<script>");
							script.println("alert('업로드할 수 없는 확장자입니다.')");
							script.println("history.back()");
							script.println("</script>");
							
							break;
						} else {
							new ThreadFileDAO().upload(fileClientName, fileServerName, result);
							//out.write("파일명: " + fileName + "<br>");
							//out.write("실제파일명: " + fileRealName + "<br>");

						}

					}
					if (successFlag == 1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('업로드 되었습니다..')");
						script.println("location.href='thread.jsp'");
						script.println("</script>");

					}
				}
			}
		}
	%>
</body>
</html>









