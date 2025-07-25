import SwiftUI
import AVFoundation

class AnalysisViewModel: ObservableObject {
    @Published var overlayOpacity: Double = 0.8
    @Published var loadingRotation: Double = 0
    
    var coordinator: Coordinator
    private var animationStarted = false
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func setCoordinator(_ coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func onAppear() {
        guard !animationStarted else { return }
        animationStarted = true
        print("[AnalysisViewModel] onAppear - 서버 분석 시작")
        guard let url = coordinator.resultState.audioFileURL else {
            print("[AnalysisViewModel] 오디오 파일 없음")
            return
        }
        // 3초간 로딩 화면 노출 후 서버 호출
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            WatermelonAPIService.shared.predictWatermelon(audioFileURL: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("[API] 예측 성공: \(response)")
                        self?.coordinator.resultState.update(with: response)
                        self?.coordinator.goToResult()
                    case .failure(let error):
                        print("[API] 예측 실패: \(error)")
                        // 에러 처리 필요시 추가
                    }
                }
            }
            print("[AnalysisViewModel] onAppear")
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                self?.coordinator.goToResult()
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
