//
//  MeasurementViewModel.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import Foundation
import Combine
import AVFoundation

final class MeasurementViewModel: ObservableObject {
    @Published var lastLabel: String = "--"
    @Published var lastConfidence: Double = 0
    @Published var isMeasuring: Bool = false
    @Published var audioDataPoints: [AudioDataPoint] = []

    private var recorder: SoundRecorder?
    private var cancellables = Set<AnyCancellable>()
    
    // 오디오 데이터 포인트 구조체
    struct AudioDataPoint: Identifiable {
        let id = UUID()
        let timestamp: Date
        let amplitude: Double
        let confidence: Double
    }

    init() {
        // 초기화 시에는 아무 것도 하지 않음
    }

    func start() {
        lastLabel = "--"
        lastConfidence = 0
        audioDataPoints.removeAll()

        // 새로 recorder 생성
        let newRecorder = SoundRecorder()
        self.recorder = newRecorder

        // 버퍼 구독 연결
        newRecorder.bufferSubject
            .receive(on: DispatchQueue.global(qos: .userInitiated))
            .sink { [weak self] buffer in
                guard let self = self else { return }
                do {
                    let (label, confidence) = try SoundClassifier.shared.predict(from: buffer)
                    print("[DEBUG] 예측 라벨: \(label), 신뢰도: \(confidence)")
                    
                    // 오디오 데이터 처리
                    let amplitude = self.calculateAmplitude(from: buffer)
                    
                    DispatchQueue.main.async {
                        self.lastLabel = label
                        self.lastConfidence = confidence
                        
                        // 오디오 데이터 포인트 추가
                        let dataPoint = AudioDataPoint(timestamp: Date(), amplitude: amplitude, confidence: confidence)
                        self.audioDataPoints.append(dataPoint)
                        
                        // 최대 100개 포인트만 유지
                        if self.audioDataPoints.count > 100 {
                            self.audioDataPoints.removeFirst()
                        }
                    }
                } catch {
                    print("실시간 분류 실패:", error)
                }
            }
            .store(in: &cancellables)

        newRecorder.start()
        isMeasuring = true
    }

    func stop() {
        recorder?.stop()
        isMeasuring = false
        
        // 그래프 데이터를 포함하여 기록 저장
        let graphData = audioDataPoints.map { point in
            SoundRecord.AudioDataPoint(
                timestamp: point.timestamp,
                amplitude: point.amplitude,
                confidence: point.confidence
            )
        }
        
        RecordsViewModel.shared.addRecord(
            label: lastLabel,
            confidence: lastConfidence,
            audioDataPoints: graphData
        )
        
        recorder = nil // 세션 종료 후 recorder 해제
        cancellables.removeAll() // 구독도 해제
    }
    
    // 오디오 버퍼에서 진폭 계산
    private func calculateAmplitude(from buffer: AVAudioPCMBuffer) -> Double {
        guard let channelData = buffer.floatChannelData?[0] else { return 0.0 }
        let frameLength = Int(buffer.frameLength)
        
        var sum: Float = 0.0
        for i in 0..<frameLength {
            sum += abs(channelData[i])
        }
        
        let average = sum / Float(frameLength)
        return Double(average)
    }
}
