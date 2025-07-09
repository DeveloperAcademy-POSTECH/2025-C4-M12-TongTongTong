//
//  Untitled.swift
//  tongtongtong
//
//  Created by Leo on 7/9/25.
//

import Foundation
import AVFoundation

class ContentViewModel: ObservableObject {
    @Published var highlightIndex = 0
    @Published var isRedBackground = false
    @Published var showMicAlert = false
    @Published var isMicActive = false
    @Published var isResultActive = false

    let indicatorCount = 3
    let audioMonitor = AudioLevelMonitor()

    func startMicMonitoring() {
        isMicActive = true
        audioMonitor.onLoudSound = {
            self.highlightIndex = (self.highlightIndex + 1) % self.indicatorCount
            self.isRedBackground = true
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                self.isRedBackground = false
            }
        }
        audioMonitor.startMonitoring()
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.micMonitoringDuration) {
            self.audioMonitor.stopMonitoring()
            self.isMicActive = false
            self.isResultActive = true
        }
    }
}
