<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width" , initial-scale="1">
<link rel="stylesheet" href="css/bootstrap.css">
<title>DREAMY KAT</title>
<style type="text/css">
a, a:hover {
	color: #000000;
	text-decoration: none;
}
</style>
</head>
<body>
	<form action="uploadAction.jsp" method="post"
		enctype="multipart/form-data">
		파일 : <input type="file" name="file1"><br>
		파일 : <input type="file" name="file2"><br>
		파일 : <input type="file" name="file3"><br>
		<input type="submit" value="업로드"><br>
	</form>

	<br>
	<a href="fileDownload.jsp">파일 다운로드 페이지</a>
</body>
</html>