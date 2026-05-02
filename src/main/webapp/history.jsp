<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, app.SystemMetric" %>
<!DOCTYPE html>
<html>
<head>
    <title>System History Log</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; padding: 30px; background-color: #f4f7f6; }
        .container { max-width: 900px; margin: auto; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th { background-color: #2c3e50; color: white; padding: 12px; text-align: left; }
        td { padding: 12px; border-bottom: 1px solid #eee; }
        tr:hover { background-color: #f9f9f9; }
        .back-link { display: inline-block; margin-bottom: 20px; text-decoration: none; color: #3498db; font-weight: bold; }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
    <div class="container">
        <a href="LoginServlet" class="back-link">← Back to Dashboard</a>
        <h2>System Resource History (Last 20 Samples)</h2>
        
        <div class="container" style="display: flex; gap: 20px; margin-bottom: 20px;">
    <div style="flex: 1; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
        <h4 style="text-align: center;">CPU Usage Trend (%)</h4>
        <canvas id="cpuChart"></canvas>
    </div>
    <div style="flex: 1; background: white; padding: 15px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
        <h4 style="text-align: center;">RAM Usage Trend (MB)</h4>
        <canvas id="ramChart"></canvas>
    </div>
	</div>
        
        
        
        <table>
            <thead>
                <tr>
                    <th>Timestamp</th>
                    <th>Total Processes</th>
                    <th>Total RAM Usage (MB)</th>
                    <th>Avg CPU (%)</th>
                </tr>
            </thead>
            <tbody>
                <%
                    List<SystemMetric> list = (List<SystemMetric>) request.getAttribute("metricsList");
                    if(list != null && !list.isEmpty()) {
                        for(SystemMetric m : list) {
                %>
                <tr>
                    <td><%= m.getTimestamp() %></td>
                    <td><%= m.getTotalProcesses() %></td>
                    <td><%= String.format("%.2f", m.getRamUsage()) %> MB</td>
                    <td><%= m.getCpuUsage() %>%</td>
                </tr>
                <% 
                        }
                    } else { 
                %>
                <tr><td colspan="4" style="text-align:center;">No historical data available yet. Wait for the background monitor to run.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
<script>
//Prepare Data from Java List
const labels = [<% for(SystemMetric m : list) { %> "<%= m.getTimestamp().substring(11, 19) %>", <% } %>].reverse();
const cpuData = [<% for(SystemMetric m : list) { %> <%= m.getCpuUsage() %>, <% } %>].reverse();
const ramData = [<% for(SystemMetric m : list) { %> <%= m.getRamUsage() %>, <% } %>].reverse();

// CPU Chart Configuration
new Chart(document.getElementById('cpuChart'), {
    type: 'line',
    data: {
        labels: labels,
        datasets: [{
            label: 'CPU %',
            data: cpuData,
            borderColor: '#e74c3c',
            backgroundColor: 'rgba(231, 76, 60, 0.1)',
            fill: true,
            tension: 0.3
        }]
    },
    options: { scales: { y: { beginAtZero: true, max: 100 } } }
});

// RAM Chart Configuration
new Chart(document.getElementById('ramChart'), {
    type: 'line',
    data: {
        labels: labels,
        datasets: [{
            label: 'RAM (MB)',
            data: ramData,
            borderColor: '#3498db',
            backgroundColor: 'rgba(52, 152, 219, 0.1)',
            fill: true,
            tension: 0.3
        }]
    }
});
</script>
</html>