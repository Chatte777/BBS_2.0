package board;

import common.CommonValidation;
import image.UploadImageDAO;
import image.UploadImageStatus;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@WebServlet("/BoardWrite.do")
public class BoardWrite extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        ////////// 변수선언 및 초기화
        request.setCharacterEncoding("UTF-8");
        int result=0;
        String boardName = CommonValidation.boardNameValidation(request);
        int boardNo= CommonValidation.boardNoValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        String boardTitle = CommonValidation.boardTitleValildation(request);
        int boardAuthorize = CommonValidation.boardAuthorizeValidation(request);
        String boardPassword = "";
        String boardContent = CommonValidation.boardContentValidation(request);
        int writeFlag = CommonValidation.writeFlagValidation(request);
        int fixedYn = CommonValidation.fixedYnValidation(request);

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter script = response.getWriter();

        script.println("<script>");

        if("".equals(sessionUserId)){
            setCookie(boardTitle, boardContent, boardAuthorize, response);

            script.println("alert('서버로부터의 알림 : 로그인이 풀렸습니다.')");
            script.println("location.href = 'login.jsp'");
        } else {
            BoardDAO boardDAO = new BoardDAO(boardName);
            if(boardNo==0) boardNo = boardDAO.getNext();

            // 게시글 비밀번호 처리
            if(boardAuthorize==2){
                if(request.getParameter("boardPassword")!=null) {
                    if(request.getParameter("boardPassword").equals("")) boardPassword="0000";
                    else boardPassword = request.getParameter("boardPassword");
                }
                else boardPassword = "0000";
            }

            ////////// imageUploadStatus 처리
            // imgsrc에서 넘어온 이미지 리스트
            List<String> listFromSrc = getImgSrcList(boardContent);
            int splitCount=0;
            int imageCount=listFromSrc.size();
            // '/'로 쪼갠 배열의 갯수를 구하기 위해 하나의 시범 데이터를 '/'로 쪼개서 몇개의 셀이 나오는지 확인한다.
            if(listFromSrc!=null && listFromSrc.size()!=0) splitCount = listFromSrc.get(0).split("/").length;
            for(int i=0; i<listFromSrc.size(); i++){ // src에서 fileName만 발라내기. '/'로 쪼갠 결과물 중 제일 마지막 셀.
                listFromSrc.set(i, listFromSrc.get(i).split("/")[splitCount-1]);
            }
            // 기존에 DB에 등록되어있던 이미지 리스트
            UploadImageDAO uploadImageDAO = new UploadImageDAO();
            ArrayList<UploadImageStatus> listFromServer = uploadImageDAO.getUploadImageList(boardName, boardNo);
            // DB의 리스트 - src의 리스트 차집합 구하기
            List<String> subtractList = getSubtractList(listFromServer, listFromSrc);

            //writeFlag==1 : 글 작성, writeFlag==2 : 글 수정, writeFlag==3 : 답글작성
            // 답글 작성할 경우에도 이 모듈을 사용하기 때문에 boardNo에 대한 정보가 있음.
            if(writeFlag==1){
                // writeUploadImageStatus 호출
                for(int i=0; i<listFromSrc.size(); i++){
                    uploadImageDAO.writeUploadImageStatus(boardName, boardNo, listFromSrc.get(i));
                }
                // boardDAO.write 호출
                result = boardDAO.write(boardTitle, sessionUserId, boardContent, boardAuthorize, boardNo, boardPassword, imageCount, writeFlag);
            } else if(writeFlag==2){
                // DB의 리스트 - src의 리스트 차집합 = 삭제된 이미지. 삭제처리한다.
                for(int i=0; i<subtractList.size(); i++){
                    uploadImageDAO.deleteUploadImageStatus(boardName, boardNo, subtractList.get(i));
                }
                // src에 들어온 이미지 = 등록할 이미지. 등록처리한다. 중복일 경우는 insert Ignore
                // 서로 다른 파일인데 파일명이 중복으로 들어올 수는 없음. (upload Image 모듈에서 처리완료)
                for(int i=0; i<listFromSrc.size(); i++){
                    uploadImageDAO.writeUploadImageStatus(boardName, boardNo, listFromSrc.get(i));
                }
                result = boardDAO.update(boardNo, boardTitle, boardContent, boardAuthorize, boardPassword, imageCount);
            } else if(writeFlag==3){
                // writeUploadImageStatus 호출
                for(int i=0; i<listFromSrc.size(); i++){
                    uploadImageDAO.writeUploadImageStatus(boardName, boardNo, listFromSrc.get(i));
                }
                // DAO.write 호출
                result = boardDAO.write(boardTitle, sessionUserId, boardContent, boardAuthorize, boardNo, boardPassword, imageCount, writeFlag);
            }

            // 상단 고정 게시글일 경우 fixedBoard 테이블에 insert
            if(fixedYn==1) boardDAO.writeFixedBoard(sessionUserId, boardName, boardNo);
            else boardDAO.deleteFixedBoard(sessionUserId, boardName, boardNo);

            // 실패했을 경우 작성한 값들을 쿠키에 임시 저장 및 reoloadFlag를 1로 변경.
            if (result == -1) {
                setCookie(boardTitle, boardContent, boardAuthorize, response);

                script.println("alert('서버로부터의 알림 : 글쓰기에 실패했습니다.')");
                script.println("location.href='board.jsp?boardName="+boardName+"'");
            } else {
                //1: page redirect, 2: JSON Return
                if(writeFlag==2) script.println("location.href='GetBoard.do?boardName="+boardName+"&boardNo="+boardNo+"&viewFlag=1'");
                else script.println("location.href='board.jsp?boardName="+boardName+"'");
            }
        }

        script.println("</script>");
    }

    private void setCookie(String boardTitle, String boardContent, int boardAuthorize, HttpServletResponse response){
        try{
            Cookie cookieReloadFlag = new Cookie("reloadFlag", "1");
            cookieReloadFlag.setMaxAge(60);
            Cookie cookieBoardTitle = new Cookie("boardTitle", URLEncoder.encode(boardTitle,"utf-8"));
            cookieBoardTitle.setMaxAge(60);
            Cookie cookieBoardContent = new Cookie("boardContent", URLEncoder.encode(boardContent,"utf-8"));
            cookieBoardContent.setMaxAge(60);
            Cookie cookieBoardAuthorize = new Cookie("boardAuthorize", String.valueOf(boardAuthorize));
            cookieBoardAuthorize.setMaxAge(60);

            response.addCookie(cookieReloadFlag);
            response.addCookie(cookieBoardTitle);
            response.addCookie(cookieBoardContent);
            response.addCookie(cookieBoardAuthorize);

            return;
        } catch (Exception e){
            e.printStackTrace();
        }
    }

    private List getImgSrcList(String str) {
        Pattern nonValidPattern = Pattern
                .compile("<img[^>]*src=[\"']?([^>\"']+)[\"']?[^>]*>");

        List result = new ArrayList();
        Matcher matcher = nonValidPattern.matcher(str);
        while (matcher.find()) {
            result.add(matcher.group(1));
        }

        return result;
    }

    private List<String> getSubtractList(List<UploadImageStatus> listFromServer, List<String> listFromSrc){
        HashSet<String> hashSetFromServer = new HashSet<>();
        for(int i=0; i<listFromServer.size(); i++){
            hashSetFromServer.add(listFromServer.get(i).getFileName());
        }

        HashSet<String> hashSetFromSrc = new HashSet<>();
        for(int i=0; i<listFromSrc.size(); i++){
            hashSetFromSrc.add(listFromSrc.get(i));
        }

        hashSetFromServer.removeAll(hashSetFromSrc);
        List<String> returnList = new ArrayList<>(hashSetFromServer);
        return returnList;
    }
}
