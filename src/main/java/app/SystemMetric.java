package app;

public class SystemMetric {
    private int metricId;
    private float cpuUsage;
    private double ramUsage;
    private int totalProcesses;
    private String timestamp;

    // Getters and Setters
    public int getMetricId() { return metricId; }
    public void setMetricId(int metricId) { this.metricId = metricId; }
    public float getCpuUsage() { return cpuUsage; }
    public void setCpuUsage(float cpuUsage) { this.cpuUsage = cpuUsage; }
    public double getRamUsage() { return ramUsage; }
    public void setRamUsage(double ramUsage) { this.ramUsage = ramUsage; }
    public int getTotalProcesses() { return totalProcesses; }
    public void setTotalProcesses(int totalProcesses) { this.totalProcesses = totalProcesses; }
    public String getTimestamp() { return timestamp; }
    public void setTimestamp(String timestamp) { this.timestamp = timestamp; }
}