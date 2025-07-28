import SwiftUI
import AVFoundation

class AnalysisViewModel: ObservableObject {
    @Published var overlayOpacity: Double = 0.8
    @Published var loadingRotation: Double = 0
    
    var coordinator: Coordinator
    private var animationStarted = false
    private let soundClassifier = SoundClassifier()

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func onAppear() {
        guard !animationStarted else { return }
        animationStarted = true
        
        analyseAudioAndNavigate()
    }
    
    private func analyseAudioAndNavigate() {
        print("[AnalysisViewModel] onAppear - 로컬 모델 분석 시작")
        
        // Coordinator로부터 오디오 파일 URL 가져오기
        guard let url = coordinator.resultState.audioFileURL else {
            print("[AnalysisViewModel] 오디오 파일 없음")
            DispatchQueue.main.async {
                self.coordinator.resultState.update(result: "판단 불가", confidence: 0)
                self.coordinator.goToResult()
            }
            return
        }
        
        // 분석 중임을 보여주기 위해 3초 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            // SoundClassifier를 사용하여 오디오 파일 분석
            self.soundClassifier.classify(audioFileURL: url) { (target, confidence) in
                DispatchQueue.main.async {
                    if let target = target, let confidence = confidence {
                        print("[AnalysisViewModel] 예측 성공: \(target) (신뢰도: \(confidence))")
                        var resultString = "알 수 없음"
                        
                        // 모델의 예측 결과를 앱에서 사용하는 결과 문자열로 변환
                        switch target {
                        case "B":
                            resultString = "안 익음"
                        case "A":
                            resultString = "잘 익음"
                        case "C":
                            resultString = "너무 익음"
                        default:
                            break
                        }
                        
                        // Coordinator의 상태를 업데이트하고 결과 화면으로 이동
                        self.coordinator.resultState.update(result: resultString, confidence: confidence * 100)
                    } else {
                        print("[AnalysisViewModel] 예측 실패")
                        self.coordinator.resultState.update(result: "판단 불가", confidence: 0)
                    }
                    self.coordinator.goToResult()
                }
            }
        }
    }
    
    func startAnimation() {
        withAnimation(.easeOut(duration: 3.0)) {
            self.overlayOpacity = 0
            self.loadingRotation = 180
        }
    }
    
    func onDisappear() {
        print("[AnalysisViewModel] onDisappear")
    }
}
