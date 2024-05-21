import SwiftUI

struct WorkoutEntry: Identifiable {
    let id: UUID
    let name: String
    let imageName: String
    let workout: Workout

    init(workout: Workout) {
        self.id = UUID()
        self.name = workout.name
        self.imageName = workout.name.lowercased().replacingOccurrences(of: " ", with: "-")
        self.workout = workout
    }
}

struct SimpleWorkoutDetailView: View {
    let workout: Workout

    var body: some View {
        VStack {
            Text(workout.name)
                .font(.title)
                .padding()
            Divider()
            VStack(alignment: .leading) {
                Text("Description: ").bold().font(.title2) + Text(workout.description)
                    .font(.title2)

                Text("Muscle Groups: ").bold().font(.title2) + Text(workout.muscleGroups)
                    .font(.title2)

                Text("Equipment: ").bold().font(.title2) + Text(workout.equipment)
                    .font(.title2)

                Text("Type: ").bold().font(.title2) + Text(workout.type)
                    .font(.title2)

                Text("Level: ").bold().font(.title2) + Text(workout.level)
                    .font(.title2)
            }
            .padding()
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(false) // Hide the back button
    }
}


struct WorkoutLogCell: View {
    let entry: WorkoutEntry

    var body: some View {
        HStack {
            Image(systemName: entry.imageName)
                .resizable()
                .frame(width: 50, height: 50)
                .padding()
            VStack(alignment: .leading) {
                Text(entry.name)
                    .font(.headline)
            }
            Spacer()
        }
        .frame(height: 80)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct WorkoutLogView: View {
    @ObservedObject var viewModel = LikedWorkoutsViewModel()
    var userID: String?

    init() {
        let (_, loadedUserID) = AuthTokenManager.loadAuthToken()
        self.userID = loadedUserID
    }

    var body: some View {
        NavigationView {
            VStack {
                Text("WORKOUT LOG")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding()

                List(viewModel.likedWorkouts.map { WorkoutEntry(workout: $0) }) { entry in
                    NavigationLink(destination: SimpleWorkoutDetailView(workout: entry.workout)) {
                        WorkoutLogCell(entry: entry)
                            .listRowBackground(Color.clear)
                    }
                    .listRowBackground(Color.clear)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)

                Spacer()
            }
            .background(Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255))
            .onAppear {
                if let userID = userID {
                    viewModel.fetchLikedWorkouts(userID: userID)
                } else {
                    print("User ID not available")
                }
            }
        }
    }
}

struct WorkoutLogView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutLogView()
    }
}
