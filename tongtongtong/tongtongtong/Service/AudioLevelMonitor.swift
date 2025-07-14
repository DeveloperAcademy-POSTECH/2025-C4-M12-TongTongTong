import Foundation
import AVFoundation



class AudioLevelMonitor: ObservableObject {
    /// Determines whether monitoring should stop after detecting three sounds
    var stopOnThreeSounds: Bool = true

    private var audioEngine: AVAudioEngine?
    private var timer: Timer?
    private let threshold: Float = AudioConstants.threshold
    private var soundCount: Int = 0
    private var isInCooldown: Bool = false
    private var cooldownTimer: Timer?
    private var soundClassifier: SoundClassifier?
    
    // 최근 오디오 버퍼 저장
    private(set) var latestBuffer: AVAudioPCMBuffer?
    
    var onLoudSound: (() -> Void)?
    var onThreeSoundsDetected: (() -> Void)?
    var onSoundCountChanged: ((Int) -> Void)?
    
    func setSoundClassifier(_ classifier: SoundClassifier) {
        soundClassifier = classifier
    }

    func startMonitoring() {
        #if targetEnvironment(simulator)
        print("Running in Simulator - skipping microphone setup.")
        // 시뮬레이터에서는 3번 탭으로 시뮬레이션
        simulateThreeSounds()
        return
        #endif
        
        let engine = AVAudioEngine()
        let inputNode = engine.inputNode
        let bus = AudioConstants.busIndex
        let format = inputNode.inputFormat(forBus: bus)
        
        inputNode.installTap(onBus: bus, bufferSize: AudioConstants.bufferSize, format: format) { buffer, _ in
            // 최신 버퍼 저장
            self.latestBuffer = buffer
            guard let channelData = buffer.floatChannelData?[0] else { return }
            let channelDataValueArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
            let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            let avgPower = 20 * log10(rms)
            
            DispatchQueue.main.async {
                if avgPower > self.threshold && !self.isInCooldown {
                    // 소리 분류 수행
                    self.soundClassifier?.classify(audioBuffer: buffer)
                    self.handleLoudSound()
                }
            }
        }
        
        do {
            try engine.start()
            audioEngine = engine
        } catch {
            print("Audio engine start error: \(error)")
        }
    }
    
    private func handleLoudSound() {
        // 쿨다운 시작
        isInCooldown = true
        cooldownTimer?.invalidate()
        cooldownTimer = Timer.scheduledTimer(withTimeInterval: AudioConstants.cooldownDuration, repeats: false) { _ in
            self.isInCooldown = false
        }
        
        // 소리 카운트 증가
        soundCount += 1
        onSoundCountChanged?(soundCount)
        onLoudSound?()
        
        // 3번 인식 완료 시
        if soundCount >= 3 {
            HapticManager.shared.notification(type: .success) // 성공 햅틱
            if stopOnThreeSounds {
                stopMonitoring()
            }
            onThreeSoundsDetected?()
        }
    }
    
    private func simulateThreeSounds() {
        // 시뮬레이터용 3번 탭 시뮬레이션
        print("Simulator mode: Tap 3 times to simulate sound detection")
    }

    func stopMonitoring() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: AudioConstants.busIndex)
        audioEngine = nil
        cooldownTimer?.invalidate()
        cooldownTimer = nil
    }
    
    func reset() {
        soundCount = 0
        isInCooldown = false
        cooldownTimer?.invalidate()
        cooldownTimer = nil
        onSoundCountChanged?(soundCount)
    }
}


