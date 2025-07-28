import SwiftUI
import AVFoundation

class AnalysisViewModel: ObservableObject {
    @Published var overlayOpacity: Double = 0.8
    @Published var loadingRotation: Double = 0
    @Published var resultState = ResultState()
    
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
        
        Task {
            await analyseAudioAndNavigate()
        }
    }
    
    private func analyseAudioAndNavigate() async {
        print("[AnalysisViewModel] onAppear - 서버 분석 시작")
        
        guard let url = coordinator.resultState.audioFileURL else {
            print("[AnalysisViewModel] 오디오 파일 없음")
            await MainActor.run {
                coordinator.resultState.update(result: "판단 불가", confidence: 0)
                coordinator.goToResult()
            }
            return
        }
        
        print("✅ 녹음된 파일 경로: \(url.path)")
        
        do {
            try await Task.sleep(nanoseconds: 3_000_000_000) // 3초 대기
            
            let response = try await WatermelonAPIService.shared.predictWatermelon(audioFileURL: url)
            
            await MainActor.run {
                print("[API] 예측 성공: \(response)")
                let predictionClass = response.prediction
                var resultString = "알 수 없음"
                
                switch predictionClass {
                case 0:
                    resultString = "안 익음"
                case 1:
                    resultString = "잘 익음"
                case 2:
                    resultString = "너무 익음"
                default:
                    break
                }
                
                coordinator.resultState.update(result: resultString, confidence: response.confidence * 100)
                coordinator.goToResult()
            }
        } catch {
            print("[API] 예측 실패: \(error)")
            await MainActor.run {
                coordinator.resultState.update(result: "판단 불가", confidence: 0)
                coordinator.goToResult()
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

    func analyseAudioAndGoToResult() {
        print("[Coordinator] analyseAudioAndGoToResult - 서버 분석 시작")
        
        guard let url = resultState.audioFileURL else {
            print("[Coordinator] 오디오 파일 없음")
            DispatchQueue.main.async {
                self.resultState.update(result: "판단 불가", confidence: 0)
                self.coordinator.goToResult()
            }
            return
        }
        
        let workItem = DispatchWorkItem {
            WatermelonAPIService.shared.predictWatermelon(audioFileURL: url) { [weak self] result in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    
                    switch result {
                    case .success(let response):
                        print("[API] 예측 성공: \(response)")
                        let predictionClass = response.prediction
                        var resultString = "알 수 없음"
                        
                        switch predictionClass {
                        case 0:
                            resultString = "안 익음"
                        case 1:
                            resultString = "잘 익음"
                        case 2:
                            resultString = "너무 익음"
                        default:
                            break
                        }
                        
                        self.resultState.update(result: resultString, confidence: response.confidence * 100)
                        
                    case .failure(let error):
                        print("[API] 예측 실패: \(error)")
                        self.resultState.update(result: "판단 불가", confidence: 0)
                    }
                    self.coordinator.goToResult()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
    }
}

