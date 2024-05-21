
import SwiftUI


struct WorkoutCell: View {
    let workout: Workout
    let number: Int
    // Add the action for tapping on the cell if needed
    var body: some View {
        HStack {
            Text("\(number)")
                .frame(width: 50, height:50)
                .font(.title2)
                .padding()
                .bold()
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

struct GeneralWorkoutsView: View {
    @StateObject var viewModel = GeneralWorkoutsViewModel()
    @State private var selectedWorkout: Workout?
    @State private var isLoggedIn: Bool = false
    @State private var navigateToLogin = false // State to control navigation

    var body: some View {
        NavigationStack {
            VStack {
                Text("GENERAL WORKOUTS")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                
                List {
                    ForEach(Array(zip(viewModel.workouts.indices, viewModel.workouts)).prefix(isLoggedIn ? viewModel.workouts.count : 10), id: \.1.id) { (index, workout) in
                        WorkoutCell(workout: workout, number: index + 1)
                            .listRowBackground(Color.clear)
                            .onTapGesture {
                                self.selectedWorkout = workout
                            }
                    }
                    if !isLoggedIn {
                        Button("Login to View More Workouts") {
                            navigateToLogin = true
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                        .foregroundColor(.white)
                        .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                
                Spacer()
            }
            .background(Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255))
            .onAppear {
                viewModel.fetchWorkouts()
                let (loadedToken, _) = AuthTokenManager.loadAuthToken()
                isLoggedIn = loadedToken?.isEmpty == false
                if let token = loadedToken {
                    print("Token: \(token)") // Token is safely unwrapped and printed.
                } else {
                    print("Token is nil or not set")
                }
//                isLoggedIn = AuthTokenManager.isLoggedIn() // Check login status on view appear
            }
            .sheet(item: $selectedWorkout) { workout in
                WorkoutDetailView(workout: workout, isPresented: $selectedWorkout)
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                HomePage()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

// This is a placeholder for your detailed view
struct WorkoutDetailView: View {
    let workout: Workout
    @Binding var isPresented: Workout?
    @State private var isLoggedIn = AuthTokenManager.isLoggedIn()
    @State private var showAlert = false
    @State private var showSuccessBanner = false


    var body: some View {
        VStack {
            if showSuccessBanner {
                Text("Workout added successfully!")
                    .bold()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .transition(.slide)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.showSuccessBanner = false // Automatically dismiss the banner after 2 seconds
                        }
                    }
            }
            HStack {
                Spacer()
                Button(action: {
                    self.isPresented = nil
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255))
                        .padding()
                        .background(Color.clear)
                        .clipShape(Circle())
                }
            }
            .padding()
            
            Text(workout.name)
                .font(.title)
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

            Button("Add Workout") {
                if isLoggedIn {
                    likeWorkout()
                } else {
                    showAlert = true
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255))
            .foregroundColor(.white)
            .cornerRadius(10)
            .alert(isPresented: $showAlert) {
                Alert(
                    title: Text("Please Log In"),
                    message: Text("You need to be logged in to add a workout."),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
        .padding()
    }
    private func likeWorkout() {
        guard let url = URL(string: "http://localhost:8080/final_project/likeWorkout") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let (_, userID) = AuthTokenManager.loadAuthToken()
        let parameters = [
            "workoutID": workout.id,
            "userID": userID ?? ""  // Handle potentially nil userID more gracefully
        ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to encode data")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    showAlert = true
                }
                print("Failed to update workout status")
                return
            }
            
            DispatchQueue.main.async {
                self.showSuccessBanner = true // Show success banner
            }
            
            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Workout liked successfully: \(responseString)")
            }
        }.resume()
    }
}



struct GeneralWorkoutsView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralWorkoutsView()
            .environmentObject(GeneralWorkoutsViewModel())
    }
}
