package user;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/login.do")
public class login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = request.getParameter("userId");
        String userPassword = request.getParameter("userPassword");
        String prevPage = request.getParameter("prevPage");
        HttpSession session = request.getSession();

        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(userId, userPassword);

        if(result == 1) {
            if (request.getParameter("accountRememberYn") != null) {
                if (Integer.parseInt(request.getParameter("accountRememberYn")) == 1) {
                    Cookie idRemember = new Cookie("idRemember", userId);
                    idRemember.setMaxAge(60 * 60 * 24 * 365);

                    Cookie pwRemember = new Cookie("pwRemember", userPassword);
                    pwRemember.setMaxAge(60 * 60 * 24 * 365);

                    response.addCookie(idRemember);
                    response.addCookie(pwRemember);
                }
            }
            session.setAttribute("userId", userId);
            session.setMaxInactiveInterval(60*60*24*7);

            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("location.href="+prevPage);
            script.println("</script>");
        }
        else if(result == 0)
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('비밀번호가 틀립니다.')");
            script.println("history.back()");
            script.println("</script>");
        }
        else if(result == -1)
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('존재하지 않는 아이디입니다.')");
            script.println("history.back()");
            script.println("</script>");
        }
        else if(result == -2)
        {
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('데이터베이스 오류가 발생했습니다..')");
            script.println("history.back()");
            script.println("</script>");
        }
    }
}
