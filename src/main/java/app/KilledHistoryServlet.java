package app;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/KilledHistoryServlet")
public class KilledHistoryServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<String[]> logs = new ArrayList<>();
        try (Connection con = DBConnection.getConnection()) {
            String sql = "SELECT * FROM system_logs ORDER BY timestamp DESC";
            ResultSet rs = con.prepareStatement(sql).executeQuery();
            while (rs.next()) {
                logs.add(new String[]{
                    rs.getString("timestamp"),
                    rs.getString("pid"),
                    rs.getString("action_performed")
                });
            }
            request.setAttribute("killedLogs", logs);
            request.getRequestDispatcher("killed_history.jsp").forward(request, response);
        } catch (Exception e) { e.printStackTrace(); }
    }
}