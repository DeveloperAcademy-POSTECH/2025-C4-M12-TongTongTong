import SwiftUI
import AVFoundation

struct AnalysisView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel: AnalysisViewModel

    init() {
        _viewModel = StateObject(wrappedValue: AnalysisViewModel(coordinator: Coordinator()))
        print("[AnalysisView] init")
    }

    var body: some View {
        let _ = updateViewModelCoordinatorIfNeeded()
        ZStack {
            ZStack {
                VStack(spacing: UIConstants.mainSpacing) {
                    Spacer().frame(height: UIConstants.analysisTopMargin)
                    HStack {
                        Text("소리 분석 중")
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
                            .rotationEffect(.degrees(viewModel.loadingRotation))
                            .offset(x: 2.5)
                            .offset(y: -1.5)
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
            viewModel.onDisappear()
        }
        .onAppear {
            viewModel.onAppear()
        }
    }

    private func updateViewModelCoordinatorIfNeeded() {
        // coordinator가 변경되었을 때 viewModel에 주입
        if viewModel.coordinator !== coordinator {
            viewModel.setCoordinator(coordinator)
        }
    }
}

#Preview {
    AnalysisView()
        .environmentObject(Coordinator())
}
