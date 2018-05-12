package alarmMaster;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AlarmAllReadCheck.ajax")
public class AlarmAllReadCheck extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);
        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        int result = alarmMasterDAO.updateAlarmAllReadYn(sessionUserId);
        response.getWriter().write(String.valueOf(result));
    }
}
