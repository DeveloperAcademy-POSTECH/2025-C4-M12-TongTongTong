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
    func goToAnalysis() { currentScreen = .analysis }
    func goToResult() { currentScreen = .result }
    func goToDev() { currentScreen = .dev }
    func goToRecordingGuide() { currentScreen = .recordingGuide }
    func goToRecording() { currentScreen = .recording }
    func goToRecordingComplete() { currentScreen = .recordingComplete }

    // 유우야 이거 옮겨줘라 - 여기 아닌데 일단 자야 되서 메모 남긴다.
    func analyseAudioAndGoToResult() {
        print("[Coordinator] analyseAudioAndGoToResult - 서버 분석 시작")
        
        guard let url = resultState.audioFileURL else {
            print("[Coordinator] 오디오 파일 없음")
            DispatchQueue.main.async {
                self.resultState.update(result: "판단 불가", confidence: 0)
                self.goToResult()
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
                    self.goToResult()
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: workItem)
    }
}
