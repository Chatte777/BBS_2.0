package control;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

//@WebServlet(name = "Servlet")
@WebServlet("/LoginProc.do")
public class LoginProc extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        reqPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        reqPro(request, response);
    }

    public void reqPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");
        System.out.print("id : " + id);
        String password = request.getParameter("password");

        request.setAttribute("id", id);
        request.setAttribute("password", password);


        RequestDispatcher dis = request.getRequestDispatcher("loginProc.jsp");
        dis.forward(request, response);
    }
}
