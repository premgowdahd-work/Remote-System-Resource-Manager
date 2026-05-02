package app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    // Handles the redirect from KillServlet
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    // Handles the initial login form submission
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Unified logic to handle both GET and POST.
     * This ensures the dashboard refreshes correctly after a process is killed.
     */
    private void processRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String uname = request.getParameter("username");
        String pass = request.getParameter("password");

        // If the user is already logged in (redirecting from KillServlet), 
        // we skip credential checking and just refresh the list.
        if (session.getAttribute("user") != null) {
            refreshDashboard(request, response);
            return;
        }

        // Logic for first-time login
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                response.sendRedirect("login.jsp?error=db_connection_failed");
                return;
            }

            String query = "SELECT * FROM admins WHERE username=? AND password=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, uname);
            ps.setString(2, pass);
            
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                session.setAttribute("user", uname);
                refreshDashboard(request, response);
            } else {
                response.sendRedirect("login.jsp?error=invalid_credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("login.jsp?error=server_exception");
        }
    }

//    private void refreshDashboard(HttpServletRequest request, HttpServletResponse response) 
//            throws ServletException, IOException {
//        // FETCH THE LIVE PROCESS LIST
//        List<ProcessInfo> processList = ProcessManager.getAllProcesses();
//        request.setAttribute("processList", processList);
//        
//        // Forward back to the dashboard UI
//        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
//    }
    private void refreshDashboard(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Fetch the live list from the OS
        List<ProcessInfo> processList = ProcessManager.getAllProcesses();
        
        // 2. Sort the list in descending order of CPU usage
        // We use a Comparator to compare the CPU values of two ProcessInfo objects
        if (processList != null) {
            processList.sort((p1, p2) -> Double.compare(p2.getCpuUsage(), p1.getCpuUsage()));
        }
        
        // 3. Fetch the total system health metric
        float totalCpu = ProcessManager.getTotalCpuLoad();
        
        // 4. Set attributes and forward
        request.setAttribute("totalCpu", totalCpu);
        request.setAttribute("processList", processList);
        
        request.getRequestDispatcher("dashboard.jsp").forward(request, response);
    }
}