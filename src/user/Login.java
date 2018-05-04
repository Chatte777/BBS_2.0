package user;

import common.CommonValidation;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/Login.do")
public class Login extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = CommonValidation.userIdValidation(request);
        String userPassword = CommonValidation.userPasswordValidation(request);
        int accountRememberYn = CommonValidation.accountRemeberYnValidation(request);
        int initialLoginFlag = CommonValidation.initialLoginFlagValidation(request);
        HttpSession session = request.getSession();
        response.setContentType("text/html;charset=UTF-8");

        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(userId, userPassword);

        PrintWriter script = response.getWriter();
        script.println("<script>");

        if(result == 1) {
            Cookie cookieAccountRememberYn = new Cookie("accountRememberYn", String.valueOf(accountRememberYn));
            cookieAccountRememberYn.setMaxAge(60 * 60 * 24 * 365);

            if (accountRememberYn == 1) {
                    Cookie cookieIdRemember = new Cookie("idRemember", userId);
                    cookieIdRemember.setMaxAge(60 * 60 * 24 * 365);

                    Cookie cookiePwRemember = new Cookie("pwRemember", userPassword);
                    cookiePwRemember.setMaxAge(60 * 60 * 24 * 365);

                    response.addCookie(cookieIdRemember);
                    response.addCookie(cookiePwRemember);
                }

            response.addCookie(cookieAccountRememberYn);
            session.setAttribute("userId", userId);
            session.setMaxInactiveInterval(60*60*24*7);

            if(initialLoginFlag==1) script.println("location.href='main.jsp'");
            else script.println("history.go(-2)");
        }
        else if(result == 0)
        {
            script.println("alert('비밀번호가 틀린 것 같아요.')");
            script.println("history.back()");
        }
        else if(result == -1)
        {
            script.println("alert('존재하지 않는 아이디인걸요?')");
            script.println("history.back()");
        }
        else if(result == -2)
        {
            script.println("alert('데이터베이스 오류가 발생했습니다..')");
            script.println("history.back()");
        }

        script.println("</script>");
    }
}
