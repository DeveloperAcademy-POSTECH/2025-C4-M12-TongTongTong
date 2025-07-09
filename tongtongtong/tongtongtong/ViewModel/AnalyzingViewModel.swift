//
//  AnalyzingViewModel.swift
//  tongtongtong
//
//  Created by Leo on 7/9/25.
//

import Foundation
import Combine

class AnalyzingViewModel: ObservableObject {
    @Published var shouldNavigateToResult = false

    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.shouldNavigateToResult = true
        }
    }
}
