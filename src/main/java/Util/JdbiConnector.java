package Util;

import org.jdbi.v3.core.Jdbi;

public class JdbiConnector {
    private static final String URL = "jdbc:mysql://localhost:3306/movie_ticket_db?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "";

    private static Jdbi jdbi;

    public static Jdbi getJdbi() {
        if (jdbi == null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                jdbi = Jdbi.create(URL, USERNAME, PASSWORD);
            } catch (ClassNotFoundException e) {
                throw new RuntimeException("Không tìm thấy MySQL Driver", e);
            }
        }

        return jdbi;
    }
}