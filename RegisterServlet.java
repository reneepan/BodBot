package final_project;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.google.gson.*;

public class RegisterServlet extends HttpServlet {
    private UserController userController = new UserController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String goals = request.getParameter("goals");
        String password = request.getParameter("password");
        String birthday = request.getParameter("birthday");
        String result = userController.registerNewUser(email, username, password, goals, birthday);
        
        
        JsonObject jsonResponse = new JsonObject();
        System.out.println(result);
        if (result.startsWith("Registration successful: ")) {
            String token = result.substring("Registration successful: ".length());
            jsonResponse.addProperty("AuthToken", token);
            UserModel user = userController.getUserByEmail(email);
            jsonResponse.addProperty("userID", user.getUserID());
        } else {
            jsonResponse.addProperty("Failed", "Registration Failed");
        }
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}


