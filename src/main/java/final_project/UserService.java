package final_project;

public class UserService {
    private UserRepository userRepository;

    public UserService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public UserModel getUserProfile(String userID) {
        return userRepository.findUserByID(userID);
    }

    public UserModel getUserByEmail(String email) {
        return userRepository.findUserByEmail(email);
    }
}
