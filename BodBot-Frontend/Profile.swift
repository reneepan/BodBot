import SwiftUI

struct ProfileView: View {
    @StateObject var profileManager = ProfileManager()
    var userID: String?
    @State private var shouldNavigateToHome: Bool = false

    init() {
        let (_, loadedUserID) = AuthTokenManager.loadAuthToken()
        self.userID = loadedUserID
    }


    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 59 / 255, green: 91 / 255, blue: 104 / 255)
                    .edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack {
                        if let user = profileManager.user {
                            Image(systemName: "person.crop.circle")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding(.top, 24)
                                .padding(.bottom, 30)
                                .foregroundColor(.white)

                            VStack(alignment: .leading, spacing: 20) {
                                Text("Username: ")
                                    .bold()
                                    .font(.title3)
                                Text("\(user.username)")
                                                            
                                Text("Email: ")
                                    .bold()
                                    .font(.title3)
                                Text("\(user.email)")
                                
                                Text("Birthday: ")
                                    .bold()
                                    .font(.title3)
                                Text("\(user.birthday)")
                                
                                Text("Goals: ")
                                    .bold()
                                    .font(.title3)
                                Text("\(user.goals)")
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding()
                            .foregroundColor(.black)
                            .background(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                        } else {
                            ProgressView()  // Show a progress indicator while loading
                        }

                        Button("Log Out") {
                            shouldNavigateToHome = true  // Trigger navigation to home
                            AuthTokenManager.deleteAuthToken()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .padding(.top, 24)
                        .padding(.bottom)
                        
                        // Conditional navigation logic
                        NavigationLink(destination: HomePage().navigationBarBackButtonHidden(true), isActive: $shouldNavigateToHome) {
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .background(Color.clear)
            }
            .background(NavigationConfigurator { nc in
                nc.navigationBar.barTintColor = UIColor(red: 59 / 255, green: 91 / 255, blue: 104 / 255, alpha: 1)
                nc.navigationBar.titleTextAttributes = [.foregroundColor : UIColor.white]
            })
            .onAppear {
                profileManager.fetchUserProfile(userId: userID ?? "")
            }
        }
    }
}


struct NavigationConfigurator: UIViewControllerRepresentable {
    var configure: (UINavigationController) -> Void

    func makeUIViewController(context: Context) -> UIViewController {
        UIViewController()  // We just need the controller for configuration, no UI.
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        if let navigationController = uiViewController.navigationController {
            self.configure(navigationController)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

