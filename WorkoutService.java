package final_project;

import java.util.List;

public class WorkoutService {
    private WorkoutRepository workoutRepository;

    public WorkoutService(WorkoutRepository workoutRepository) {
        this.workoutRepository = workoutRepository;
    }

    public List<WorkoutModel> getAllWorkouts() {
        // Retrieve all workouts, typically for guest users
        return workoutRepository.findAllWorkouts();
    }

    public List<WorkoutModel> getUserSpecificWorkouts(String userID) {
        // This method assumes a mapping of users to specific workouts, which should be implemented in the repository
        // For the sake of this example, let's assume it returns a list of workouts for a specific user
        // Assuming 'findWorkoutByID' is not the correct method since it returns a single workout,
        // You might need a method like 'findWorkoutsByUserID' in the WorkoutRepository
        return workoutRepository.findWorkoutsByUserID(userID);
    }

    public boolean deleteWorkoutByID(String workoutID) {
        // Call the deleteWorkoutByID method of JDBCConnector and check result
        return workoutRepository.deleteWorkoutByID(workoutID);
    }

    public boolean deleteUserWorkoutByID(String workoutID, String UserID) {
        return workoutRepository.deleteUserWorkoutByID(workoutID, UserID);
    }

    public boolean logUserWorkout(String userID, String workoutID) {
        return workoutRepository.saveUserWorkout(userID, workoutID);
    }

    public WorkoutModel findUserWorkoutByID(String userID) {
         return workoutRepository.findUserWorkoutByID(userID);   
    }

    public WorkoutModel findWorkoutByName(String workoutName) {
        return workoutRepository.findWorkoutByName(workoutName);   
    }

    public WorkoutModel findWorkoutById(String workoutID) {
        return workoutRepository.findWorkoutByID(workoutID);
    }

    public boolean logWorkout(String userID, String workoutID, String time) {
        return workoutRepository.logWorkout(userID, workoutID, time);
    }

}
