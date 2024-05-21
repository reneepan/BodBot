package final_project;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

import com.google.gson.Gson;
import com.google.gson.JsonArray;

public class GetLikedWorkoutsServlet extends HttpServlet {

    private WorkoutController workoutController = new WorkoutController();
    private Gson gson = new Gson();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String userID = request.getParameter("userID");
        List<WorkoutModel> workouts = workoutController.getUserSpecificWorkouts(userID);
        JsonArray workoutsJson = new JsonArray();
        for (WorkoutModel workout : workouts) {
            workoutsJson.add(gson.toJsonTree(workout));
        }
        response.getWriter().write(workoutsJson.toString());
    }
}
