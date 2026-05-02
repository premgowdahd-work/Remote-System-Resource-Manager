# REMOTE PROCESS & SYSTEM RESOURCE MANAGEMENT SYSTEM

## 1. Project Overview
A web-based administration suite designed for real-time monitoring and remote management of host system processes. This project focuses on bridging the gap between low-level OS metrics and high-level web interfaces, developed for the 6th-semester Bachelor of Engineering (CSE) curriculum at SKIT under the VTU 2022 Scheme.

## 2. Core Features
- **Performance-First Dashboard**: Displays all active processes automatically sorted by descending CPU usage to identify resource-heavy applications immediately.
- **Dynamic Resource Visualization**: Features dual-line charts that track CPU load (%) and RAM consumption (MB) over time, utilizing Chart.js for interactive data rendering.
- **Remote Termination**: Securely kill runaway or unresponsive processes by PID directly from the web browser.
- **System Health Auditing**: 
    - Metrics History: Logs system-wide resource snapshots every 60 seconds.
    - Killed Process Log: Maintains a persistent audit trail of every process terminated via the console.
- **Hardware Integration**: Leverages Windows PowerShell and WMI (Windows Management Instrumentation) to fetch accurate, real-time hardware performance counters.

## 3. Tech Stack
- **Languages**: Java 25 (JDK), SQL, JavaScript, HTML5/CSS3.
- **Backend**: Java Servlets (JSP/Servlets), JDBC.
- **Server**: Apache Tomcat 9.0.
- **Database**: MySQL 8.0.
- **Libraries**: Chart.js (CDN), MySQL Connector/J.

## 4. Security & Configuration
- **Credential Masking**: Sensitive database passwords are managed via an external `db.properties` file which is excluded from version control for security.
- **State Management**: Uses session-based authentication to ensure only authorized administrators can access the monitoring tools.

## 5. Installation & Local Setup
1. **Database**: 
   - Execute the `database_setup.sql` file in your MySQL environment to create the schema and initial admin user.
2. **Environment Config**:
   - Create `src/main/java/app/db.properties`.
   - Add your local credentials:
     ```properties
     db.url=jdbc:mysql://localhost:3306/remote_mgmt
     db.user=root
     db.password=your_password
     ```
3. **Dependencies**: Ensure `mysql-connector-j.jar` is located in `src/main/webapp/WEB-INF/lib/`.
4. **Deployment**: Clean the project in Eclipse, add to Tomcat 9.0, and navigate to:
   `http://localhost:8080/RemoteSystemManager`

## 6. License
MIT License

Copyright (c) 2026

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.