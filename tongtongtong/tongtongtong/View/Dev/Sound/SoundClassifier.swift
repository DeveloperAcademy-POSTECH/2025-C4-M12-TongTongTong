//
//  SoundClassifier.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import CoreML
import AVFoundation

final class SoundClassifier {
    static let shared = SoundClassifier()
    private let model: WMSDD

    private init() {
        model = try! WMSDD(configuration: .init())
    }

    func predict(from buffer: AVAudioPCMBuffer) throws -> (String, Double) {
        // 버퍼를 MLMultiArray로 변환
        guard let floatData = buffer.floatChannelData?[0] else {
            throw NSError(domain: "AudioError", code: -1, userInfo: nil)
        }
        let frameLength = Int(buffer.frameLength)
        let array = try MLMultiArray(shape: [NSNumber(value: frameLength)], dataType: .float32)
        for i in 0..<frameLength {
            array[i] = NSNumber(value: floatData[i])
        }
        // 모델에 입력
        let output = try model.prediction(audioSamples: array)
        let label = output.target
        let conf = output.targetProbability[label] ?? 0
        return (label, conf)
    }
}
