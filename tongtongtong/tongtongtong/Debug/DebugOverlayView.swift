import SwiftUI

struct DebugOverlayView: View {
    @ObservedObject var soundClassifier: SoundClassifier
    let isVisible: Bool
    
    private let classLabels = ["etc", "음이 낮은", "음이 높은"]
    
    var body: some View {
        if isVisible {
            VStack(alignment: .leading, spacing: 8) {
                // 헤더
                HStack {
                    Text("🔍 디버그 모드")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
                
                // 모델 정보
                VStack(alignment: .leading, spacing: 6) {
                    // 예측 클래스
                    HStack {
                        Text("예측 결과:")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.8))
                        Spacer()
                        Text(soundClassifier.target)
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
                    }
                    // 3개 클래스 확률 표시
                    ForEach(classLabels, id: \.self) { label in
                        HStack {
                            Text(label)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                            Spacer()
                            Text("\(String(format: "%.1f", (soundClassifier.probabilities[label] ?? 0) * 100))%")
                                .font(.system(size: 12, weight: .bold))
                                .foregroundColor(label == soundClassifier.target ? .green : .white)
                        }
                        // 확률 바
                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.white.opacity(0.2))
                                    .frame(height: 4)
                                    .cornerRadius(2)
                                Rectangle()
                                    .fill(label == soundClassifier.target ? Color.green : Color.blue)
                                    .frame(width: geometry.size.width * CGFloat(soundClassifier.probabilities[label] ?? 0), height: 4)
                                    .cornerRadius(2)
                                    .animation(.easeInOut(duration: 0.3), value: soundClassifier.probabilities[label] ?? 0)
                            }
                        }
                        .frame(height: 4)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(Color.black.opacity(0.7))
                .cornerRadius(8)
            }
            .padding(.horizontal, 16)
            .padding(.top, 100)
            .transition(.opacity.combined(with: .move(edge: .top)))
            .animation(.easeInOut(duration: 0.3), value: isVisible)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
            .ignoresSafeArea()
        DebugOverlayView(
            soundClassifier: {
                let classifier = SoundClassifier()
                classifier.target = "음이 높은"
                classifier.probabilities = ["etc": 0.12, "음이 낮은": 0.23, "음이 높은": 0.65]
                return classifier
            }(),
            isVisible: true
        )
    }
} 