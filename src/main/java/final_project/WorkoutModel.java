package final_project;

public class WorkoutModel {
    private String workoutID;
    private String name;
    private String description;
    private String muscleGroups;
    private String equipment;
    private String type;
    private String level;

    public WorkoutModel(String workoutID, String name, String description, String type, String muscleGroups, String level, String equipment) {
        this.workoutID = workoutID;
        this.name = name;
        this.description = description;
        this.muscleGroups = muscleGroups;
        this.equipment = equipment;
        this.type = type;
        this.level = level;
    }

    public String getWorkoutID() {
        return workoutID;
    }

    public void setWorkoutID(String workoutID) {
        this.workoutID = workoutID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLevel() {
        return level;
    }

    public void setLevel(String level) {
        this.level = level;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getMuscleGroups() {
        return muscleGroups;
    }

    public void setMuscleGroups(String muscleGroups) {
        this.muscleGroups = muscleGroups;
    }

    public String getEquipment() {
        return equipment;
    }

    public void setEquipment(String equipment) {
        this.equipment = equipment;
    }
}
