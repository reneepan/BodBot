package final_project;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

import com.google.gson.*;

public class GetRecsServlet extends HttpServlet {
    private WorkoutController workoutController = new WorkoutController();
    private AWSRecommendationClient recommendationClient = new AWSRecommendationClient();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String userID = request.getParameter("userID");
        List<String> recommendations = recommendationClient.getRecommendationList(Integer.parseInt(userID));
        JsonArray workoutsJson = new JsonArray();
        for (String id : recommendations) {
            WorkoutModel workout = workoutController.findWorkoutById(id);
            workoutsJson.add(new Gson().toJsonTree(workout));
        }
        response.getWriter().write(workoutsJson.toString());
    }
}
