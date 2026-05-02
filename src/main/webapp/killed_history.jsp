<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Killed Processes History</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 30px; background-color: #f4f7f6; color: #333; }
        .container { max-width: 900px; margin: auto; background: white; padding: 25px; border-radius: 12px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
        h2 { color: #c0392b; border-bottom: 2px solid #eee; padding-bottom: 10px; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background-color: #fff5f5; }
        .back-link { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #3498db; font-weight: bold; }
        .status-badge { background: #e74c3c; color: white; padding: 4px 8px; border-radius: 4px; font-size: 0.85em; }
    </style>
</head>
<body>
    <div class="container">
        <a href="LoginServlet" class="back-link">← Back to Dashboard</a>
        <h2>Killed Processes Audit Log</h2>
        <p>A historical record of all processes terminated via this admin console.</p>
        
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Target PID</th>
                    <th>Action Performed</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<String[]> logs = (List<String[]>) request.getAttribute("killedLogs");
                    if(logs != null && !logs.isEmpty()) {
                        for(String[] log : logs) {
                %>
                <tr>
                    <td><%= log[0] %></td>
                    <td><strong><%= log[1] %></strong></td>
                    <td><span class="status-badge"><%= log[2] %></span></td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="3" style="text-align:center;">No processes have been killed yet.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>