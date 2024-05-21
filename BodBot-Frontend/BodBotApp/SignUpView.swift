import SwiftUI

struct SignUpView: View {
    @StateObject private var registrationManager = RegistrationManager()
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var birthday = Date()
    @State private var selectedGoal = "strengthen" // default value to ensure a selection
    @State private var showAlert = false
    @State private var shouldNavigateToMain = false

    let goals = ["strengthen", "lose weight", "bulk up"]
    
    var isFormValid: Bool {
        !email.isEmpty && !username.isEmpty && !password.isEmpty && selectedGoal != ""
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
                    Text("Sign Up")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.white)
                    
                    VStack(spacing: 20) {
                        // User Information Fields
                        VStack(alignment: .leading, spacing: 10) {
                            Text("USER INFORMATION")
                                .bold()
                                .foregroundColor(.white)
                            
                            CustomTextField(placeholder: Text("Email").foregroundColor(.white), text: $email)
                                .autocapitalization(.none)
                            CustomTextField(placeholder: Text("Username").foregroundColor(.white), text: $username)
                                .autocapitalization(.none)
                            CustomTextField(placeholder: Text("Password").foregroundColor(.white), text: $password, isSecure: true)
                                .autocapitalization(.none)

                            Text("Birthday")
                                .bold()
                                .foregroundColor(.white)
                            CustomDatePicker(date: $birthday)
                        }
                        .padding(.horizontal, 20)
                        
                        // Goal Selection
                        VStack(alignment: .leading, spacing: 10) {
                            Text("YOUR GOAL")
                                .bold()
                                .foregroundColor(.white)
                            
                            ForEach(goals, id: \.self) { goal in
                                HStack {
                                    Text(goal.capitalized)
                                        .foregroundColor(.white)
                                    Spacer()
                                    RadioButton(isSelected: self.selectedGoal == goal) {
                                        self.selectedGoal = goal
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        
                        // Next button
                        Button(action: {
                            if isFormValid {
                                registrationManager.sendRegistrationDetails(email: email, username: username, password: password, birthday: birthday, goals: selectedGoal)
                            } else {
                                showAlert = true
                            }
                        }) {
                            Text("Next")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(isFormValid ? Color.blue : Color.gray)
                                .cornerRadius(10)
                        }
                        .disabled(!isFormValid)
                        .padding(.horizontal, 20)
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Error"), message: Text("Invalid input. Please fill in all fields."), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding()
                    .background(Color.black.opacity(0.3))
                    .cornerRadius(10)
                    .padding()
                    
                    if registrationManager.isRegistered {
                        Text("Registration Successful!")
                            .foregroundColor(.green)
                        .onAppear {
                            shouldNavigateToMain = true
                        }
                    }
                }
                .navigationDestination(isPresented: $shouldNavigateToMain) {
                    MainTabContainerView().navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

struct CustomTextField: View {
    var placeholder: Text
    @Binding var text: String
    var isSecure: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            if isSecure {
                SecureField("", text: $text)
                    .foregroundColor(.white)
            } else {
                TextField("", text: $text)
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color.black.opacity(0.3))
        .cornerRadius(5)
    }
}

struct CustomDatePicker: View {
    @Binding var date: Date
    
    var body: some View {
        DatePicker("Birthday", selection: $date, displayedComponents: .date)
            .labelsHidden()
            .padding()
            .background(Color.black.opacity(0.3))
            .cornerRadius(5)
            .foregroundColor(.white)
    }
}

struct RadioButton: View {
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
                .foregroundColor(isSelected ? .gray : .white)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}


//import SwiftUI
//
//struct SignUpView: View {
//    @StateObject private var registrationManager = RegistrationManager()
//    @State private var email = ""
//    @State private var username = ""
//    @State private var password = ""
//    @State private var birthday = Date()
//    @State private var selectedGoal = "strengthen" // default value to ensure a selection
//    @State private var showAlert = false
//    @State private var showSuccess = false
//    
//    @State private var shouldNavigateToMain = false
//
//    let goals = ["strengthen", "lose weight", "bulk up"]
//    
//    var isFormValid: Bool {
//        !email.isEmpty && !username.isEmpty && !password.isEmpty && selectedGoal != ""
//    }
//    
//    var body: some View {
//        ZStack {
//            // Background image
//            Image("BackgroundImg")
//                .resizable()
//                .edgesIgnoringSafeArea(.all)
//            
//            // Main content
//            VStack {
//                Text("Sign Up")
//                    .font(.largeTitle)
//                    .bold()
//                    .foregroundColor(.white)
//                
//                VStack(spacing: 20) {
//                    // User Information Fields
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("USER INFORMATION")
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        CustomTextField(placeholder: Text("Email").foregroundColor(.white), text: $email)
//                        CustomTextField(placeholder: Text("Username").foregroundColor(.white), text: $username)
//                        CustomTextField(placeholder: Text("Password").foregroundColor(.white), text: $password, isSecure: true)
//                        CustomDatePicker(date: $birthday)
//                    }
//                    .padding(.horizontal, 20)
//                    
//                    // Goal Selection
//                    VStack(alignment: .leading, spacing: 10) {
//                        Text("YOUR GOAL")
//                            .bold()
//                            .foregroundColor(.white)
//                        
//                        ForEach(goals, id: \.self) { goal in
//                            HStack {
//                                Text(goal.capitalized)
//                                    .foregroundColor(.white)
//                                Spacer()
//                                RadioButton(isSelected: self.selectedGoal == goal) {
//                                    self.selectedGoal = goal
//                                }
//                            }
//                        }
//                    }
//                    .padding(.horizontal, 20)
//                    
//                    // Next button
//                    Button(action: {
//                        if isFormValid {
//                            registrationManager.connect()
//                            registrationManager.sendRegistrationDetails(email: email, username: username, password: password, birthday: birthday, goal: selectedGoal)
//                        } else {
//                            showAlert = true
//                        }
//                    }) {
//                        Text("Next")
//                            .foregroundColor(.white)
//                            .frame(maxWidth: .infinity)
//                            .frame(height: 50)
//                            .background(isFormValid ? Color.blue : Color.gray)
//                            .cornerRadius(10)
//                    }
//                    .disabled(!isFormValid)
//                    .padding(.horizontal, 20)
//                }
//                .padding()
//                .background(Color.black.opacity(0.2))
//                .cornerRadius(10)
//                .padding()
//                
//                if registrationManager.isRegistered {
//                    Text("Login Successful!")
//                        .foregroundColor(.green)
//                        .onAppear {
//                            shouldNavigateToMain = true
//                        }
//                }
//            }
//            .onChange(of: shouldNavigateToMain) { newValue in
//                if newValue {
//                    print("Navigation to MainTabContainerView is now active")
//                }
//            }
//            .navigationDestination(isPresented: $shouldNavigateToMain) {
//                MainTabContainerView()
//            }
//        }
//        .alert(isPresented: $registrationManager.isRegistered) {
//            Alert(title: Text("Success"), message: Text("You have successfully registered!"), dismissButton: .default(Text("OK")))
//        }
//       
//    }
//}
//
//
//struct CustomTextField: View {
//    var placeholder: Text
//    @Binding var text: String
//    var isSecure: Bool = false
//    
//    var body: some View {
//        ZStack(alignment: .leading) {
//            if text.isEmpty { placeholder }
//            if isSecure {
//                SecureField("", text: $text)
//                    .foregroundColor(.white)
//            } else {
//                TextField("", text: $text)
//                    .foregroundColor(.white)
//            }
//        }
//        .padding()
//        .background(Color.black.opacity(0.3))
//        .cornerRadius(5)
//    }
//}
//
//struct CustomDatePicker: View {
//    @Binding var date: Date
//    
//    var body: some View {
//        DatePicker("", selection: $date, displayedComponents: .date)
//            .labelsHidden()
//            .padding()
//            .background(Color.black.opacity(0.3))
//            .cornerRadius(5)
//            .foregroundColor(.white)
//    }
//}
//
//struct RadioButton: View {
//    var isSelected: Bool
//    var action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            Image(systemName: isSelected ? "largecircle.fill.circle" : "circle")
//                .foregroundColor(isSelected ? .gray : .white)
//        }
//        .buttonStyle(PlainButtonStyle())
//    }
//}
//
//struct SignUpViewPreview: PreviewProvider {
//    static var previews: some View {
//        SignUpView()
//            .environment(\.locale, .init(identifier: "en"))
//    }
//}
