package final_project;

public class RegisterRequestModel {
    private String email;
    private String password;
    private String name;
    private int age;
    private String goals;

    public RegisterRequestModel(String email, String password, String name, int age, String goals) {
        this.email = email;
        this.password = password;
        this.name = name;
        this.age = age;
        this.goals = goals;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getAge() {
        return age;
    }

    public void setAge(int age) {
        this.age = age;
    }

    public String getGoals() {
        return goals;
    }

    public void setGoals(String goals) {
        this.goals = goals;
    }
}
