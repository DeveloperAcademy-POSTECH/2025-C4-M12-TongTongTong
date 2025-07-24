import SwiftUI
import AVFoundation

struct AnalysisView: View {
    @State private var overlayOffsetX: CGFloat = 190
    @State private var overlayOpacity: Double = 0.8
    @State private var loadingRotation: Double = 0
    @EnvironmentObject var coordinator: Coordinator

    init() {
        print("[AnalysisView] init")
    }

    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: UIConstants.mainSpacing) {
                    Spacer().frame(height: UIConstants.analysisTopMargin)
                    HStack {
                        Text("주파수 분석중")
                        Image(systemName: "waveform")
                    }
                    .font(.system(size: UIConstants.resultFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                    ZStack {
                        Image("WholeWatermelon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 540, height: 540)
                            .padding(.bottom, 59)

                        Image("LoadingShadow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 472, height: 472)
                            .rotationEffect(.degrees(loadingRotation))
                    }
                    .offset(x: 200)
                    .offset(y: -48)
                    .shadow(color: .white.opacity(0.5), radius: 60)
                    .onAppear {
                        viewModel.startAnimation()
                    }
                    Spacer()
                }
                Spacer()
            }

            ZStack {
                StarView(imageName: "Star", size: CGSize(width: 20, height: 20), offset: CGSize(width: -80, height: -200))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -100, height: -150))
                StarView(imageName: "Star", size: CGSize(width: 20, height: 20), offset: CGSize(width: -100, height: -100))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -120, height: 30))
                StarView(imageName: "Star", size: CGSize(width: 30, height: 30), offset: CGSize(width: -100, height: 180))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -80, height: 200))
                StarView(imageName: "Star", size: CGSize(width: 30, height: 30), offset: CGSize(width: -40, height: 280))
                StarView(imageName: "Star", size: CGSize(width: 40, height: 40), offset: CGSize(width: 30, height: 300))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.18, green: 0.19, blue: 0.29), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.34, green: 0.33, blue: 0.47), location: 0.70),
                    Gradient.Stop(color: Color(red: 0.43, green: 0.36, blue: 0.47), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .ignoresSafeArea()
        .onDisappear {
            print("[AnalysisView] onDisappear")
        }
        .onAppear {
            print("[AnalysisView] onAppear - 로컬 분석 시작")
            // 3초간 로딩 화면 노출 후 로컬 분석 호출
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                // Coordinator를 통해 MainViewModel의 오디오 버퍼와 분류기를 가져옵니다.
                if let viewModel = coordinator.mainViewModel, let buffer = viewModel.audioMonitor.latestBuffer {
                    viewModel.soundClassifier.classify(audioBuffer: buffer)

                    // --- 오류 수정된 부분 ---
                    // viewModel.soundClassifier.target은 옵셔널이 아니므로 if let을 제거합니다.
                    let result = viewModel.soundClassifier.target

                    // 로컬 분석 결과를 ResultState에 업데이트합니다.
                    if !result.isEmpty, let confidence = viewModel.soundClassifier.probabilities[result] {
                        let prediction = PredictionResponse(success: true, filename: "local_analysis", prediction: 0.0, result: result, confidence: confidence)
                        coordinator.resultState.update(with: prediction)

                        // 결과 화면으로 이동합니다.
                        coordinator.goToResult()
                    } else {
                        print("[AnalysisView] 로컬 분석 실패 또는 결과 없음")
                        coordinator.goToContent() // 실패 시 메인으로
                    }
                } else {
                    print("[AnalysisView] viewModel 또는 audioBuffer를 찾을 수 없음")
                    coordinator.goToContent() // 실패 시 메인으로
                }
            }
        }
    }
}
