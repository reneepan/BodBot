package final_project;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

import com.google.gson.*;

public class GetAllWorkoutsServlet extends HttpServlet {
    private WorkoutController workoutController = new WorkoutController();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        List<WorkoutModel> workouts = workoutController.getAllWorkouts();
        JsonArray workoutsJson = new JsonArray();
        for (WorkoutModel workout : workouts) {
            workoutsJson.add(new Gson().toJsonTree(workout));
        }
        response.getWriter().write(workoutsJson.toString());
    }
}
