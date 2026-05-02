package app;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

public class BackgroundMonitor {
    private static ScheduledExecutorService scheduler;

    public static void startMonitoring() {
        scheduler = Executors.newSingleThreadScheduledExecutor();
        scheduler.scheduleAtFixedRate(() -> {
            try {
                captureAndStoreMetrics();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 1, TimeUnit.MINUTES);
    }

    private static void captureAndStoreMetrics() {
        float realCpu = ProcessManager.getTotalCpuLoad();
        List<ProcessInfo> processes = ProcessManager.getAllProcesses();
        int totalProcs = processes.size();
        double totalRam = processes.stream().mapToDouble(ProcessInfo::getRamUsage).sum();

        String insertSql = "INSERT INTO system_metrics (total_cpu_usage, used_ram_mb, total_processes) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            // 1. Insert New Metric
            try (PreparedStatement ps = con.prepareStatement(insertSql)) {
                ps.setFloat(1, realCpu);
                ps.setDouble(2, totalRam);
                ps.setInt(3, totalProcs);
                ps.executeUpdate();
            }

            // 2. Perform Cleanup (Keep only last 20)
            cleanupOldMetrics(con);
            
            System.out.println("[Monitor] Persisted & Cleaned Metrics. CPU: " + realCpu + "%");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void cleanupOldMetrics(Connection con) throws Exception {
        // Subquery approach to delete all but the top 20 latest entries
        String deleteSql = "DELETE FROM system_metrics WHERE metric_id NOT IN (" +
                           "SELECT metric_id FROM (SELECT metric_id FROM system_metrics " +
                           "ORDER BY timestamp DESC LIMIT 20) AS tmp)";
        try (PreparedStatement ps = con.prepareStatement(deleteSql)) {
            ps.executeUpdate();
        }
    }

    public static void stopMonitoring() {
        if (scheduler != null) scheduler.shutdown();
    }
}