package alarmMaster;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/GetAlarmCount.do")
public class GetAlarmCount extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = CommonValidation.userIdValidation(request);
        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        int alarmCount = alarmMasterDAO.getAlarmCount(userId);

        response.getWriter().write(String.valueOf(alarmCount));
    }
}
