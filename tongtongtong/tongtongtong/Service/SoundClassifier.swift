import Foundation
import CoreML
import AVFoundation

class SoundClassifier: ObservableObject {
    @Published var target: String = ""
    @Published var probabilities: [String: Double] = [:]

    private var model: MLModel?
    private let inputLength = 15600
    private let classLabels = ["etc", "음이 낮은", "음이 높은"]

    init() {
        loadModel()
    }

    private func loadModel() {
        guard let url = Bundle.main.url(forResource: "SoundWaterMelon 9", withExtension: "mlmodelc") else {
            print("⚠️ SoundWaterMelonETC.mlmodelc 파일을 찾을 수 없습니다.")
            return
        }
        do {
            model = try MLModel(contentsOf: url)
            print("✅ SoundWaterMelonETC 모델 로드 성공")
        } catch {
            print("❌ 모델 로드 실패: \(error)")
        }
    }

    func classify(audioBuffer: AVAudioPCMBuffer) {
        guard let model = model else { return }
        guard let inputArray = bufferToMLMultiArray(buffer: audioBuffer) else { return }
        let input = try? MLDictionaryFeatureProvider(dictionary: ["audioSamples": MLFeatureValue(multiArray: inputArray)])
        guard let prediction = try? model.prediction(from: input!) else { return }

        if let target = prediction.featureValue(for: "target")?.stringValue {
            self.target = target
        }
        if let probDict = prediction.featureValue(for: "targetProbability")?.dictionaryValue as? [String: Double] {
            self.probabilities = probDict
        }
    }

    private func bufferToMLMultiArray(buffer: AVAudioPCMBuffer) -> MLMultiArray? {
        let needed = inputLength
        guard let channelData = buffer.floatChannelData?[0] else { return nil }
        let frameLength = Int(buffer.frameLength)
        guard let array = try? MLMultiArray(shape: [NSNumber(value: needed)], dataType: .float32) else { return nil }
        for i in 0..<needed {
            if i < frameLength {
                array[i] = NSNumber(value: channelData[i])
            } else {
                array[i] = 0
            }
        }
        return array
    }

    // 시뮬레이터/테스트용 더미 분류
    func classifyDummySound() {
        let randomTarget = classLabels.randomElement() ?? "etc"
        // 3개 클래스의 확률을 랜덤하게 생성 (합이 1)
        var probs = [Double.random(in: 0.0...1.0), Double.random(in: 0.0...1.0), Double.random(in: 0.0...1.0)]
        let sum = probs.reduce(0, +)
        probs = probs.map { $0 / sum }
        self.target = randomTarget
        self.probabilities = [
            classLabels[0]: probs[0],
            classLabels[1]: probs[1],
            classLabels[2]: probs[2]
        ]
    }
} 
