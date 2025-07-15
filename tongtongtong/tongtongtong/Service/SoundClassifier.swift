import Foundation
import CoreML
import AVFoundation

// Core ML 모델을 이용한 사운드 분류기 클래스
class SoundClassifier: ObservableObject {
    // 분류 결과(타겟 레이블)
    @Published var target: String = ""
    // 각 클래스별 확률
    @Published var probabilities: [String: Double] = [:]

    // Core ML 모델 객체 (createML로 학습 및 변환된 모델)
    private var model: MLModel?
    // 입력 데이터 길이 (프레임 개수)
    private let inputLength = 3000
    // 분류 클래스 레이블 목록
    private let classLabels = ["etc", "음이 낮은", "음이 높은"]
    // 누적용 오디오 버퍼
    private var accumulatedBuffer: [Float] = []

    init() {
        loadModel()
    }

    // createML로 만든 Core ML 모델을 번들에서 불러옵니다
    private func loadModel() {
        // 모델 파일(.mlmodelc) 경로 찾기
        guard let url = Bundle.main.url(forResource: "SoundWaterMelon 11", withExtension: "mlmodelc") else {
            print("⚠️ SoundWaterMelonETC.mlmodelc 파일을 찾을 수 없습니다.")
            return
        }
        print("[DEBUG] 모델 경로: \(url)")
        do {
            // 모델 로드 시도
            model = try MLModel(contentsOf: url)
            print("✅ SoundWaterMelonETC 모델 로드 성공")
        } catch {
            print("❌ 모델 로드 실패: \(error)")
        }
    }

    // 오디오 버퍼를 모델에 넣어 분류합니다
    func classify(audioBuffer: AVAudioPCMBuffer) {
        guard let model = model else {
            print("[DEBUG] 모델이 아직 로드되지 않았습니다.")
            return
        }
        guard let channelData = audioBuffer.floatChannelData?[0] else {
            print("[DEBUG] 채널 데이터 없음")
            return
        }
        let frameLength = Int(audioBuffer.frameLength)
        print("[DEBUG] 입력 오디오 버퍼 프레임 길이: \(frameLength)")

        // 누적 버퍼에 새 데이터 추가
        accumulatedBuffer.append(contentsOf: UnsafeBufferPointer(start: channelData, count: frameLength))
        print("[DEBUG] accumulatedBuffer 현재 길이: \(accumulatedBuffer.count)")

        // 누적된 샘플이 충분할 때만 예측 수행
        while accumulatedBuffer.count >= inputLength {
            // 앞서 16000개 샘플을 MLMultiArray로 변환
            let inputSamples = Array(accumulatedBuffer.prefix(inputLength))
            guard let inputArray = bufferToMLMultiArray(buffer: inputSamples) else {
                print("[DEBUG] MLMultiArray 변환 실패")
                return
            }
            print("[DEBUG] MLMultiArray 변환 성공. shape: \(inputArray.shape)")

            // 모델 입력 형식에 맞게 FeatureProvider 생성
            let input = try? MLDictionaryFeatureProvider(dictionary: ["audioSamples": MLFeatureValue(multiArray: inputArray)])
            // Core ML 모델에 입력하여 예측 실행
            guard let prediction = try? model.prediction(from: input!) else {
                print("[DEBUG] 모델 예측 실패")
                return
            }
            print("[DEBUG] 모델 예측 성공")
            // 예측된 클래스(타겟) 추출
            if let target = prediction.featureValue(for: "target")?.stringValue {
                print("[DEBUG] 예측된 타겟: \(target)")
                self.target = target
            }
            // 클래스별 확률 딕셔너리 추출
            if let probDict = prediction.featureValue(for: "targetProbability")?.dictionaryValue as? [String: Double] {
                print("[DEBUG] 예측된 확률: \(probDict)")
                self.probabilities = probDict
            }
            // 사용한 16000개 샘플 제거
            accumulatedBuffer.removeFirst(inputLength)
            print("[DEBUG] accumulatedBuffer 길이 제거 후: \(accumulatedBuffer.count)")
        }
    }

    // 오디오 버퍼(PCM)를 MLMultiArray로 변환 (모델 입력에 필요한 형태)
    private func bufferToMLMultiArray(buffer: AVAudioPCMBuffer) -> MLMultiArray? {
        let needed = inputLength
        // 첫 번째 채널 데이터 획득
        guard let channelData = buffer.floatChannelData?[0] else {
            print("[DEBUG] 채널 데이터 없음")
            return nil
        }
        let frameLength = Int(buffer.frameLength)
        print("[DEBUG] bufferToMLMultiArray - frameLength: \(frameLength)")
        // MLMultiArray 생성 (입력 크기 맞춤)
        guard let array = try? MLMultiArray(shape: [NSNumber(value: needed)], dataType: .float32) else {
            print("[DEBUG] MLMultiArray 생성 실패")
            return nil
        }
        // 오디오 데이터를 복사, 부족하면 0으로 패딩
        for i in 0..<needed {
            if i < frameLength {
                array[i] = NSNumber(value: channelData[i])
            } else {
                array[i] = 0
            }
        }
        print("[DEBUG] MLMultiArray 변환 완료")
        return array
    }

    // float 배열을 MLMultiArray로 변환하는 오버로드 함수
    private func bufferToMLMultiArray(buffer: [Float]) -> MLMultiArray? {
        let needed = inputLength
        guard buffer.count >= needed else {
            print("[DEBUG] 입력 배열 길이 부족: \(buffer.count)")
            return nil
        }
        guard let array = try? MLMultiArray(shape: [NSNumber(value: needed)], dataType: .float32) else {
            print("[DEBUG] MLMultiArray 생성 실패")
            return nil
        }
        for i in 0..<needed {
            array[i] = NSNumber(value: buffer[i])
        }
        print("[DEBUG] MLMultiArray 변환 완료 (float 배열 버전)")
        return array
    }

    // 시뮬레이터/테스트 환경용 더미 분류 함수 (모델 없이 랜덤으로 값 생성)
    func classifyDummySound() {
        let randomTarget = classLabels.randomElement() ?? "etc"
        // 3개 클래스 확률을 랜덤하게 생성 (합계 1)
        var probs = [Double.random(in: 0.0...1.0), Double.random(in: 0.0...1.0), Double.random(in: 0.0...1.0)]
        let sum = probs.reduce(0, +)
        probs = probs.map { $0 / sum }
        print("[DEBUG] 더미 분류 타겟: \(randomTarget)")
        print("[DEBUG] 더미 확률: \([classLabels[0]: probs[0], classLabels[1]: probs[1], classLabels[2]: probs[2]])")
        self.target = randomTarget
        self.probabilities = [
            classLabels[0]: probs[0],
            classLabels[1]: probs[1],
            classLabels[2]: probs[2]
        ]
    }
} 
