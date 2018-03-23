<%--
  Created by IntelliJ IDEA.
  User: KoreaUniv
  Date: 2018-03-22
  Time: 오후 11:12
  To change this template use File | Settings | File Templates.
--%>

<%@page import="org.json.simple.JSONObject"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>

<%
    // 이미지 업로드할 경로
    String uploadPath = "C:/WebApp/apache-tomcat-8.5.27/webapps/images/uploadFile/";
    int size = 1024 * 1024 * 100;  //100메가 이하

    String fileName = ""; // 파일명

    try{
        // 파일업로드 및 업로드 후 파일명 가져옴
        MultipartRequest multi = new MultipartRequest(request, uploadPath, size, "utf-8", new DefaultFileRenamePolicy());
        Enumeration files = multi.getFileNames();
        String file = (String)files.nextElement();
        fileName = multi.getFilesystemName(file);

    }catch(Exception e){
        e.printStackTrace();
    }

    // 업로드된 경로와 파일명을 통해 이미지의 경로를 생성
    uploadPath = uploadPath + fileName;

    // 생성된 경로를 JSON 형식으로 보내주기 위한 설정
    JSONObject jobj = new JSONObject();
    jobj.put("url", uploadPath);

    response.setContentType("application/json"); // 데이터 타입을 json으로 설정하기 위한 세팅
    out.print(jobj.toJSONString());
%>