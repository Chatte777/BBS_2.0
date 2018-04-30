function errorAlert(alertType, link) {
    if (alertType == 1) { //session.userId==null
        alert("로그인이 풀렸어요!");
        location.href = link;
    } else if (alertType == 2) { //session.userId 있음
        alert("이미 로그인이 되어있는걸요?");
        location.href = link;
    } else if (alertType == 11) { //boardName==null && 게시판 접근
        alert("게시판에 잘못된 경로로 접근하고 계세요!");
        location.href = "main.jsp";
    } else if (alertType == 12) { //boardName==null && 게시글접근
        alert("글을 작성하고자 하는 게시판을 선택하신 다음 글을 작성해주세요 :)");
        location.href = "main.jsp";
    } else if(alertType == 21) { //boardNo==null
        alert("수정하고자 하는 게시글 조회 화면을 통해서 접근 해주세요.");
        location.href = link;
    }
}