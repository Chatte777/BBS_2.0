<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ page import="java.io.PrintWriter"%>
<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="board.BoardDAO" %>


<%
	request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="boardVO" class="board.BoardVO" scope="page" />
<jsp:setProperty name="boardVO" property="boardTitle" />
<jsp:setProperty name="boardVO" property="boardContent" />


	<%
		String userId = null;

		String tmpDirDesktop = "E:/Dropbox/Workspace/Eclipse/BBS/WebContent/images/uploadFile/uploadFile/";
		String tmpDirLaptop = "C:/Workspace/Eclipse/BBS/WebContent/images/uploadFile/uploadFile/";
		String directory = tmpDirDesktop;
		
		int maxSize = 1024 * 1024 * 100;
		String encoding = "UTF-8";

		MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding,
				new DefaultFileRenamePolicy());

		if (session.getAttribute("userID") != null) {
			userId = (String) session.getAttribute("userID");
		}
		if (userId == null) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('로그인을 하세요.')");
			script.println("location.href = 'login.jsp'");
			script.println("</script>");
		} else {
			if (multipartRequest.getParameterValues("boardTitle")[0] == null
					|| multipartRequest.getParameterValues("boardContent")[0] == null) {
				PrintWriter script = response.getWriter();
				script.println("<script>");
				script.println("alert('입력이 안된 사항이 있습니다.')");
				script.println("history.back()");
				script.println("</script>");
			} else {
			    String boardName = request.getParameter("boardName");
				BoardDAO boardDAO = new BoardDAO(boardName);
				int result = boardDAO.write(multipartRequest.getParameterValues("boardTitle")[0], userId,
						multipartRequest.getParameterValues("boardContent")[0], Integer.parseInt(multipartRequest.getParameterValues("boardAuthorize")[0]));

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
							new FileDAO(boardName).upload(fileClientName, fileServerName, result);
							//out.write("파일명: " + fileName + "<br>");
							//out.write("실제파일명: " + fileRealName + "<br>");

						}

					}
					if (successFlag == 1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("location.href='board.jsp?boardName="+boardName+"'");
						script.println("</script>");

					}
				}
			}
		}
	%>