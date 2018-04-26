package alarmMaster;

import com.sun.xml.fastinfoset.algorithm.IntEncodingAlgorithm;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "Servlet")
public class AlarmReadCheck extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int alarmNo = Integer.parseInt(request.getParameter("alarmNo"));
        String targetUser = request.getParameter("targeutUser");

        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        AlarmMaster alarmMaster = alarmMasterDAO.getAlarmMaster(alarmNo, targetUser);

        int result = alarmMasterDAO.updateAlarmReadYn(alarmMaster.getAlarmNo(), alarmMaster.getAlarmTargetUser());

        response.getWriter().write(result);
    }
}
