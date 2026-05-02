package app;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Properties;

public class DBConnection {
    private static Connection con = null;

    public static Connection getConnection() {
        try {
            if (con == null || con.isClosed()) {
                Properties props = new Properties();
                
                // Loading the file from the same package as this class
                try (InputStream is = DBConnection.class.getResourceAsStream("db.properties")) {
                    if (is == null) {
                        throw new RuntimeException("db.properties not found in app package!");
                    }
                    props.load(is);
                }

                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection(
                    props.getProperty("db.url"),
                    props.getProperty("db.user"),
                    props.getProperty("db.password")
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return con;
    }
}