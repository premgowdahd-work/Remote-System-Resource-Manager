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
        
        // Schedule the task to run every 1 minute
        scheduler.scheduleAtFixedRate(() -> {
            try {
                captureAndStoreMetrics();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }, 0, 1, TimeUnit.MINUTES);
    }

    private static void captureAndStoreMetrics() {
        // Get real CPU Load
        float realCpu = ProcessManager.getTotalCpuLoad();
        
        List<ProcessInfo> processes = ProcessManager.getAllProcesses();
        int totalProcs = processes.size();
        double totalRam = processes.stream().mapToDouble(ProcessInfo::getRamUsage).sum();

        String sql = "INSERT INTO system_metrics (total_cpu_usage, used_ram_mb, total_processes) VALUES (?, ?, ?)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setFloat(1, realCpu); // Now using real data!
            ps.setDouble(2, totalRam);
            ps.setInt(3, totalProcs);
            ps.executeUpdate();
            
            System.out.println("[Monitor] Persisted CPU: " + realCpu + "%");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void stopMonitoring() {
        if (scheduler != null) scheduler.shutdown();
    }
}