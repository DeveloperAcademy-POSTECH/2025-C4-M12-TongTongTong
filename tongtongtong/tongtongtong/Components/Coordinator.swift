import SwiftUI

class Coordinator: ObservableObject {
    enum Screen {
        case splash
        case content
        case analysis
        case result
        case dev // DevView 추가
        case recordingComplete
    }
    @Published var currentScreen: Screen = .splash
    var mainViewModel: ContentViewModel?
    @Published var resultState = ResultState()

    func goToSplash() { currentScreen = .splash }
    func goToContent() { currentScreen = .content }
    func goToAnalysis() { currentScreen = .analysis }
    func goToResult() { currentScreen = .result }
    func goToDev() { currentScreen = .dev } // DevView 이동
    func goToRecordingComplete() { currentScreen = .recordingComplete }
} 
