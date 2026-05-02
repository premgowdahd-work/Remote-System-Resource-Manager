package app;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.List;

public class ProcessManager {
	public static List<ProcessInfo> getAllProcesses() {
	    List<ProcessInfo> list = new ArrayList<>();
	    try {
	        // PowerShell command to get PID, Name, WorkingSet (RAM), and PercentProcessorTime (CPU)
	        String command = "powershell -Command \"Get-WmiObject Win32_PerfFormattedData_PerfProc_Process | Select-Object IDProcess, Name, @{Name='CPU';Expression={$_.PercentProcessorTime}}, @{Name='RAM';Expression={[math]::round($_.WorkingSetPrivate / 1mb, 2)}} | ConvertTo-Csv -NoTypeInformation\"";
	        
	        Process process = Runtime.getRuntime().exec(command);
	        java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()));
	        
	        String line;
	        reader.readLine(); // Skip the CSV header row
	        
	        while ((line = reader.readLine()) != null) {
	            String[] parts = line.replace("\"", "").split(",");
	            if (parts.length >= 4) {
	                // Ignore the "Idle" and "Total" rows Windows generates
	                String name = parts[1];
	                if (name.equalsIgnoreCase("_Total") || name.equalsIgnoreCase("Idle")) continue;

	                ProcessInfo p = new ProcessInfo();
	                p.setPid(Integer.parseInt(parts[0]));
	                p.setName(name);
	                p.setCpuUsage(Double.parseDouble(parts[2]));
	                p.setRamUsage(Double.parseDouble(parts[3]));
	                list.add(p);
	                list.sort((p1, p2) -> Double.compare(p2.getCpuUsage(), p1.getCpuUsage()));
	            }
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return list;
	}
    public static float getTotalCpuLoad() {
        try {
            // Using PowerShell to get the formatted CPU Load percentage
            Process process = Runtime.getRuntime().exec("powershell -Command \"(Get-WmiObject Win32_Processor | Measure-Object -Property LoadPercentage -Average).Average\"");
            java.io.BufferedReader reader = new java.io.BufferedReader(new java.io.InputStreamReader(process.getInputStream()));
            String line = reader.readLine();
            if (line != null && !line.trim().isEmpty()) {
                return Float.parseFloat(line.trim());
            }
        } catch (Exception e) {
            System.err.println("CPU Fetch Error: " + e.getMessage());
        }
        return 0.0f;
    }
    
}