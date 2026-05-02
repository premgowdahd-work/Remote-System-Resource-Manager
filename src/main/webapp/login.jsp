<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | Remote Monitor</title>
    <style>
        body { font-family: 'Inter', sans-serif; background: #f8fafc; height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
        .card { background: white; padding: 2.5rem; border-radius: 12px; box-shadow: 0 10px 15px -3px rgba(0,0,0,0.1); width: 320px; text-align: center; }
        h2 { color: #1e293b; margin-bottom: 1.5rem; font-size: 1.25rem; }
        input { width: 100%; padding: 12px; margin: 8px 0; border: 1px solid #e2e8f0; border-radius: 6px; box-sizing: border-box; }
        button { width: 100%; padding: 12px; background: #2563eb; color: white; border: none; border-radius: 6px; cursor: pointer; font-weight: 600; transition: background 0.2s; }
        button:hover { background: #1d4ed8; }
        .error { color: #ef4444; font-size: 0.85rem; margin-top: 1rem; }
    </style>
</head>
<body>
    <div class="card">
        <h2>Admin Portal</h2>
        <form action="LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username" required autocomplete="off">
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Access Console</button>
        </form>
        <% if(request.getParameter("error") != null) { %>
            <p class="error">Invalid credentials.</p>
        <% } %>
    </div>
</body>
</html>