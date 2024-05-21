package final_project;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class WorkoutRepository {
    private JDBCConnector jdbcConnector;

    public WorkoutRepository() {
        this.jdbcConnector = new JDBCConnector(); // Ensure JDBCConnector is properly configured.
    }

    public WorkoutModel findWorkoutByID(String workoutID) {
        // Directly return the result of the JDBCConnector's findWorkoutByID
        return jdbcConnector.findWorkoutByID(workoutID);
    }

    public List<WorkoutModel> findAllWorkouts() {
        // Directly return the result of the JDBCConnector's findAllWorkouts
        return jdbcConnector.findAllWorkouts();
    }

    public boolean deleteWorkoutByID(String workoutID) {
        // Call the deleteWorkoutByID method of JDBCConnector and check result
        int result = jdbcConnector.deleteWorkoutByID(workoutID);
        return result > 0;
    }

    public boolean deleteUserWorkoutByID(String workoutID, String UserID) {
        // Call the deleteWorkoutByID method of JDBCConnector and check result
        int result = jdbcConnector.deleteUserWorkoutByID(workoutID, UserID);
        return result > 0;
    }

    public List<WorkoutModel> findWorkoutsByUserID(String userID) {
        return jdbcConnector.findWorkoutsByUserID(userID);
    }

    public boolean saveUserWorkout(String userID, String workoutID) {
        int result = jdbcConnector.saveUserWorkout(workoutID, userID);
        return result > 0;
    }

    public WorkoutModel findUserWorkoutByID(String userID) {
        return jdbcConnector.findUserWorkoutByID (userID);  
    }

    public WorkoutModel findWorkoutByName(String workoutName) {
        return jdbcConnector.findWorkoutByName(workoutName);  
    }

    public boolean logWorkout(String userID, String workoutID, String date) {
        return jdbcConnector.logWorkout(userID, workoutID, date);
    }
    
}
