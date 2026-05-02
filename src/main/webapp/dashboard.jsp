<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, app.ProcessInfo" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Console: Remote Process Monitor</title>
    <style>
        body { font-family: sans-serif; padding: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #007bff; color: white; text-align: left; padding: 10px; }
        td { border-bottom: 1px solid #ddd; padding: 10px; }
        .kill-btn { color: red; font-weight: bold; text-decoration: none; cursor: pointer; }
    </style>
</head>
<body>

    <h2>Admin Console: Remote Process Monitor</h2>
    <button onclick="location.href='LoginServlet'" 
        style="padding: 10px 20px; background-color: #28a745; color: white; border: none; border-radius: 4px; cursor: pointer; font-weight: bold;">
    	🔄 Refresh Live Data
	</button>
    <div style="background: #e9ecef; padding: 15px; border-radius: 5px; margin-bottom: 20px;">
    <strong>System Health:</strong> 
    Total CPU: <%= request.getAttribute("totalCpu") != null ? request.getAttribute("totalCpu") : "Calculating..." %>% | 
    Total Processes: <%= ((List)request.getAttribute("processList")).size() %>
	</div>

	<!-- Add this near your "Welcome" message in dashboard.jsp -->
	<p>
    Welcome, <%= session.getAttribute("user") %> | 
    <a href="HistoryServlet" style="color: green; font-weight: bold;">View System History</a> | 
    <a href="logout.jsp">Logout</a>
	</p>

    <table>
        <thead>
            <tr>
                <th>PID</th>
                <th>Process Name</th>
                <th>CPU Usage (%)</th>
                <th>RAM Usage (MB)</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
            <%
                List<ProcessInfo> list = (List<ProcessInfo>) request.getAttribute("processList");
                if(list != null) {
                    for(ProcessInfo p : list) {
            %>
             <%-- Find this row in your dashboard.jsp loop --%>
<tr>
    <td><%= p.getPid() %></td>
    <td><%= p.getName() %></td>
    <%-- Update this line specifically --%>
    <td><%= String.format("%.1f", p.getCpuUsage()) %>%</td> 
    <td><%= p.getRamUsage() %> MB</td>
    <td><a href="KillServlet?pid=<%= p.getPid() %>" class="kill-btn">Kill</a></td>
</tr>
            <% 
                    }
                } else { 
            %>
            <tr><td colspan="5">No active processes found.</td></tr>
            <% } %>
        </tbody>
    </table>

</body>
</html>