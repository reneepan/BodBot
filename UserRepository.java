package final_project;

public class UserRepository {
    private JDBCConnector jdbcConnector;

    public UserRepository() {
        this.jdbcConnector = new JDBCConnector();
    }

    public UserModel findUserByEmail(String email) {
        return jdbcConnector.findUserByEmail(email);
    }

    public UserModel findUserByID(String userID) {
        return jdbcConnector.findUserByID(userID);
    }

    public boolean saveUserInfoToDatabase(String email, String username, String goals, String hashedPassword, String birthday) {
        int result = jdbcConnector.saveUserInfoToDatabase(email, username, goals, hashedPassword, birthday);
        return result > 0;
    }
}
