//
//  HomePage.swift
//  BodBot_Test
//
//  Created by Ronit Avalani on 4/25/24.
//

import SwiftUI

struct HomePage: View {
    @State private var isLoggedIn = false
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image with blur effect
                Image("BackgroundImg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                // Vertical stack for the logo and buttons
                VStack(spacing: 20) {
                    Spacer()
                    
                    // Logo and tagline
                    VStack {
                        Text("BODBOT")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                        Text("unlock your potential")
                            .font(.caption)
                            .fontWeight(.light)
                    }
                    .foregroundColor(.white)
                    
                    // Signup and Login buttons
                    VStack(spacing: 10) {
                        NavigationLink(destination: SignUpView()) {
                            Text("signup")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                        
                        NavigationLink(destination: LoginView()) {
                            Text("login")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 40)
                    
                    Spacer()
                    
                    // General Workouts Only button
                    NavigationLink(destination: GeneralWorkoutsView()) {
                        Text("General Workouts Only")
                            .padding()
                            .background(Color.black.opacity(0.6))
                            .foregroundColor(.white)
                            .clipShape(Capsule())
                            .padding(.bottom, 20)
                    }
                }
            }
        }
    }
}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePage()
            .previewDevice("iPhone 12")
    }
}


