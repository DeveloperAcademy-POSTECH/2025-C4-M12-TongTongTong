import SwiftUI
import Foundation

class Coordinator: ObservableObject {
    enum Screen {
        case splash
        case main
        case recordingGuide
        case recording
        case recordingComplete
        case analysis
        case result
        case dev
    }
    
    @Published var currentScreen: Screen = .splash
    @Published var resultState = ResultState()
    var mainViewModel: MainViewModel?
    var recordingViewModel: RecordingViewModel?
    
    func goToSplash() { currentScreen = .splash }
    func goToMain() { currentScreen = .main }
    func goToRecordingGuide() { currentScreen = .recordingGuide }
    func goToRecording() { currentScreen = .recording }
    func goToRecordingComplete() { currentScreen = .recordingComplete }
    func goToAnalysis() { currentScreen = .analysis }
    func goToResult() { currentScreen = .result }
    func goToDev() { currentScreen = .dev }
}
