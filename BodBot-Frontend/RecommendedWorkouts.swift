

import SwiftUI

struct RecommendedWorkoutsView: View {
    @StateObject var viewModel = RecommendedWorkoutsViewModel()
    @State private var selectedWorkout: Workout?

    var body: some View {
        VStack {
            Text("RECOMMENDED WORKOUTS")
                .font(.title)
                .bold()
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .padding()

            List(viewModel.workouts.enumerated().map { $0 }, id: \.element.id) { (index, workout) in
                WorkoutCell(workout: workout, number: index + 1)
                    .listRowBackground(Color.clear)
                    .onTapGesture {
                        self.selectedWorkout = workout
                    }
            }
            .listStyle(PlainListStyle())
            Spacer()
        }
        .background(Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255))
        .onAppear {
            viewModel.fetchRecommendedWorkouts()
        }
        .sheet(item: $selectedWorkout) { workout in
            WorkoutDetailView(workout: workout, isPresented: $selectedWorkout)
        }
    }
}

struct RecommendedWorkoutCell: View {
    let workout: Workout
    let number: Int  // Add a number property

    var body: some View {
        HStack {
            Text("\(number)")  // Display the number here
                .frame(width: 50, alignment: .leading)  // Set a fixed width for alignment
                .padding()
            Text(workout.name)
                .bold()
                .font(.title2)
            Spacer()
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct RecommendedWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        RecommendedWorkoutsView()
    }
}
