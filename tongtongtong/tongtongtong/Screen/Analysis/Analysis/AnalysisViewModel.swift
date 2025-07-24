import SwiftUI

final class AnalysisViewModel: ObservableObject {
    @Published var overlayOffsetX: CGFloat = 190
    @Published var overlayOpacity: Double = 0.8
    @Published var loadingRotation: Double = 0

    let coordinator: Coordinator

    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }

    func startAnimation() {
        withAnimation(.easeOut(duration: UIConstants.analysisAnimationDuration)) {
            overlayOffsetX += 200
            overlayOpacity = 0
            loadingRotation = 180
        }
    }

    func startAnalysis() {
        print("[AnalysisView] onAppear - 서버 분석 시작")
        guard let url = coordinator.resultState.audioFileURL else {
            print("[AnalysisView] 오디오 파일 없음")
            return
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.analysisDelayBeforeRequest) {
            WatermelonAPIService.shared.predictWatermelon(audioFileURL: url) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let response):
                        print("[API] 예측 성공: \(response)")
                        self.coordinator.resultState.update(with: response)
                        self.coordinator.goToResult()
                    case .failure(let error):
                        print("[API] 예측 실패: \(error)")
                    }
                }
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.analysisAutoTransitionDelay) {
                self.coordinator.goToResult()
            }
        }
    }

    func handleDisappear() {
        print("[AnalysisView] onDisappear")
    }
}
