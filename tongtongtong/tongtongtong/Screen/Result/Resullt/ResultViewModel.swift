import SwiftUI

class ResultViewModel: ObservableObject {
    @Published var prediction: PredictionResponse
    @Published var resultState = ResultState()
    
    init(prediction: PredictionResponse, resultState: ResultState = ResultState()) {
        self.prediction = prediction
        self.resultState = resultState
    }
    
    func predict(using audioFile: URL) {
        WatermelonAPIService.shared.predictWatermelon(audioFile: audioFile) { [weak self] result in
            switch result {
            case .success(let prediction):
                print("[ResultViewModel]: resultState Update")
                DispatchQueue.main.async {
                    self?.resultState.update(with: prediction)
                }
            case .failure(let error):
                print("[ResultViewModel] 예측 에러: \(error)")
            }
        }
    }
}
