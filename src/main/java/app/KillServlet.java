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

    // Dashboard links use GET. This MUST exist to avoid 405.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String pid = request.getParameter("pid");
        System.out.println("KillServlet triggered for PID: " + pid); // Debug line

        if (pid != null && !pid.isEmpty()) {
            try {
                // Execute Kill
                Runtime.getRuntime().exec("taskkill /F /PID " + pid).waitFor(); 
                
                // Log to DB
                logActionToDB(Integer.parseInt(pid));
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        // Always redirect back to the refreshed list
        response.sendRedirect("LoginServlet");
    }

    private void logActionToDB(int pid) {
        // Ensure this column exists: action_performed
        String sql = "INSERT INTO system_logs (pid, process_name, action_performed) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, pid);
            ps.setString(2, "REMOTE_KILL");
            ps.setString(3, "SUCCESS");
            ps.executeUpdate();
            System.out.println("Log entry created in DB.");
        } catch (Exception e) {
            System.err.println("SQL Log Failure: " + e.getMessage());
        }
    }
}