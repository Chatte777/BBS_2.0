function errorAlert(alertType, link) {
    if (alertType == 1) {
        alert("로그인이 풀렸어요!");
        location.href = link;
    } else if (alertType == 2) {
        alert("이미 로그인이 되어있는걸요?");
        location.href = link;
    } else if (alertType == 11) {
        alert("게시판에 잘못된 경로로 접근하고 계세요!");
        location.href = "main.jsp";
    } else if (alertType == 12) {
        alert("글을 작성하고자 하는 게시판을 선택하신 다음 글을 작성해주세요 :)");
        location.href = "main.jsp";
    }
}