import Foundation

class GeneralWorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []

    func fetchWorkouts() {
        guard let url = URL(string: "http://localhost:8080/final_project/getAllWorkouts") else {
            print("Invalid URL")
            return
        }
        let (authToken, userID) = AuthTokenManager.loadAuthToken()
        print(authToken as Any)
        print(userID as Any)

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let decodedResponse = try? JSONDecoder().decode([Workout].self, from: data) {
                print(data)
                DispatchQueue.main.async {
                    self.workouts = decodedResponse
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}
