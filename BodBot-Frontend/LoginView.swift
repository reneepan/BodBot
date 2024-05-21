import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showAlert = false
    @StateObject var loginManager = LoginManager()

    @State private var shouldNavigateToMain = false  // Moved inside the struct

    var isFormValid: Bool {
        !username.isEmpty && !password.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image("BackgroundImg")
                    .resizable()
                    .edgesIgnoringSafeArea(.all)

                // Main content
                VStack {
                    Text("Login")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)

                    VStack(spacing: 20) {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("EMAIL")
                                .bold()
                                .foregroundColor(.white)
                            CustomTextField(placeholder:Text("Email").foregroundColor(.white), text: $username)
                            Text("PASSWORD")
                                .bold()
                                .foregroundColor(.white)
                            CustomTextField(placeholder: Text("Password").foregroundColor(.white), text: $password, isSecure: true)
                        }
                        .padding(.horizontal, 20)

                        Button(action: login) {
                            Text("Next")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .padding(.horizontal, 20)
                        .disabled(!isFormValid)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text("Invalid input. Please fill in all fields."), dismissButton: .default(Text("OK")))
                        }
                        
                        if loginManager.isAuthenticated {
                            Text("Login Successful!")
                                .foregroundColor(.green)
                                .onAppear {
                                    shouldNavigateToMain = true
                                }
                        }
                    }
                }
                .padding()
                .background(Color.black.opacity(0.3))
                .cornerRadius(10)
                .padding()
                
                .navigationDestination(isPresented: $shouldNavigateToMain) {
                    MainTabContainerView().navigationBarBackButtonHidden(true)
                }
            }
        }
    }

    func login() {
        if isFormValid {
            loginManager.send(username: username, password: password)
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
