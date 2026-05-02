---

## ⚠️ Troubleshooting
*   **404 Error**: Ensure your Tomcat server is running and the project is properly deployed.
*   **SQL Exception**: Double-check your `db.properties` file for the correct password and port (3306).
*   **No Data in Charts**: Wait at least 1-2 minutes after starting the server for the background monitor to capture the first few data points.

---

## 📜 License
Distributed under the **MIT License**. This project is open-source and free to use for educationalThis README is designed to be a comprehensive, step-by-step guide. It assumes the reader has just installed a code editor and a database and needs a "zero-to-one" path to get the **Remote Process & System Resource Management System** running.

***

# Remote Process & System Resource Management System

A robust, enterprise-grade web interface designed for real-time monitoring and administrative control of host system resources. This project bridges low-level Windows OS metrics with a modern, high-performance web dashboard.

---

## 📸 Project Gallery

### 1. Admin Dashboard
The primary command center. It displays all active processes sorted by CPU usage with real-time system health metrics at the top.
![Dashboard](pic/dashboard.png)

### 2. Authentication Portal
A secure, minimalist entry point for system administrators.
![Login](pic/login.png)

### 3. Usage History & Analytics
Visualizes CPU and RAM trends over the last 20 minutes using interactive line charts.
![Usage History](pic/usage_history.png)

### 4. Process Control (Task Kill)
Allows administrators to terminate unresponsive or high-resource processes with a single click and a safety confirmation.
![Kill Process](pic/kill_process.png)

### 5. Audit Logs
A persistent historical record of every process terminated via the system, ensuring accountability.
![Kill Logs](pic/kill_logs.png)

---

## 🛠 Tech Stack & Requirements

### Software Requirements:
*   **Operating System**: Windows (Required for WMI/PowerShell integration).
*   **Java Development Kit (JDK)**: Version 17 or higher (Java 25 recommended).
*   **Web Server**: Apache Tomcat 9.0.
*   **Database**: MySQL Server 8.0.
*   **IDE**: Eclipse IDE for Enterprise Java (or IntelliJ IDEA).

### Libraries Included:
*   **MySQL Connector J**: For Database connectivity.
*   **Chart.js**: For frontend data visualization.
*   **Google Inter Fonts**: For modern UI typography.

---

## 🚀 Step-by-Step Installation Guide

### Step 1: Database Setup
1.  Open **MySQL Workbench** and log in to your local instance.
2.  Open the file `database_setup.sql` provided in this repository.
3.  Run the entire script (Click the lightning bolt icon).
    *   *What this does:* It creates a database named `remote_mgmt`, sets up the `admins` table, `system_metrics` table, and `system_logs` table, and inserts a default admin user.
4.  **Default Credentials**: 
    *   **Username**: `admin`
    *   **Password**: `admin123`

### Step 2: Configure Database Credentials
For security, the project uses a properties file to connect to your database.
1.  Navigate to `src/main/java/app/`.
2.  Create a new file named `db.properties` (if it doesn't exist).
3.  Paste the following and update with your MySQL password:
    ```properties
    db.url=jdbc:mysql://localhost:3306/remote_mgmt
    db.user=root
    db.password=YOUR_MYSQL_PASSWORD_HERE
    ```

### Step 3: Project Import (Eclipse)
1.  Open **Eclipse IDE**.
2.  Go to `File` > `Import` > `General` > `Existing Projects into Workspace`.
3.  Select the root folder of this project.
4.  Right-click the project name in the Project Explorer and select `Build Path` > `Configure Build Path`.
5.  In the **Libraries** tab, ensure `mysql-connector-j-x.x.x.jar` is present. If not, add it from `src/main/webapp/WEB-INF/lib/`.

### Step 4: Server Deployment
1.  Go to the **Servers** tab at the bottom of Eclipse.
2.  Right-click > `New` > `Server`.
3.  Select **Apache Tomcat v9.0**.
4.  Add your project to the "Configured" column and click **Finish**.
5.  Right-click the Tomcat server and select **Start**.

### Step 5: Accessing the Application
Open your browser and enter the following URL:
`http://localhost:8080/RemoteSystemManager/login.jsp`

---

## ⚙️ How the System Works

### 1. Data Capture (The Monitor)
The system starts a `BackgroundMonitor` thread upon deployment. Every 60 seconds, it executes a hidden PowerShell command to fetch total system CPU load and RAM usage. This data is stored in the MySQL database.

### 2. Auto-Maintenance (Self-Cleaning)
To prevent your database from becoming bloated, the Java backend automatically performs a "Retention Cleanup." 
*   Whenever a new metric or log is added, the system checks the count. 
*   It automatically deletes the oldest records, keeping only the **latest 20 entries**.

### 3. Process Management
When you click **"Kill"** on the dashboard:
1.  The `KillServlet` receives the Process ID (PID).
2.  It executes a `taskkill` command at the OS level.
3.  It logs the success of this action into the `system_logs` table.
4.  It refreshes the dashboard to show the updated process list.

---

## 📁 Project Structure
```text
RemoteSystemManager/
├── src/main/java/app/          # Backend Servlets, Logic, & DB Config
├── src/main/webapp/            # Frontend JSPs and CSS
│   ├── pic/                    # UI Screenshots for Documentation
│   ├── WEB-INF/lib/            # Database Connectors (JAR files)
├── database_setup.sql          # Database Schema and Initial Data
└── README.md                   # Comprehensive Project Guide
