<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, app.ProcessInfo" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Console | Remote Process Manager</title>
    <style>
        :root {
            --primary: #2563eb;
            --danger: #ef4444;
            --bg: #f8fafc;
            --card: #ffffff;
            --text: #1e293b;
        }

        body { 
            font-family: 'Inter', system-ui, sans-serif; 
            background-color: var(--bg); 
            color: var(--text);
            margin: 0;
            display: flex;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar Navigation */
        .sidebar {
            width: 260px;
            background: #1e293b;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 20px;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar h2 { font-size: 1.2rem; margin-bottom: 30px; color: #38bdf8; }

        .nav-links { display: flex; flex-direction: column; gap: 10px; flex-grow: 1; }
        
        .nav-links a {
            text-decoration: none;
            color: #cbd5e1;
            padding: 12px 15px;
            border-radius: 8px;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-links a:hover { background: #334155; color: white; }
        .nav-links a.active { background: var(--primary); color: white; }

        /* Main Content Area */
        .main-content {
            flex-grow: 1;
            overflow-y: auto;
            display: flex;
            flex-direction: column;
        }

        /* Top Bar - Fixed Header */
        .header {
            background: var(--card);
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .stats-container { display: flex; gap: 20px; }
        .stat-pill {
            background: #f1f5f9;
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 0.9rem;
            font-weight: 600;
        }

        /* Table Styling */
        .table-container { padding: 30px; }
        table { 
            width: 100%; 
            border-collapse: separate; 
            border-spacing: 0;
            background: var(--card);
            border-radius: 12px;
            overflow: hidden;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        th { 
            background: #f8fafc; 
            color: #64748b; 
            text-transform: uppercase;
            font-size: 0.75rem;
            letter-spacing: 0.05em;
            padding: 15px; 
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        td { padding: 15px; border-bottom: 1px solid #f1f5f9; font-size: 0.9rem; }
        
        tr:hover { background-color: #f8fafc; }

        .kill-btn { 
            color: var(--danger); 
            text-decoration: none; 
            font-weight: bold;
            padding: 6px 12px;
            border: 1px solid var(--danger);
            border-radius: 6px;
            transition: 0.2s;
        }

        .kill-btn:hover { background: var(--danger); color: white; }

        .logout-btn {
            color: #94a3b8;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }
        .logout-btn:hover { color: var(--danger); }
    </style>
</head>
<body>

    <!-- Fixed Sidebar -->
    <div class="sidebar">
        <h2>RemoteMonitor v1.0</h2>
        <div class="nav-links">
            <a href="LoginServlet" class="active">🏠 Dashboard</a>
            <a href="HistoryServlet">📈 Usage History</a>
            <a href="KilledHistoryServlet">📂 Killed Logs</a>
        </div>
        <div style="border-top: 1px solid #334155; padding-top: 20px;">
            <p style="font-size: 0.8rem; color: #94a3b8;">User: <%= session.getAttribute("user") %></p>
            <a href="logout.jsp" class="logout-btn">🔴 Logout System</a>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-content">
        <div class="header">
            <div class="stats-container">
                <div class="stat-pill">CPU: <span style="color: var(--primary);"><%= request.getAttribute("totalCpu") != null ? request.getAttribute("totalCpu") : "..." %>%</span></div>
                <div class="stat-pill">Processes: <span style="color: var(--primary);"><%= ((List)request.getAttribute("processList")).size() %></span></div>
            </div>
            <button onclick="location.href='LoginServlet'" 
                style="padding: 10px 20px; background-color: var(--primary); color: white; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;">
                🔄 Refresh Data
            </button>
        </div>

        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>PID</th>
                        <th>Process Name</th>
                        <th>CPU Usage</th>
                        <th>RAM Usage</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        List<ProcessInfo> list = (List<ProcessInfo>) request.getAttribute("processList");
                        if(list != null) {
                            for(ProcessInfo p : list) {
                    %>
                    <tr>
                        <td><strong><%= p.getPid() %></strong></td>
                        <td><%= p.getName() %></td>
                        <td><span style="color: <%= p.getCpuUsage() > 10 ? "#ef4444" : "#10b981" %>; font-weight: bold;">
                            <%= String.format("%.1f", p.getCpuUsage()) %>%</span>
                        </td>
                        <td><%= p.getRamUsage() %> MB</td>
                        <td><a href="KillServlet?pid=<%= p.getPid() %>" class="kill-btn" onclick="return confirm('Kill process <%= p.getPid() %>?')">Kill</a></td>
                    </tr>
                    <% 
                            }
                        } else { 
                    %>
                    <tr><td colspan="5" style="text-align: center;">No active processes found.</td></tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>