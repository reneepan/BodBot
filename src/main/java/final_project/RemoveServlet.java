package final_project;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import com.google.gson.*;

public class RemoveServlet extends HttpServlet {
    private WorkoutController workoutController = new WorkoutController();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        String workoutName = request.getParameter("workoutName");
        String userID = request.getParameter("userID");
        WorkoutModel workout = workoutController.findWorkoutByName(workoutName);
        workoutController.deleteUserWorkoutByID(workout.getWorkoutID(), userID);

        JsonObject jsonResponse = new JsonObject();
        jsonResponse.addProperty("Success", "Workout removed successfully");
        response.getWriter().write(new Gson().toJson(jsonResponse));
    }
}
