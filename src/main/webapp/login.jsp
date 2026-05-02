<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Remote System Login</title>
    <style>
        body { font-family: sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f4f4; }
        .login-container { background: white; padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
        input { display: block; width: 100%; margin: 10px 0; padding: 8px; }
        button { width: 100%; padding: 10px; background: #007bff; color: white; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Admin Login</h2>
        <!-- The 'action' matches the @WebServlet annotation in LoginServlet[cite: 1] -->
        <form action="LoginServlet" method="post">
            <input type="text" name="username" placeholder="Username" required>
            <input type="password" name="password" placeholder="Password" required>
            <button type="submit">Access Console</button>
        </form>
        <% if(request.getParameter("error") != null) { %>
            <p style="color:red;">Invalid credentials. Try again.</p>
        <% } %>
    </div>
</body>
</html>