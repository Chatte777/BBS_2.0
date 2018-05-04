package alarmMaster;

import common.CommonValidation;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet("/GetAlarmList.do")
public class GetAlarmList extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        requestPro(request, response);
    }

    protected void requestPro(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int pageNumber= CommonValidation.pageNumberValidation(request);
        String sessionUserId = CommonValidation.sessionUserIdValidation(request);

        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        ArrayList<AlarmMaster> alarmList = alarmMasterDAO.getList(pageNumber, sessionUserId);
        boolean isNextPage = alarmMasterDAO.isNextPage(pageNumber, sessionUserId);

        request.setAttribute("alarmList", alarmList);
        request.setAttribute("isNextPage", isNextPage);
        response.setContentType("text/html;charset=UTF-8");

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("alarm.jsp");
        requestDispatcher.forward(request, response);
    }
}
