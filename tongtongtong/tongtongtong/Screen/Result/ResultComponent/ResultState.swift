import SwiftUI

class ResultState: ObservableObject {
    @Published var confidence: Double = 0
    @Published var result: String = "잘 익음"
    var audioFileURL: URL? = nil

    var ripeness: WatermelonRipeness {
        switch result {
        case "잘 익음":
            return .ripe
        default:
            return .unripe
        }
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
    
    func update(result: String, confidence: Double) {
        print("[DEBUG] update(result:confidence:) - 받아온 result: \(result), confidence: \(confidence)")
        self.result = result
        self.confidence = confidence
        print("[DEBUG] update(with:) - 저장된 result: \(self.result), confidence: \(self.confidence)")
    }

    var resultImageName: String {
        print("[DEBUG] resultImageName 호출 - result: \(result)")
        switch result {
        case "잘 익음":
            print("[DEBUG] resultImageName에서 ResultRipe 반환")
            return "ResultRipe"
        default:
            print("[DEBUG] resultImageName에서 ResultUnripe 반환 (default)")
            return "ResultUnripe"
        }
    }
}
