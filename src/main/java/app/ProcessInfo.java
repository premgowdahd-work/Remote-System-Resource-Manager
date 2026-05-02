package app;

public class ProcessInfo {
    private int pid;
    private String name;
    private double cpuUsage;
    private double ramUsage;

    // Explicit Default Constructor
    public ProcessInfo() {}

    // Getters and Setters
    public int getPid() { return pid; }
    public void setPid(int pid) { this.pid = pid; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public double getCpuUsage() { return cpuUsage; }
    public void setCpuUsage(double cpuUsage) { this.cpuUsage = cpuUsage; }

    public double getRamUsage() { return ramUsage; }
    public void setRamUsage(double ramUsage) { this.ramUsage = ramUsage; }
}