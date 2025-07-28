import SwiftUI
import Foundation

class ResultViewModel: ObservableObject {
    @Published var resultState = ResultState()

    init() {}

    func predict(using audioFile: URL) {
        WatermelonAPIService.shared.predictWatermelon(audioFile: audioFile) { [weak self] result in
            switch result {
            case .success(let prediction):
                DispatchQueue.main.async {
                    let predictionClass = prediction.prediction
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

                    self?.resultState.update(result: resultString, confidence: prediction.confidence * 100)
                }
            case .failure(let error):
                print("[ResultViewModel] 예측 에러: \(error)")
                // TODO: 에러 처리 UI 업데이트
            }
        }
    }
}
