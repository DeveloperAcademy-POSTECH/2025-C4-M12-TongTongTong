//
//  SoundRecord.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import Foundation
import AVFoundation
import Combine

struct SoundRecord: Identifiable, Codable {
    let id = UUID()
    let timestamp: Date
    let label: String
    let confidence: Double
    let audioDataPoints: [AudioDataPoint]
    
    // AudioDataPoint 구조체 정의
    struct AudioDataPoint: Identifiable, Codable {
        let id = UUID()
        let timestamp: Date
        let amplitude: Double
        let confidence: Double
    }
}

final class SoundRecorder: ObservableObject {
    private let engine = AVAudioEngine()
    private let bus = 0
    private let bufferSize: AVAudioFrameCount = 2048
    private let sampleRate: Double
    let bufferSubject = PassthroughSubject<AVAudioPCMBuffer, Never>()

    init() {
        let input = engine.inputNode
        sampleRate = input.outputFormat(forBus: bus).sampleRate

        input.installTap(onBus: bus, bufferSize: bufferSize, format: nil) { [weak self] buffer, _ in
            self?.bufferSubject.send(buffer)
        }
    }

    func start() {
#if canImport(AVFoundation) && !os(macOS)
        try? AVAudioSession.sharedInstance().setCategory(.record, mode: .default)
        try? AVAudioSession.sharedInstance().setActive(true)
#endif
        engine.prepare()
        try? engine.start()
    }

    func stop() {
        engine.stop()
        engine.inputNode.removeTap(onBus: bus)
    }
}
