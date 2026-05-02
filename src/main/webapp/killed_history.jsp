<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Killed Logs | Remote Monitor</title>
    <style>
        :root { --primary: #2563eb; --danger: #ef4444; --bg: #f8fafc; --card: #ffffff; --text: #1e293b; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); margin: 0; display: flex; height: 100vh; overflow: hidden; }
        
        .sidebar { width: 260px; background: #1e293b; color: white; display: flex; flex-direction: column; padding: 20px; box-shadow: 4px 0 10px rgba(0,0,0,0.1); }
        .sidebar h2 { color: #38bdf8; font-size: 1.2rem; margin-bottom: 30px; }
        .nav-links a { text-decoration: none; color: #cbd5e1; padding: 12px 15px; border-radius: 8px; display: flex; gap: 10px; margin-bottom: 5px; }
        .nav-links a:hover { background: #334155; color: white; }
        .nav-links a.active { background: var(--primary); color: white; }

        .main-content { flex-grow: 1; overflow-y: auto; padding: 30px; }
        .card { background: var(--card); border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); overflow: hidden; }
        
        table { width: 100%; border-collapse: collapse; }
        th { background: #f8fafc; color: #64748b; text-transform: uppercase; font-size: 0.75rem; padding: 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        .badge { background: #fee2e2; color: #b91c1c; padding: 4px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>RemoteMonitor</h2>
        <div class="nav-links">
            <a href="LoginServlet">🏠 Dashboard</a>
            <a href="HistoryServlet">📈 Usage History</a>
            <a href="KilledHistoryServlet" class="active">📂 Killed Logs</a>
        </div>
    </div>

    <div class="main-content">
        <h2 style="margin-top: 0;">Killed Processes Audit Log</h2>
        <p style="color: #64748b; margin-bottom: 25px;">Verified records of administrative process terminations.</p>

        <div class="card">
            <table>
                <thead>
                    <tr><th>Timestamp</th><th>Target PID</th><th>Status</th></tr>
                </thead>
                <tbody>
                    <% List<String[]> logs = (List<String[]>) request.getAttribute("killedLogs");
                       if(logs != null && !logs.isEmpty()) { for(String[] log : logs) { %>
                    <tr>
                        <td><%= log[0] %></td>
                        <td><strong>PID: <%= log[1] %></strong></td>
                        <td><span class="badge"><%= log[2] %></span></td>
                    </tr>
                    <% } } else { %>
                    <tr><td colspan="3" style="text-align:center; padding: 40px;">No audit records found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>