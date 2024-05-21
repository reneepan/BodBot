package final_project;

import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.Date;


public class JDBCConnector {
    private Connection connection;
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String CONNECTION_URL = "jdbc:mysql://localhost:3306/BodBot?user=root&password=password";

    static {
        try {
            Class.forName(DRIVER);
            System.out.println("Driver loaded successfully");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new ExceptionInInitializerError(e); // Throw error to halt the application startup
        }
    }
    
    public JDBCConnector() {
        try {
            this.connection = DriverManager.getConnection(CONNECTION_URL);
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Use prepared statements to execute SQL queries securely
    private PreparedStatement prepareStatement(String query, String... params) throws SQLException {
        PreparedStatement ps = connection.prepareStatement(query);
        for (int i = 0; i < params.length; i++) {
            ps.setString(i + 1, params[i]);
        }
        return ps;
    }

    public WorkoutModel findWorkoutByID(String workoutID) {
        try {
            String query = "SELECT * FROM Workouts WHERE WorkoutID = ?";
            PreparedStatement ps = prepareStatement(query, workoutID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new WorkoutModel(
                    rs.getString("WorkoutID"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getString("Type"),
                    rs.getString("BodyPart"),
                    rs.getString("Level"),
                    rs.getString("Equipment")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<WorkoutModel> findAllWorkouts() {
        List<WorkoutModel> workouts = new ArrayList<>();
        try {
            String query = "SELECT * FROM Workouts";
            PreparedStatement ps = prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                workouts.add(new WorkoutModel(
                    rs.getString("WorkoutID"),
                    rs.getString("Name"),
                    rs.getString("Description"),
                    rs.getString("Type"),
                    rs.getString("BodyPart"),
                    rs.getString("Level"),
                    rs.getString("Equipment")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return workouts;
    }

    public int saveUserWorkout(String workoutID, String userID) {
        try {
            String query = "INSERT INTO UserWorkouts(WorkoutID, UserID, Date) VALUES(?, ?, ?)";
            String currentTime = currentTimestamp();
            PreparedStatement ps = prepareStatement(query, workoutID, userID, currentTime);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int deleteWorkoutByID(String workoutID) {
        try {
            String query = "DELETE FROM Workouts WHERE WorkoutID = ?";
            PreparedStatement ps = prepareStatement(query, workoutID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    
   // User-related methods
    public UserModel findUserByEmail(String email) {
        String query = "SELECT * FROM Users WHERE Email = ?";
        try (PreparedStatement ps = prepareStatement(query, email);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new UserModel(
                    rs.getString("UserID"),
                    rs.getString("Email"),
                    rs.getString("Username"),
                    rs.getString("Goals"),
                    rs.getString("Password"),
                    rs.getString("Birthday")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserModel findUserByUsername(String username) {
        String query = "SELECT * FROM Users WHERE username = ?";
        try (PreparedStatement ps = prepareStatement(query, username);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new UserModel(
                    rs.getString("UserID"),
                    rs.getString("Email"),
                    rs.getString("Username"),
                    rs.getString("Goals"),
                    rs.getString("Password"),
                    rs.getString("Birthday")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public UserModel findUserByID(String userID) {
        String query = "SELECT * FROM Users WHERE UserID = ?";
        try (PreparedStatement ps = prepareStatement(query, userID);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return new UserModel(
                    rs.getString("UserID"),
                    rs.getString("Email"),
                    rs.getString("Username"),
                    rs.getString("Goals"),
                    rs.getString("Password"),
                    rs.getString("Birthday")
                );
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public int saveUserInfoToDatabase(String email, String username, String goals, String hashedPassword, String birthday) {
        String query = "INSERT INTO Users(Username, Email, Password, Birthday, Goals) VALUES(?, ?, ?, ?, ?)";
        try (PreparedStatement ps = prepareStatement(query, username, email, hashedPassword, birthday, goals)) {
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public List<WorkoutModel> findWorkoutsByUserID(String userID) {
        List<WorkoutModel> workouts = new ArrayList<>();
        String query = "SELECT w.* FROM Workouts w " +
                       "JOIN UserWorkouts uw ON w.workoutID = uw.WorkoutID " +
                       "WHERE uw.UserID = ?";
        try (PreparedStatement ps = prepareStatement(query, userID);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                workouts.add(new WorkoutModel(
                    rs.getString("workoutID"),
                    rs.getString("name"),
                    rs.getString("description"),
                    rs.getString("type"),
                    rs.getString("BodyPart"),
                    rs.getString("level"),
                    rs.getString("equipment")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return workouts;
    }

    public int deleteUserWorkoutByID(String workoutID, String UserID) {
        try {
            String query = "DELETE FROM UserWorkouts WHERE WorkoutID = ? AND UserID = ?";
            PreparedStatement ps = prepareStatement(query, workoutID, UserID);
            return ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }
    

     public WorkoutModel findUserWorkoutByID(String userID) {
        WorkoutModel workout = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM Workouts " +
                "INNER JOIN UserWorkouts ON Workouts.WorkoutID = UserWorkouts.WorkoutID " +
                "WHERE UserWorkouts.UserID = ?";
        stmt = connection.prepareStatement(sql);
        stmt.setString(1, userID);
        rs = stmt.executeQuery();

        if (rs.next()) {
            String workoutID = rs.getString("WorkoutID");
            String name = rs.getString("Name");
            String description = rs.getString("Description");
            String bodyPart = rs.getString("BodyPart");
            String equipment = rs.getString("Equipment");
            String type = rs.getString("Type");
            String level = rs.getString("Level");

            workout = new WorkoutModel(workoutID, name, description, type, bodyPart, level, equipment);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return workout;
}

    public String currentTimestamp() {
        Date now = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formattedDate = formatter.format(now);
        return formattedDate;
    }

    public WorkoutModel findWorkoutByName(String workoutName) {
        WorkoutModel workout = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            String sql = "SELECT * FROM Workouts WHERE Name = ?";
            stmt = connection.prepareStatement(sql);
            stmt.setString(1, workoutName);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String workoutID = rs.getString("WorkoutID");
                String name = rs.getString("Name");
                String description = rs.getString("Description");
                String type = rs.getString("Type");
                String bodyPart = rs.getString("BodyPart");
                String level = rs.getString("Level");
                String equipment = rs.getString("Equipment");

                workout = new WorkoutModel(workoutID, name, description, type, bodyPart, level, equipment);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } 
        return workout;
    }

    public boolean logWorkout(String userID, String workoutID, String date) {
        try {
            String query = "INSERT INTO WorkoutLogs (UserID, WorkoutID, Date) VALUES (?, ?, ?)";
            PreparedStatement ps = prepareStatement(query, userID, workoutID, date);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    

}
