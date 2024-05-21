//
//  ProfileManager.swift
//  BodBotApp
//
//  Created by Ronit Avalani on 4/29/24.
//

import Foundation
import SwiftUI
import Combine

class ProfileManager: ObservableObject {
    @Published var user: UserModel? = nil
    var cancellables = Set<AnyCancellable>()

    let baseURL = "http://localhost:8080/final_project/getUserInfo"  // Change this URL to your servlet URL

    
    func fetchUserProfile(userId: String) {
        // Log the userId to console

        // Optional: Add validation if there are specific criteria for a valid userId
        if userId.isEmpty {
            print("Invalid userId: userId is empty")
            return
        }

        guard let url = URL(string: "\(baseURL)?userID=\(userId)") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: UserModel.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("Error fetching user profile: \(error)")
                    }
                },
                receiveValue: { [weak self] userModel in
                    self?.user = userModel
                }
            )
            .store(in: &cancellables)
    }
}

struct UserModel: Decodable {
    var userID: String
    var email: String
    var username: String
    var password: String
    var birthday: String
    var goals: String
}

