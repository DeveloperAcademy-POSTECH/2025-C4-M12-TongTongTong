import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var showSplash = true
    var body: some View {
        switch coordinator.currentScreen {
        case .splash:
            SplashView()
        case .onboarding:
            OnboardingContainerView()
        case .content:
            MainView()
        case .analysis:
            AnalysisView(coordinator: coordinator)
        case .result:
            ResultView()
                .environmentObject(coordinator)
                .environmentObject(coordinator.resultState)
        case .dev:
            DevView()
        case .recordingComplete:
            RecordingCompleteView()
        }
    }
}
