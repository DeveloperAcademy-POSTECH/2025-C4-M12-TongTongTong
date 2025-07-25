import Foundation
import AVFoundation
import SwiftUI
import Combine

// 필요한 타입 import
// Coordinator, AudioLevelMonitor, HapticManager, UIConstants, AudioBufferExport, WatermelonAPIService
// -> 모두 같은 타겟 내에 있으므로 별도 import 필요 없음

class MainViewModel: ObservableObject {
    @Published var soundClassifier = SoundClassifier()
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
    // let soundClassifier = SoundClassifier() // CoreML 분류기 제거
    private var debugTimer: Timer?

    func startMicMonitoring(completion: @escaping () -> Void) {
        print("[DEBUG] 마이크 모니터링 시작")
        audioMonitor.stopOnThreeSounds = !showDebugOverlay
        if !showDebugOverlay { isMicActive = true }
        soundCount = 0
        audioMonitor.reset()
        // audioMonitor.setSoundClassifier(soundClassifier) // CoreML 분류기 제거

        audioMonitor.onSoundCountChanged = { count in
            DispatchQueue.main.async {
                if self.showDebugOverlay {
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

        audioMonitor.onThreeSoundsDetected = { [weak self] in
            DispatchQueue.main.async {
                print("[DEBUG] 3번 소리 감지 완료")
                if self?.showDebugOverlay == true {
                    return
                } else {
                    guard let self = self else { return }
                    self.stopMonitoring() // 모니터링 중지
                    completion() // 녹음 완료 화면으로 전환
                }
            }
        }

        audioMonitor.onLoudSound = {
            if self.showDebugOverlay { return }
            print("[DEBUG] 소리 감지됨 (onLoudSound)")
        }

        audioMonitor.startMonitoring()
#if targetEnvironment(simulator)
        showTapInstruction = true
#endif
    }

    // 디버그 모드: 0.5초마다 자동 분석 (CoreML 제거, 필요시 서버 호출로 대체 가능)
    private func startDebugTimer() {
        stopDebugTimer()
        debugTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            print("[DEBUG] 디버그 타이머 tick - 자동 분석 시도")
            // self.analyzeCurrentAudio() // CoreML 분석 제거
        }
    }
    private func stopDebugTimer() {
        debugTimer?.invalidate()
        debugTimer = nil
    }
    // private func analyzeCurrentAudio() { ... } // CoreML 분석 함수 제거

    // 시뮬레이터용 탭 처리 (CoreML 분류 제거, 서버 호출로 대체 가능)
    func handleSimulatorTap(completion: @escaping () -> Void) {
#if targetEnvironment(simulator)
        if isMicActive {
            if showDebugOverlay { return }
            print("[DEBUG] 시뮬레이터 탭 감지")
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
                // 0.5초 뒤에 녹음 완료 화면으로 전환
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.stopMonitoring()
                    completion()
                }
            }
        }
#endif
    }

    func stopRecordingAndAnalyze() {
        if let buffer = self.audioMonitor.latestBuffer {
            do {
                let url = FileManager.default.temporaryDirectory.appendingPathComponent("recorded_sound.wav")
                try AudioBufferExport.writeWAV(buffer: buffer, to: url)

                // 서버로 오디오 파일 전송 및 결과 처리
                WatermelonAPIService.shared.predictWatermelon(audioFile: url) { [weak self] result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let prediction):
                            self?.coordinator?.resultState.update(predicted_class: prediction.predicted_class, probabilities: prediction.probabilities, confidence: prediction.confidence)
                            // 성공 시에만 결과 화면으로 이동
                            self?.coordinator?.goToAnalysis()
                        case .failure(let error):
                            print("[API] 서버 예측 실패: \(error)")
                            // 실패 시 메인 화면으로 돌아가거나 사용자에게 알림
                            self?.coordinator?.goToContent()
                        }
                    }
                }
            } catch {
                print("[API] 파일 저장 실패: \(error)")
                coordinator?.goToContent()
            }
        } else {
            print("버퍼 없음, 분석 실패")
            coordinator?.goToContent()
        }
    }

    func stopMonitoring() {
        print("[DEBUG] 마이크 모니터링 중지")
        audioMonitor.stopMonitoring()
        if !showDebugOverlay { isMicActive = false }
        showTapInstruction = false
        stopDebugTimer()
    }
}

