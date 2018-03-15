<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="file.FileDAO"%>
<%@ page import="java.io.File"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="java.io.PrintWriter"%>
<%@ page import="java.util.Enumeration"%>

	<%
	/*
	//String directory = application.getRealPath("/upload/");
	String directory = "images/uploadFile/uploadFile";
	int maxSize = 1024 * 1024 * 100;
	String encoding = "UTF-8";
	
	MultipartRequest multipartRequest = new MultipartRequest(request, directory, maxSize, encoding, new DefaultFileRenamePolicy());
	
	Enumeration fileNames = multipartRequest.getFileNames();
	while(fileNames.hasMoreElements()){
		String parameter = (String)fileNames.nextElement();
		
		String fileName = multipartRequest.getOriginalFileName(parameter);
		String fileRealName = multipartRequest.getFilesystemName(parameter);
		if(fileName == null) continue;
		
		String fileNameLowerCase = fileName.toLowerCase();
		if(!fileNameLowerCase.endsWith(".doc") && !fileNameLowerCase.endsWith(".hwp") && !fileNameLowerCase.endsWith(".jpg") && !fileNameLowerCase.endsWith(".gif") && !fileNameLowerCase.endsWith(".png") && !fileNameLowerCase.endsWith(".pdf") && !fileNameLowerCase.endsWith(".xls") && !fileNameLowerCase.endsWith(".jpeg")){
			File file = new File(directory + fileRealName);
			System.gc();
			file.delete();
			
			//out.write("업로드할 수 없는 확장자입니다.");
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('업로드할 수 없는 확장자입니다.')");
			script.println("history.back()");
			script.println("</script>");
		} else {
			new FileDAO().upload(fileName, fileRealName);
			//out.write("파일명: " + fileName + "<br>");
			//out.write("실제파일명: " + fileRealName + "<br>");
			PrintWriter script = response.getWriter();
			script.println("<script>");
			script.println("alert('업로드 되었습니다..')");
			script.println("history.back()");
			script.println("</script>");	
		}
	}
	*/
	%>