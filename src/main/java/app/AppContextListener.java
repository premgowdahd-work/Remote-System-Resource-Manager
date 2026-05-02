package app;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("Web Application Starting... Initializing Monitor.");
        BackgroundMonitor.startMonitoring();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("Web Application Stopping... Shutting down Monitor.");
        BackgroundMonitor.stopMonitoring();
    }
}