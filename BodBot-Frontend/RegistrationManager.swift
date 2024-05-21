import Foundation

class RegistrationManager: ObservableObject {
    @Published var isRegistered = false
    @Published var errorMessage = ""
    @Published var authToken: String?
    @Published var userID: String?

    func sendRegistrationDetails(email: String, username: String, password: String, birthday: Date, goals: String) {
        guard let url = URL(string: "http://localhost:8080/final_project/register") else {
            print("Invalid URL")
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let birthdayStr = dateFormatter.string(from: birthday)
        
        let postString = "email=\(email)&username=\(username)&password=\(password)&birthday=\(birthdayStr)&goals=\(goals)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = postString.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to send registration: \(error.localizedDescription)"
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
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
                if let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(jsonResponse)
                    if let token = jsonResponse["AuthToken"] as? String, let userID = jsonResponse["userID"] as? String {
                        DispatchQueue.main.async {
                            self.authToken = token
                            self.userID = userID
                            self.isRegistered = true
                            // Save token and userID securely
                            AuthTokenManager.saveAuthToken(token, userID: String(userID))
                        }
                    } else if let failureMessage = jsonResponse["Failed"] as? String {
                        DispatchQueue.main.async {
                            self.errorMessage = failureMessage
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error parsing response from server"
                }
            }
        }.resume()
    }
}
