package final_project;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.util.Base64;

public class AuthenticationService {
    private UserRepository userRepository;

    public AuthenticationService(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    public String userLogin(String email, String password) {
        UserModel user = userRepository.findUserByEmail(email);
        System.out.println(user.getPassword());
        System.out.println(password);
        if (user != null && verifyPassword(password, user.getPassword())) {
            return generateAuthToken(user);
        }
        return null;
    }

    public boolean userRegistration(String email, String username, String goals, String password, String birthday) {
        UserModel existingUser = userRepository.findUserByEmail(email);
        if (existingUser == null) {
            String hashedPassword = hashPassword(password);
            if (hashedPassword != null) {
                return userRepository.saveUserInfoToDatabase(email, username, goals, hashedPassword, birthday);
            }
        }
        System.out.println("Existing User Exists!");
        return false;
    }

    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            return Base64.getEncoder().encodeToString(hashedBytes);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }

    private boolean verifyPassword(String inputPassword, String storedPassword) {
        String hashedInputPassword = hashPassword(inputPassword);
        return hashedInputPassword.equals(storedPassword);
    }

    private String generateAuthToken(UserModel user) {
        try {
            String seed = user.getEmail() + System.currentTimeMillis();
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            byte[] hash = digest.digest(seed.getBytes());
            return Base64.getEncoder().encodeToString(hash);
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Failed to generate auth token", e);
        }
    }

    private String SecureRandomId() {
        SecureRandom random = new SecureRandom();
        byte[] randomBytes = new byte[16];
        random.nextBytes(randomBytes);
        return Base64.getEncoder().encodeToString(randomBytes);
    }
}
