package image;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;
import org.json.simple.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

@WebServlet("/ImageUpload")
public class ImageUpload extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //String uploadPath = "/testImage";
        String uploadPath = "D:/tmpImage";
        int maxSize = 1024 * 1024 *     100;
        String encoding = "UTF-8";
        String fileName = "";

        try{
            MultipartRequest multipartRequest = new MultipartRequest(request, uploadPath, maxSize, encoding, new DefaultFileRenamePolicy());
            Enumeration files = multipartRequest.getFileNames();
            String file = (String)files.nextElement();
            fileName = multipartRequest.getFilesystemName(file);
        } catch (Exception e){
            e.printStackTrace();
        }

        uploadPath = uploadPath + fileName;
        response.getWriter().write(uploadPath);
    }
}
