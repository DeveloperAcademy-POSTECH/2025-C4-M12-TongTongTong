import SwiftUI

class ResultState: ObservableObject {
    @Published var confidence: Double = 0
    @Published var result: String = "잘 익음"
    var audioFileURL: URL? = nil

    var ripeness: WatermelonRipeness {
        switch result {
        case "잘 익음":
            return .ripe
        case "너무 익음":
            return .overripe
        case "안 익음":
            return .unripe
        default:
            return .unripe
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
        return ripeness.imageName
    }
    
    func cycleResultForDebug() {
        switch result {
        case "잘 익음":
            result = "안 익음"
        case "안 익음":
            result = "너무 익음"
        case "너무 익음":
            result = "잘 익음"
        default:
            result = "잘 익음"
        }
        print("[DEBUG] cycleResultForDebug() - new result: \(result)")
    }
}

enum WatermelonRipeness {
    case ripe
    case unripe
    case overripe

    var imageName: String {
        switch self {
        case .ripe:
            return "ResultRipe1"
        case .unripe:
            return "ResultUnripe1"
        case .overripe:
            return "ResultOverripe1"
        }
    }

    var starRating: Int {
        switch self {
        case .ripe:
            return 3
        case .unripe:
            return 1
        case .overripe:
            return 2
        }
    }

    var score: Int {
        switch self {
        case .ripe:
            return 95
        case .unripe:
            return 30
        case .overripe:
            return 60
        }
    }

}
