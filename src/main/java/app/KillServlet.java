package app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/KillServlet")
public class KillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pid = request.getParameter("pid");
        if (pid != null && !pid.isEmpty()) {
            try {
                Runtime.getRuntime().exec("taskkill /F /PID " + pid).waitFor(); 
                logActionToDB(Integer.parseInt(pid));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.sendRedirect("LoginServlet");
    }

    private void logActionToDB(int pid) {
        String insertSql = "INSERT INTO system_logs (pid, process_name, action_performed) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            // 1. Log the Kill Action
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setInt(1, pid);
                ps.setString(2, "REMOTE_KILL");
                ps.setString(3, "SUCCESS");
                ps.executeUpdate();
            }

            // 2. Cleanup Logs (Keep only last 20)
            String deleteSql = "DELETE FROM system_logs WHERE log_id NOT IN (" +
                               "SELECT log_id FROM (SELECT log_id FROM system_logs " +
                               "ORDER BY timestamp DESC LIMIT 20) AS tmp)";
            try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
                ps.executeUpdate();
            }
            
            System.out.println("Log entry created and table cleaned.");
        } catch (Exception e) {
            System.err.println("SQL Log/Cleanup Failure: " + e.getMessage());
        }
    }
}