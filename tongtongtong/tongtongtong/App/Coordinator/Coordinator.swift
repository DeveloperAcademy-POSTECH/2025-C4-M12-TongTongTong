import SwiftUI

class Coordinator: ObservableObject {
    enum Screen {
        case splash
        case onboarding
        case content
        case analysis
        case result
        case dev
        case recordingComplete
    }

    @Published var currentScreen: Screen = .splash
    var mainViewModel: MainViewModel?
    @Published var resultState = ResultState()

    // --- 추가된 부분: 온보딩 완료 여부 저장 ---
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    // ------------------------------------

    init() {
        print("[Coordinator] init: 앱 시작, 스플래시 화면으로 설정")
        currentScreen = .splash
    }
    
    // --- 추가된 부분: 스플래시 종료 후 호출될 함수 ---
    /// 스플래시 화면이 끝난 후, 온보딩 완료 여부에 따라 적절한 화면으로 안내합니다.
    func splashDidFinish() {
        print("[Coordinator] splashDidFinish: 스플래시 종료")
        if hasCompletedOnboarding {
            print("-> 온보딩 완료 사용자. 메인 화면으로 이동합니다.")
            goToContent()
        } else {
            print("-> 첫 사용자. 온보딩 화면으로 이동합니다.")
            currentScreen = .onboarding
        }
    }

    // --- 추가된 부분: 온보딩 완료 후 호출될 함수 ---
    /// 온보딩의 '시작하기' 버튼을 누르면 호출됩니다.
    func completeOnboarding() {
        print("[Coordinator] completeOnboarding: 온보딩 완료")
        hasCompletedOnboarding = true // 온보딩 완료 상태를 true로 저장
        goToContent() // 메인 화면으로 이동
    }
    // ------------------------------------

    // 기존 화면 이동 함수들
    func goToSplash() { currentScreen = .splash }
    func goToContent() {
        print("[Coordinator] goToContent: 메인 화면으로 이동합니다.")
        currentScreen = .content
    }
    func goToAnalysis() { currentScreen = .analysis }
    func goToResult() { currentScreen = .result }
    func goToDev() { currentScreen = .dev }
    func goToRecordingComplete() { currentScreen = .recordingComplete }
}
