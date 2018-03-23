var boardName = document.currentScript.getAttribute('boardName');
var boardType = document.currentScript.getAttribute('boardType'); //1:write 2:update

    function contentSubmit() {
        try {
            document.boardForm.action="boardWriteAction.jsp?boardName="+boardName;
            document.boardForm.method="post";
            document.boardForm.submit();
        } catch (e) {
        }
    }

$(document).ready(function() {
    $('#summernote').summernote(
        {
            height: 300,                 // set editor height
            minHeight: null,             // set minimum height of editor
            maxHeight: null,             // set maximum height of editor
            focus: true,             // set focus to editable area after initializing summernote
            onImageUpload : function(files, editor, welEditable) {
                sendFile(files[0], editor, welEditable);
            },
            lang : 'ko-KR',
            placeholder: '이제 게시글에 사진을 업로드할 수 있습니다.',
            codemirror: { // codemirror options
                theme: 'monokai'
            }
        });
});

/* summernote에서 이미지 업로드시 실행할 함수 */
function sendFile(file, editor, welEditable) {
    // 파일 전송을 위한 폼생성
    data = new FormData();
    data.append("uploadFile", file);
    $.ajax({ // ajax를 통해 파일 업로드 처리
        data : data,
        type : "POST",
        url : "./summernote_imageUpload.jsp",
        cache : false,
        contentType : false,
        processData : false,
        success : function(data) { // 처리가 성공할 경우
            // 에디터에 이미지 출력
            editor.insertImage(welEditable, data.url);
        }
        ,error:function(request,status,error){
            alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error+request.dataType);}
    });
}