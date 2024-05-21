import Foundation

class LoginManager: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    func send(username: String, password: String) {
        guard let url = URL(string: "http://localhost:8080/final_project/login") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }

        let postString = "email=\(username)&password=\(password)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to send login request: \(error.localizedDescription)"
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                DispatchQueue.main.async {
                    self.errorMessage = "Server error: \(response.debugDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No data received from server"
                }
                return
            }

            do {
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = jsonResponse["AuthToken"] as? String,
                   let userID = jsonResponse["userID"] as? String {
                    AuthTokenManager.saveAuthToken(token, userID: userID)
                    DispatchQueue.main.async {
                        self.isAuthenticated = true
                    }
                } else {
                    DispatchQueue.main.async {
                        self.errorMessage = "Invalid credentials or response format."
                        self.isAuthenticated = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing response from server: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
