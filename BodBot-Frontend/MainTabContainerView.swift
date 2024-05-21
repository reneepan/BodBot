import SwiftUI

struct MainTabContainerView: View {
    @State private var isLoggedIn = false
    init() {
        configureTabBarAppearance()
    }

    var body: some View {
        TabView {
            GeneralWorkoutsView()
                .tabItem{
                    Label("General", systemImage: "figure.walk")
                }
            
            RecommendedWorkoutsView()
                .tabItem {
                    Label("Recommended", systemImage: "list.bullet")
                }
            
            WorkoutLogView()
                .tabItem {
                    Label("Log", systemImage: "book")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .accentColor(.gray) // Set the selected tab item color to gray
    }
    
    private func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.black
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        
        // Set the unselected icon and text color to white
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.gray]
        
        // Apply the appearance to the standard appearance and scrollEdgeAppearance if available
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
}

struct MainTabContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabContainerView()
    }
}
