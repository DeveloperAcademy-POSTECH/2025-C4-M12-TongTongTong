import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var resultState = ResultState()
    
    init(resultState: ResultState = ResultState()) {
        self.resultState = resultState
    }
    
    func predict(using audioFile: URL) {
        WatermelonAPIService.shared.predictWatermelon(audioFile: audioFile) { [weak self] result in
            switch result {
            case .success(let prediction):
                print("[ResultViewModel]: resultState Update")
                DispatchQueue.main.async {
                    self?.resultState.update(predicted_class: prediction.predicted_class, probabilities: prediction.probabilities, confidence: prediction.confidence)
                }
            case .failure(let error):
                print("[ResultViewModel] 예측 에러: \(error)")
            }
        }
    }
}
