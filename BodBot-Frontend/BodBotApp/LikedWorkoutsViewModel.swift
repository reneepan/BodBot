
import Foundation

class LikedWorkoutsViewModel: ObservableObject {
    @Published var likedWorkouts: [Workout] = []
    
    var userID: String?

    init() {
        let (_, loadedUserID) = AuthTokenManager.loadAuthToken()
        self.userID = loadedUserID
    }
    func fetchLikedWorkouts(userID: String) {
        guard let url = URL(string: "http://localhost:8080/final_project/getLikedWorkouts?userID=\(userID)") else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let decodedResponse = try? JSONDecoder().decode([Workout].self, from: data) {
                DispatchQueue.main.async {
                    self.likedWorkouts = decodedResponse
                }
            } else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }
}

