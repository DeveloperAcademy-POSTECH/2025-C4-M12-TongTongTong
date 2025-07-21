//
//  MainViewModel.swift
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
    @Published var isMicActive = false {
        didSet {
            // 디버그 모드일 때는 항상 true로 유지
            if showDebugOverlay && isMicActive == false {
                DispatchQueue.main.async {
                    self.isMicActive = true
                }
            }
        }
    }
    @Published var soundCount = 0
    @Published var showTapInstruction = false
    @Published var showDebugOverlay = false {
        didSet {
            if showDebugOverlay {
                print("[DEBUG] 디버그 모드 ON")
                isMicActive = true // 항상 true로 유지
                startMicMonitoring { }
                startDebugTimer()
            } else {
                print("[DEBUG] 디버그 모드 OFF")
                stopDebugTimer()
                stopMonitoring()
            }
        }
    }
    
    // Weak reference to the Coordinator for navigation and state updates
    weak var coordinator: Coordinator?

    let indicatorCount = 3
    let audioMonitor = AudioLevelMonitor()
    let soundClassifier = SoundClassifier()
    private var debugTimer: Timer?
    
    func startMicMonitoring(completion: @escaping () -> Void) {
        print("[DEBUG] 마이크 모니터링 시작")
        // 디버그 모드에서는 3회 감지 후에도 모니터링을 멈추지 않도록 설정
        audioMonitor.stopOnThreeSounds = !showDebugOverlay
        if !showDebugOverlay { isMicActive = true }
        soundCount = 0
        audioMonitor.reset()
        audioMonitor.setSoundClassifier(soundClassifier)
        
        // 소리 카운트 변경 시 UI 업데이트
        audioMonitor.onSoundCountChanged = { count in
            DispatchQueue.main.async {
                if self.showDebugOverlay {
                    // 디버그 모드에서는 카운트/하이라이트 등 UI 업데이트 하지 않음
                    return
                }
                print("[DEBUG] 소리 감지 카운트: \(count)")
                self.soundCount = count
                HapticManager.shared.impact(style: .medium)
                self.highlightIndex = count
                self.isRedBackground = true
                DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                    self.isRedBackground = false
                }
            }
        }
        
        // 3번 인식 완료 시
        audioMonitor.onThreeSoundsDetected = { [weak self] in
            DispatchQueue.main.async {
                print("[DEBUG] 3번 소리 감지 완료")
                if self?.showDebugOverlay == true {
                    // 디버그 모드에서는 아무 동작도 하지 않음 (isMicActive false로 만들지 않음)
                    return
                } else {
                    if let buffer = self?.audioMonitor.latestBuffer {
                        do {
                            let url = FileManager.default.temporaryDirectory.appendingPathComponent("recorded_sound.wav")
                            try AudioBufferExport.writeWAV(buffer: buffer, to: url)
                            self?.coordinator?.resultState.audioFileURL = url // 오디오 파일 경로 저장
                        } catch {
                            print("[API] 파일 저장 실패: \(error)")
                        }
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                        guard let self = self else { return }
                        self.showTapInstruction = false
                        self.isMicActive = false
                        completion()
                    }
                }
            }
        }
        
        // 개별 소리 인식 시 (기존 호환성)
        audioMonitor.onLoudSound = {
            if self.showDebugOverlay { return }
            print("[DEBUG] 소리 감지됨 (onLoudSound)")
        }
        
        audioMonitor.startMonitoring()
        
        // 시뮬레이터에서 탭 안내 표시
#if targetEnvironment(simulator)
        showTapInstruction = true
#endif
    }
    
    // 디버그 모드: 0.5초마다 자동 분석
    private func startDebugTimer() {
        stopDebugTimer()
        debugTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            print("[DEBUG] 디버그 타이머 tick - 자동 분석 시도")
            self.analyzeCurrentAudio()
        }
    }
    private func stopDebugTimer() {
        debugTimer?.invalidate()
        debugTimer = nil
    }
    private func analyzeCurrentAudio() {
        if let buffer = audioMonitor.latestBuffer {
            print("[DEBUG] 오디오 버퍼로 자동 분석 실행")
            soundClassifier.classify(audioBuffer: buffer)
        } else {
            print("[DEBUG] 오디오 버퍼 없음 (자동 분석 skip)")
        }
    }
    
    // 시뮬레이터용 탭 처리
    func handleSimulatorTap(completion: @escaping () -> Void) {
#if targetEnvironment(simulator)
        if isMicActive {
            if showDebugOverlay { return }
            print("[DEBUG] 시뮬레이터 탭 감지")
            // 더미 소리 분류 수행
            soundClassifier.classifyDummySound()
            
            HapticManager.shared.impact(style: .medium)
            
            soundCount += 1
            highlightIndex = soundCount - 1
            isRedBackground = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                self.isRedBackground = false
            }
            
            if soundCount >= 3 {
                if showDebugOverlay { return }
                HapticManager.shared.notification(type: .success)
                // 0.5초 뒤에 화면 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showTapInstruction = false
                    self.isMicActive = false
                    completion()
                }
            }
        }
#endif
    }
    
    func stopMonitoring() {
        print("[DEBUG] 마이크 모니터링 중지")
        audioMonitor.stopMonitoring()
        if !showDebugOverlay { isMicActive = false }
        showTapInstruction = false
        stopDebugTimer()
    }
}

