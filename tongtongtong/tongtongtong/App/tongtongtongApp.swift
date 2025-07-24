import SwiftUI

@main
struct tongtongtongApp: App {
    @StateObject var coordinator = Coordinator()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}


