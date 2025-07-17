import Foundation
import AVFoundation

class AudioLevelMonitor: ObservableObject {
    /// Determines whether monitoring should stop after detecting three sounds
    var stopOnThreeSounds: Bool = true

    private var audioEngine: AVAudioEngine?
    private var timer: Timer?
    private let threshold = AudioConstants.threshold
    private var soundCount: Int = 0
    private var isInCooldown = false
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
            print("[DEBUG] channelDataValueArray head: \(channelDataValueArray.prefix(10)) tail: \(channelDataValueArray.suffix(10))")
            print("[DEBUG] frameLength: \(buffer.frameLength), min: \(channelDataValueArray.min() ?? 0), max: \(channelDataValueArray.max() ?? 0)")
            let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            let avgPower = 20 * log10(rms)
            
            DispatchQueue.main.async {
                if avgPower > self.threshold && !self.isInCooldown {
                    let bufferToClassify: AVAudioPCMBuffer
                    if buffer.format.sampleRate != 22050 {
                        if let downsampled = self.downsampleBufferTo16kHz(buffer, originalFormat: format) {
                            bufferToClassify = downsampled
                        } else {
                            bufferToClassify = buffer
                        }
                    } else {
                        bufferToClassify = buffer
                    }
                    self.soundClassifier?.classify(audioBuffer: bufferToClassify)
                    self.handleLoudSound()
                }
            }
        }
        
        do {
            try engine.start()
            audioEngine = engine
            let actualInputFormat = engine.inputNode.inputFormat(forBus: bus)
            print("[DEBUG] actual audio engine input format sampleRate after start: \(actualInputFormat.sampleRate)")
        } catch {
            print("Audio engine start error: \(error)")
        }
    }
    
    private func downsampleBufferTo16kHz(_ buffer: AVAudioPCMBuffer, originalFormat: AVAudioFormat) -> AVAudioPCMBuffer? {
        let targetFormat = AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16000, channels: buffer.format.channelCount, interleaved: false)!
        guard let converter = AVAudioConverter(from: originalFormat, to: targetFormat) else { return nil }
        let ratio = Double(targetFormat.sampleRate) / Double(originalFormat.sampleRate)
        let frameCapacity = AVAudioFrameCount(Double(buffer.frameLength) * ratio)
        guard let newBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: frameCapacity) else { return nil }
        var error: NSError? = nil
        let inputBlock: AVAudioConverterInputBlock = { _, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }
        converter.convert(to: newBuffer, error: &error, withInputFrom: inputBlock)
        if let error = error {
            print("[DEBUG] AVAudioConverter error: \(error)")
            return nil
        }
        newBuffer.frameLength = frameCapacity
        return newBuffer
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

