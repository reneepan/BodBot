package final_project;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.google.gson.*;

public class LoginServlet extends HttpServlet {
    private UserController userController = new UserController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String result = userController.loginForUser(email, password);
        UserModel user = userController.getUserByEmail(email);

        JsonObject jsonResponse = new JsonObject();
        if (result.startsWith("Login successful: ")) {
            String token = result.substring(18);
            jsonResponse.addProperty("AuthToken", token);
            jsonResponse.addProperty("userID", user.getUserID());
        } else {
            jsonResponse.addProperty("Failed", "Login Failed");
        }
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}
