<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ page import="java.io.PrintWriter"%>
<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="board.BoardDAO" %>
<%@ page import="board.BoardVO" %>


<%
	request.setCharacterEncoding("UTF-8");

		String userID = null;

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

		int boardNo = 0;
		if (request.getParameter("boardNo") != null) {
			boardNo = Integer.parseInt(request.getParameter("boardNo"));
		}

		if (boardNo == 0) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('유효하지 않은 글입니다.')");
			script.println("location.href = 'bbs.jsp'");
			script.println("</script>");
		}

		String boardName = request.getParameter("boardName");

		BoardDAO boardDAO = new BoardDAO(boardName);
		BoardVO boardVO = boardDAO.getBoardVO(boardNo);

		if (!userID.equals(boardVO.getBoardMakeUser())) {
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('권한이 없습니다.')");
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
				int result = boardDAO.update(Integer.parseInt(multipartRequest.getParameterValues("boardNo")[0]),
						multipartRequest.getParameterValues("boardTitle")[0],
						multipartRequest.getParameterValues("boardContent")[0],
						Integer.parseInt(multipartRequest.getParameterValues("boardAuthorize")[0]));

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
							new FileDAO(boardName).upload(fileClientName, fileServerName, result);
							//out.write("파일명: " + fileName + "<br>");
							//out.write("실제파일명: " + fileRealName + "<br>");

						}
					}
					if (successsFlag == 1) {
						PrintWriter script = response.getWriter();
						script.println("<script>");
						script.println("alert('수정 되었습니다..')");
						script.println("location.href='boardView.jsp?boardName="+boardName+"&boardNo="+boardNo+"'");
						script.println("</script>");
					}
				}
			}
		}
	%>
