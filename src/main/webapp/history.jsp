<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, app.SystemMetric" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Usage History | Remote Monitor</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        :root { --primary: #2563eb; --bg: #f8fafc; --card: #ffffff; --text: #1e293b; }
        body { font-family: 'Inter', sans-serif; background: var(--bg); color: var(--text); margin: 0; display: flex; height: 100vh; overflow: hidden; }
        
        .sidebar { width: 260px; background: #1e293b; color: white; display: flex; flex-direction: column; padding: 20px; box-shadow: 4px 0 10px rgba(0,0,0,0.1); }
        .sidebar h2 { color: #38bdf8; font-size: 1.2rem; margin-bottom: 30px; }
        .nav-links a { text-decoration: none; color: #cbd5e1; padding: 12px 15px; border-radius: 8px; display: flex; gap: 10px; margin-bottom: 5px; }
        .nav-links a:hover { background: #334155; color: white; }
        .nav-links a.active { background: var(--primary); color: white; }

        .main-content { flex-grow: 1; overflow-y: auto; padding: 30px; }
        .chart-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; margin-bottom: 30px; }
        .card { background: var(--card); padding: 20px; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.1); }
        
        table { width: 100%; border-collapse: collapse; background: var(--card); border-radius: 12px; overflow: hidden; }
        th { background: #f8fafc; color: #64748b; text-transform: uppercase; font-size: 0.75rem; padding: 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>RemoteMonitor</h2>
        <div class="nav-links">
            <a href="LoginServlet">🏠 Dashboard</a>
            <a href="HistoryServlet" class="active">📈 Usage History</a>
            <a href="KilledHistoryServlet">📂 Killed Logs</a>
        </div>
    </div>

    <div class="main-content">
        <h2 style="margin-top: 0;">System Resource History</h2>
        
        <div class="chart-grid">
            <div class="card"><canvas id="cpuChart"></canvas></div>
            <div class="card"><canvas id="ramChart"></canvas></div>
        </div>

        <div class="card" style="padding: 0;">
            <table>
                <thead>
                    <tr><th>Timestamp</th><th>Processes</th><th>RAM (MB)</th><th>CPU (%)</th></tr>
                </thead>
                <tbody>
                    <% List<SystemMetric> list = (List<SystemMetric>) request.getAttribute("metricsList");
                       if(list != null) { for(SystemMetric m : list) { %>
                    <tr>
                        <td><%= m.getTimestamp().substring(11, 19) %></td>
                        <td><%= m.getTotalProcesses() %></td>
                        <td><%= String.format("%.1f", m.getRamUsage()) %></td>
                        <td style="font-weight:bold; color:var(--primary)"><%= m.getCpuUsage() %>%</td>
                    </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        const labels = [<% for(SystemMetric m : list) { %> "<%= m.getTimestamp().substring(11, 19) %>", <% } %>].reverse();
        const cpuData = [<% for(SystemMetric m : list) { %> <%= m.getCpuUsage() %>, <% } %>].reverse();
        const ramData = [<% for(SystemMetric m : list) { %> <%= m.getRamUsage() %>, <% } %>].reverse();

        new Chart(document.getElementById('cpuChart'), {
            type: 'line',
            data: { labels: labels, datasets: [{ label: 'CPU %', data: cpuData, borderColor: '#ef4444', tension: 0.3, fill: true, backgroundColor: 'rgba(239, 68, 68, 0.1)' }] }
        });
        new Chart(document.getElementById('ramChart'), {
            type: 'line',
            data: { labels: labels, datasets: [{ label: 'RAM MB', data: ramData, borderColor: '#3b82f6', tension: 0.3, fill: true, backgroundColor: 'rgba(59, 130, 246, 0.1)' }] }
        });
    </script>
</body>
</html>