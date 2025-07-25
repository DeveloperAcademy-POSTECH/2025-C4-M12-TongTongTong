import SwiftUI
import Foundation

class ResultState: ObservableObject {
    @Published var confidence: Double = 0
    @Published var result: String = "높음"
    var audioFileURL: URL? = nil // 서버 분석용 오디오 파일 경로 임시 저장
    
    var isRipe: Bool {
        result == "높음" && confidence >= 0
    }
    
    enum WatermelonRipeness {
        case ripe
        case unripe
        
        var imageName: String {
            switch self {
            case .ripe:
                return "ResultRipe"
            case .unripe:
                return "ResultUnripe"
            }
        }
    }
    
    var ripeness: WatermelonRipeness {
        isRipe ? .ripe : .unripe
    }
    
    func update(predicted_class: Int, probabilities: [String: Double], confidence: Double) {
        print("[DEBUG] update(with:) - 받아온 predicted_class: \(predicted_class), probabilities: \(probabilities)")
        
        switch predicted_class {
        case 0:
            self.result = "낮음"
        case 1:
            self.result = "중간"
        case 2:
            self.result = "높음"
        default:
            self.result = "알 수 없음"
        }
        
        self.confidence = confidence
        
        print("[DEBUG] update(with:) - 저장된 result: \(self.result), confidence: \(self.confidence)")
    }

    var resultImageName: String {
        print("[DEBUG] resultImageName 호출 - result: \(result)")
        switch result {
        case "높음":
            print("[DEBUG] resultImageName에서 ResultRipe 반환")
            return "ResultRipe"
        case "중간":
            print("[DEBUG] resultImageName에서 ResultRipe 반환")
            return "ResultRipe"
        case "낮음":
            print("[DEBUG] resultImageName에서 ResultUnripe 반환 (낮음)")
            return "ResultUnripe"
        default:
            print("[DEBUG] resultImageName에서 ResultUnripe 반환 (default)")
            return "ResultUnripe" // 기본값
        }
    }
}
