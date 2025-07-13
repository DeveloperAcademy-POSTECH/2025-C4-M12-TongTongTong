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
    @Published var soundCount = 0
    @Published var showTapInstruction = false

    let indicatorCount = 3
    let audioMonitor = AudioLevelMonitor()

    func startMicMonitoring(completion: @escaping () -> Void) {
        isMicActive = true
        soundCount = 0
        audioMonitor.reset()
        
        // 소리 카운트 변경 시 UI 업데이트
        audioMonitor.onSoundCountChanged = { count in
            DispatchQueue.main.async {
                self.soundCount = count
                self.highlightIndex = count - 1
                self.isRedBackground = true
                DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                    self.isRedBackground = false
                }
            }
        }
        
        // 3번 인식 완료 시
        audioMonitor.onThreeSoundsDetected = {
            DispatchQueue.main.async {
                self.isMicActive = false
                completion()
            }
        }
        
        // 개별 소리 인식 시 (기존 호환성)
        audioMonitor.onLoudSound = {
            // 이미 onSoundCountChanged에서 처리하므로 여기서는 추가 처리 없음
        }
        
        audioMonitor.startMonitoring()
        
        // 시뮬레이터에서 탭 안내 표시
        #if targetEnvironment(simulator)
        showTapInstruction = true
        #endif
    }
    
    // 시뮬레이터용 탭 처리
    func handleSimulatorTap(completion: @escaping () -> Void) {
        #if targetEnvironment(simulator)
        if isMicActive {
            soundCount += 1
            highlightIndex = soundCount - 1
            isRedBackground = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                self.isRedBackground = false
            }
            
            if soundCount >= 3 {
                isMicActive = false
                showTapInstruction = false
                HapticManager.shared.notification(type: .success) // 3번 완료 시 성공 햅틱
                // 3번 완료 시 분석 화면으로 이동
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    completion()
                }
            }
        }
        #endif
    }
    
    func stopMonitoring() {
        audioMonitor.stopMonitoring()
        isMicActive = false
        showTapInstruction = false
    }
}
