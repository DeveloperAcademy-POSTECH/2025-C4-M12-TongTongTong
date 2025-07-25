import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var showSplash = true
    var body: some View {
        switch coordinator.currentScreen {
        case .splash:
            SplashView()
        case .main:
            MainView()
        case .analysis:
            AnalysisView()
        case .recordingGuide:
            RecordingGuideView()
        case .recording:
            RecordingView()
        case .recordingComplete:
            RecordingCompleteView()
        case .result:
            ResultView()
                .environmentObject(coordinator)
                .environmentObject(coordinator.resultState)
        case .dev:
            DevView()
        }
    }
}
