import Foundation
import AVFoundation

class RecordingViewModel: ObservableObject {
    @Published var highlightIndex = 0
    @Published var isRedBackground = false
    @Published var showTapInstruction = false
    @Published var isMicActive = false {
        didSet {
            // 디버그 모드면 언제나 켜두기
            if showDebugOverlay && !isMicActive {
                DispatchQueue.main.async { self.isMicActive = true }
            }
        }
    }
    @Published var soundCount = 0

    /// 디버그 모드로 자동 분석 실행 여부
    @Published var showDebugOverlay = false {
        didSet {
            if showDebugOverlay {
                print("[DEBUG] 디버그 모드 ON")
                isMicActive = true
                startMonitoring(completion: { })
                startDebugTimer()
            } else {
                print("[DEBUG] 디버그 모드 OFF")
                stopDebugTimer()
                stopMonitoring()
            }
        }
    }

    // MARK: — 내부 프로퍼티
    private let audioMonitor = AudioLevelMonitor()
    private let soundClassifier = SoundClassifier()
    private var debugTimer: Timer?

    /// 녹음 완료 시 전달되는 콜백
    var onRecordingCompleted: ((URL?) -> Void)?

    // MARK: — 녹음 시작 · 중지
    func startMonitoring(completion: @escaping () -> Void) {
        print("[RecordingViewModel] 마이크 모니터링 시작")
        audioMonitor.stopOnThreeSounds = !showDebugOverlay
        if !showDebugOverlay { isMicActive = true }
        soundCount = 0
        highlightIndex = 0
        isRedBackground = false
        showTapInstruction = false

        audioMonitor.reset()
        audioMonitor.setSoundClassifier(soundClassifier)

        audioMonitor.onSoundCountChanged = { [weak self] count in
            guard let self = self, !self.showDebugOverlay else { return }
            DispatchQueue.main.async {
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
            guard let self = self else { return }
            DispatchQueue.main.async {
                print("[DEBUG] 3번 소리 감지 완료")
                if self.showDebugOverlay { return }
                // — 파일 저장
                var urlToSend: URL? = nil
                if let buffer = self.audioMonitor.latestBuffer {
                    let url = FileManager.default.temporaryDirectory
                        .appendingPathComponent("recorded_sound.wav")
                    do {
                        try self.audioMonitor.exportFullRecording(to: url)
                        self.audioMonitor.clearRecording()
                        urlToSend = url
                    } catch {
                        print("[RecordingViewModel] 파일 저장 실패:", error)
                    }
                }
                // — UI 리셋 & 콜백
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showTapInstruction = false
                    self.isMicActive = false
                    completion()
                    self.onRecordingCompleted?(urlToSend)
                }
            }
        }

        audioMonitor.onLoudSound = {
            if !self.showDebugOverlay {
                print("[RecordingViewModel] 소리 감지됨 (onLoudSound)")
            }
        }

        audioMonitor.startMonitoring()

        #if targetEnvironment(simulator)
        showTapInstruction = true
        #endif
    }

    func stopMonitoring() {
        print("[RecordingViewModel] 마이크 모니터링 중지")
        audioMonitor.stopMonitoring()
        if !showDebugOverlay { isMicActive = false }
        showTapInstruction = false
        stopDebugTimer()
    }

    // MARK: — 디버그 타이머
    private func startDebugTimer() {
        stopDebugTimer()
        debugTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            guard let self = self, let buffer = self.audioMonitor.latestBuffer else { return }
            print("[DEBUG] 디버그 타이머 tick — 자동 분석 시도")
            self.soundClassifier.classify(audioBuffer: buffer)
        }
    }
    private func stopDebugTimer() {
        debugTimer?.invalidate()
        debugTimer = nil
    }

    // MARK: — 시뮬레이터 탭 대응
    func handleSimulatorTapIfNeeded(completion: @escaping () -> Void) {
        #if targetEnvironment(simulator)
        guard isMicActive && !showDebugOverlay else { return }
        print("[RecordingViewModel] 시뮬레이터 탭 감지")
        soundClassifier.classifyDummySound()
        HapticManager.shared.impact(style: .medium)

        soundCount += 1
        highlightIndex = soundCount
        isRedBackground = true
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
            self.isRedBackground = false
        }

        if soundCount >= 3 {
            HapticManager.shared.notification(type: .success)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showTapInstruction = false
                self.isMicActive = false
                completion()
                self.onRecordingCompleted?(nil)
            }
        }
        #endif
    }
}
