package final_project;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.text.SimpleDateFormat;
import java.util.Date;

public class LikeWorkoutServlet extends HttpServlet {

    private WorkoutController workoutController = new WorkoutController();
    private Gson gson = new Gson();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        JsonObject jsonObject = gson.fromJson(request.getReader(), JsonObject.class);
        
        String workoutName = jsonObject.get("workoutName").getAsString();
        String userID = jsonObject.get("userID").getAsString();

        try {
            WorkoutModel likedWorkout = workoutController.findWorkoutByName(workoutName);
            if (likedWorkout == null) {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                response.getWriter().write("Workout not found");
                return;
            }

            Date now = new Date();
            SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
            String formattedDate = formatter.format(now);

            workoutController.logWorkout(userID, workoutName, formattedDate);

            AWSRecommendationClient client = new AWSRecommendationClient();
            client.addInteractionToS3(Integer.parseInt(userID), Integer.parseInt(likedWorkout.getWorkoutID()));

            response.getWriter().write("Workout liked successfully.");
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("An error occurred: " + e.getMessage());
        }
    }
}
