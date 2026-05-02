# Remote Process & System Resource Management System

A professional, web-based administration suite designed for real-time monitoring and remote management of host system processes. This open-source tool bridges the gap between low-level OS metrics and high-level web interfaces, allowing administrators to monitor system health and terminate runaway processes remotely.

---

## 1. Project Gallery

### Admin Dashboard
The central command center showing live processes sorted by CPU intensity with a fixed navigation sidebar.
![Dashboard](pic/dashboard.png)

### Authentication Portal
Secure entry point for administrative access.
![Login](pic/login.png)

### Usage History & Trends
Visual tracking of CPU and RAM performance over time using Chart.js.
![Usage History](pic/usage_history.png)

### Process Control
Direct interface for terminating specific system processes.
![Kill Process](pic/kill_process.png)

### Audit Logs
A historical record of terminated processes for security auditing.
![Kill Logs](pic/kill_logs.png)

---

## 2. Prerequisites
Before you begin, ensure you have the following installed on your Windows machine:
*   **Java JDK 17 or higher** (e.g., OpenJDK or Oracle JDK)
*   **Apache Tomcat 9.0** (The web server to run the application)
*   **MySQL Server 8.0** (To store metrics and logs)
*   **IDE** (Eclipse Enterprise Edition or IntelliJ IDEA is recommended)
*   **Web Browser** (Chrome, Firefox, or Edge)

---

## 3. Database Setup (Crucial)
1.  Open **MySQL Workbench** or your preferred SQL terminal.
2.  Locate the `database_setup.sql` file in the project root.
3.  Copy the contents and run the entire script. 
    *   This will create a database named `remote_mgmt`.
    *   It will create the tables: `admins`, `system_metrics`, and `system_logs`.
    *   It will insert a default admin: **Username:** `admin` | **Password:** `admin123`.

---

## 4. Local Configuration
To connect the Java code to your local database:
1.  Navigate to `src/main/java/app/`.
2.  Create a new file named `db.properties` (if it doesn't exist).
3.  Paste the following and update the password to match your MySQL password:
    ```properties
    db.url=jdbc:mysql://localhost:3306/remote_mgmt
    db.user=root
    db.password=YOUR_MYSQL_PASSWORD_HERE
    ```

---

## 5. Installation & Deployment
1.  **Import Project**: Open your IDE and import this folder as an "Existing Maven Project" or "Dynamic Web Project".
2.  **Add Library**: Ensure `mysql-connector-j.jar` is present in `src/main/webapp/WEB-INF/lib/`.
3.  **Server Setup**:
    *   Right-click the project -> **Run As** -> **Run on Server**.
    *   Select **Apache Tomcat v9.0**.
    *   Click **Finish**.
4.  **Access the Site**: Open your browser and go to:
    `http://localhost:8080/RemoteSystemManager/login.jsp`

---

## 6. Key Features & Logic
*   **Real-time Monitoring**: Uses Windows PowerShell/WMI queries to fetch actual hardware usage data.
*   **Auto-Cleaning Logs**: The system includes built-in Java logic that automatically deletes older data to keep only the last 20 records in the database, ensuring high performance.
*   **Secure Kill**: Terminating a process sends a `taskkill` command to the OS and logs the action for audit purposes.
*   **Responsive UI**: Fixed sidebar layout ensures that "Refresh" and "Logout" are always accessible without scrolling.

---

## 7. Troubleshooting
*   **Login Fails**: Ensure your MySQL service is running and the `db.properties` credentials are correct.
*   **Metrics Not Showing**: This project is designed for **Windows**. High-accuracy metrics rely on PowerShell; ensure your execution policy allows local scripts.
*   **404 Error**: Make sure your Tomcat "Context Path" is set to `/RemoteSystemManager`.

---

## 8. License
This project is released under the **MIT License**. You are free to use, modify, and distribute this software for educational and professional purposes.
