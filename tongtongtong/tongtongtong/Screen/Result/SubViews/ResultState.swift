//
//  ResultState.swift
//  tongtongtong
//
//  Created by 조유진 on 7/20/25.
//

import SwiftUI

class ResultState: ObservableObject {
    @Published var confidence: Double = 0.5
    @Published var result: String = "높음"
    
    var isRipe: Bool {
        result == "높음" && confidence >= 0.5
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
        print("[DEBUG] result: \(result), confidence: \(confidence)")
        self.confidence = prediction.confidence
        self.result = prediction.result
    }
}
