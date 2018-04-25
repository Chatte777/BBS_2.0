package alarmMaster;

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
        int pageNumber = Integer.parseInt(request.getParameter("pageNumber"));
        HttpSession session = request.getSession();
        String sessionId = session.getAttribute("userID").toString();

        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        ArrayList<AlarmMaster> alarmList = alarmMasterDAO.getList(pageNumber, sessionId);

        request.setAttribute("alarmList", alarmList);

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("alarm.jsp");
        requestDispatcher.forward(request, response);
    }
}
