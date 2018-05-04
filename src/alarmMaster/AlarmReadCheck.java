package alarmMaster;

import com.sun.xml.fastinfoset.algorithm.IntEncodingAlgorithm;
import common.CommonValidation;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AlarmReadCheck.ajax")
public class AlarmReadCheck extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int alarmNo = CommonValidation.alarmNoValidation(request);
        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        int result = alarmMasterDAO.updateAlarmReadYn(alarmNo);
        if(result==1) response.getWriter().write("1");
    }
}
