package app;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/HistoryServlet")
public class HistoryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<SystemMetric> metricsList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            // Fetch the last 20 metric snapshots
            String sql = "SELECT * FROM system_metrics ORDER BY timestamp DESC LIMIT 20";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                SystemMetric metric = new SystemMetric();
                metric.setMetricId(rs.getInt("metric_id"));
                metric.setCpuUsage(rs.getFloat("total_cpu_usage"));
                metric.setRamUsage(rs.getDouble("used_ram_mb"));
                metric.setTotalProcesses(rs.getInt("total_processes"));
                metric.setTimestamp(rs.getTimestamp("timestamp").toString());
                metricsList.add(metric);
            }
            
            request.setAttribute("metricsList", metricsList);
            request.getRequestDispatcher("history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("dashboard.jsp?error=history_fetch_failed");
        }
    }
}