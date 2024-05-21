package final_project;

import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;

public class UserModel {
    private String userID;
    private String email;
    private String username;
    private String password;
    private String birthday; // Using String to store birthday
    private String goals;
    private String preferredWorkoutTime;

    public UserModel(String userID, String email, String username, String goals, String password, String birthday) {
        this.userID = userID;
        this.email = email;
        this.username = username;
        this.goals = goals;
        this.password = password;
        this.birthday = birthday;
    }

    // Getters and setters
    public String getUserID() {
        return userID;
    }

    public void setUserID(String userID) {
        this.userID = userID;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getGoals() {
        return goals;
    }

    public void setGoals(String goals) {
        this.goals = goals;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getBirthday() {
        return birthday;
    }

    public void setBirthday(String birthday) {
        this.birthday = birthday;
    }

    public String getWorkoutTime() {
        return preferredWorkoutTime;
    }

    public void setWorkoutTime(String preferredWorkoutTime) {
        this.preferredWorkoutTime = preferredWorkoutTime;
    }

    public int getAge() {
        try {
            LocalDate birthDate = LocalDate.parse(birthday, DateTimeFormatter.ISO_LOCAL_DATE);
            LocalDate currentDate = LocalDate.now();
            return Period.between(birthDate, currentDate).getYears();
        } catch (Exception e) {
            e.printStackTrace();
            return -1;  // Return -1 or handle error appropriately if parsing fails
        }
    }
}
