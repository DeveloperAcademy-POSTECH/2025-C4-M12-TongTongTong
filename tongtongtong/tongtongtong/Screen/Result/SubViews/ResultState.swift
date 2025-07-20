//
//  ResultState.swift
//  tongtongtong
//
//  Created by 조유진 on 7/20/25.
//

import SwiftUI

class ResultState: ObservableObject {
    @Published var confidence: Double = 0
    @Published var result: String = "높음"
    
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
    
    func update(with prediction: PredictionResponse) {
        print("[DEBUG] update(with:) - 받아온 prediction.result: \(prediction.result), prediction.confidence: \(prediction.confidence)")
        self.confidence = prediction.confidence
        self.result = prediction.result
        print("[DEBUG] update(with:) - 저장된 result: \(self.result), confidence: \(self.confidence)")
    }

    var resultImageName: String {
        print("[DEBUG] resultImageName 호출 - result: \(result)")
        switch result {
        case "높음":
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
