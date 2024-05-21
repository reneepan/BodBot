import Foundation

class RecommendedWorkoutsViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    var userID: String?

    init() {
        let (_, loadedUserID) = AuthTokenManager.loadAuthToken()
        self.userID = loadedUserID
    }

    func fetchRecommendedWorkouts() {
        guard let userID = userID, let url = URL(string: "http://localhost:8080/final_project/getRecs?userID=\(userID)") else {
            print("Invalid URL or userID not available")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching recommended workouts: \(error.localizedDescription)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Invalid response from server")
                return
            }

            if let data = data {
                do {
                    let decodedWorkouts = try JSONDecoder().decode([Workout].self, from: data)
                    DispatchQueue.main.async {
                        self.workouts = decodedWorkouts
                    }
                } catch {
                    print("JSON Decoding Error: \(error)")
                }
            }
        }.resume()
    }
}
