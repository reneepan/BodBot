package final_project;

import java.util.List;

public class WorkoutController {
    private WorkoutService workoutService;
    private WorkoutRepository workoutRepository;

    public WorkoutController() {
        workoutRepository = new WorkoutRepository();
        workoutService = new WorkoutService(workoutRepository);
    }

    public List<WorkoutModel> getAllWorkouts() {
        return workoutService.getAllWorkouts();
    }

    public List<WorkoutModel> getUserSpecificWorkouts(String userID) {
        return workoutService.getUserSpecificWorkouts(userID);
    }

    public boolean logWorkout(String userID, String workoutID, String time) {
        return workoutService.logWorkout(userID, workoutID, time);
    }

    public boolean deleteWorkoutByID(String workoutID) {
       return workoutService.deleteWorkoutByID(workoutID);
    }

    public boolean deleteUserWorkoutByID(String workoutID, String UserID) {
        return workoutRepository.deleteUserWorkoutByID(workoutID, UserID);
    }

    public WorkoutModel findUserWorkoutByID(String userID) {
         return workoutService.findUserWorkoutByID(userID);   
    }

    public WorkoutModel findWorkoutByName(String workoutName) {
        return workoutService.findWorkoutByName(workoutName);   
    }

	public WorkoutModel findWorkoutById(String workoutID) {
		return workoutService.findWorkoutById(workoutID);
	}
}
