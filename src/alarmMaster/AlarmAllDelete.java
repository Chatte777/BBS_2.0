package alarmMaster;

import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AlarmAllDelete.ajax")
public class AlarmAllDelete extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String alarmTargetUser = CommonValidation.alarmTargetUserValidation(request);

        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        int result = alarmMasterDAO.updateAlarmAllDeleteYn(alarmTargetUser);
        if(result==1) response.getWriter().write("1");
    }
}
