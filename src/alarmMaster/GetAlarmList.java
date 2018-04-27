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
        int pageNumber=1;
        if(request.getParameter("pageNumber")!=null) pageNumber = Integer.parseInt(request.getParameter("pageNumber"));

        HttpSession session = request.getSession();
        String sessionId = "";
        if(session.getAttribute("userId")!=null) sessionId = session.getAttribute("userId").toString();

        AlarmMasterDAO alarmMasterDAO = new AlarmMasterDAO();
        ArrayList<AlarmMaster> alarmList = alarmMasterDAO.getList(pageNumber, sessionId);
        boolean isNextPage = alarmMasterDAO.isNextPage(pageNumber, sessionId);

        request.setAttribute("alarmList", alarmList);
        request.setAttribute("isNextPage", isNextPage);
        response.setContentType("text/html;charset=UTF-8");

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("alarm_test.jsp");
        requestDispatcher.forward(request, response);
    }
}
