import Foundation
import AVFoundation

class AudioLevelMonitor: ObservableObject {
    private var audioEngine: AVAudioEngine?
    private var timer: Timer?
    private let threshold: Float = -20 // dB, 이 값보다 크면 소리 감지
    var onLoudSound: (() -> Void)?
    
    func startMonitoring() {
        let engine = AVAudioEngine()
        let inputNode = engine.inputNode
        let bus = 0
        let format = inputNode.inputFormat(forBus: bus)
        inputNode.installTap(onBus: bus, bufferSize: 1024, format: format) { buffer, _ in
            guard let channelData = buffer.floatChannelData?[0] else { return }
            let channelDataValueArray = Array(UnsafeBufferPointer(start: channelData, count: Int(buffer.frameLength)))
            let rms = sqrt(channelDataValueArray.map { $0 * $0 }.reduce(0, +) / Float(buffer.frameLength))
            let avgPower = 20 * log10(rms)
            DispatchQueue.main.async {
                if avgPower > self.threshold {
                    self.onLoudSound?()
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
    
    func stopMonitoring() {
        audioEngine?.stop()
        audioEngine?.inputNode.removeTap(onBus: 0)
        audioEngine = nil
    }
} 