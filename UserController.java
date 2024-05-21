package final_project;

public class UserController {
    private UserService userService;
    private AuthenticationService authenticationService;
    private UserRepository userRepository;

    public UserController() {
        this.userRepository = new UserRepository();
        this.userService = new UserService(userRepository);
        this.authenticationService = new AuthenticationService(userRepository);
    }

    public String registerNewUser(String email, String username, String password, String goals, String birthday) {
        if (email != null && password != null &&
        birthday != null && username != null && goals != null) {
            boolean success = authenticationService.userRegistration(email, username, goals, password, birthday);
            if (success) {
	            String token = authenticationService.userLogin(email, password);
	            System.out.println("token: " + token);
	            if (token != null) {
	                return "Registration successful: " + token;
	            } else {
	                return "Registration failed";
	            }
            }
        }
        return "Invalid input data";
    }

    public String loginForUser(String email, String password) {
        if (email != null && !email.isEmpty() && password != null && !password.isEmpty()) {
            String token = authenticationService.userLogin(email, password);
            if (token != null) {
                //could just return token if successful, return 0 if login failed, return -1 if invalid credentials?
                return "Login successful: " + token;
            } else {
                return "Login failed";
            }
        }
        return "Invalid login credentials";
    }

    public UserModel getUserProfile(String userID) {
        if (userID != null && !userID.isEmpty()) {
            return userService.getUserProfile(userID);
        }
        return null; 
    }

    public UserModel getUserByEmail(String email) {
        return userService.getUserByEmail(email);
    }
}
