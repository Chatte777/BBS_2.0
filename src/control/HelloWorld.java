package control;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/HelloWorld.do")
public class HelloWorld extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        reqPro(request,response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        reqPro(request, response);
    }

    protected  void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String msg = "Heel world";
        request.setAttribute("msg", msg);

        RequestDispatcher rd = request.getRequestDispatcher("mvctest.jsp");
        rd.forward(request,response);
    }
}
