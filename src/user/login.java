package user;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login.do")
public class login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        //User userBean = new User();
        //userBean.setUserId(request.getParameter("userId"));
        //userBean.setUserPassword(request.getParameter("userPassword"));
        //userBean.setUserName(request.getParameter("userName"));
        //userBean.setUserGender(request.getParameter("userGender"));
        //userBean.setUserEmail(request.getParameter("userEmail"));

        //request.setAttribute("bean", userBean);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("loginAction.jsp");
        requestDispatcher.forward(request, response);
    }
}
