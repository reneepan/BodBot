package final_project;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;

public class GetUserInfoServlet extends HttpServlet {

    private UserController userController = new UserController();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String userID = request.getParameter("userID");
        String jsonStr = gson.toJson(userController.getUserProfile(userID));
        response.getWriter().write(jsonStr);
    }
}
