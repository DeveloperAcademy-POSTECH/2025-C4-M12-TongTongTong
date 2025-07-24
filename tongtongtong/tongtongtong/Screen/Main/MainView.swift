import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject private var viewModel = ContentViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var showCustomAlert = true
    @State private var isTransitioning = false
    
    init() {
        print("[MainView] init")
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer().frame(height: UIConstants.mainTopMargin)
              
                WatermelonView(isMicActive: viewModel.isMicActive, isRedBackground: viewModel.isRedBackground) {
                    HapticManager.shared.impact(style: .medium) // 햅틱 피드백 추가
                    viewModel.showMicAlert = true
                }
                .onTapGesture {
                    HapticManager.shared.impact(style: .light) // 탭 시 햅틱 피드백
#if targetEnvironment(simulator)
                    if viewModel.isMicActive {
                        viewModel.handleSimulatorTap {
                            coordinator.goToRecordingComplete()
                        }
                    }
#endif
                }
                .alert("마이크를 켜시겠습니까?", isPresented: $viewModel.showMicAlert) {
                    Button("취소", role: .cancel) {}
                    Button("확인") {
                        viewModel.startMicMonitoring {
                            isTransitioning = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { coordinator.goToRecordingComplete()
                            }
                        }
                    }
                } message: {
                    Text("수박을 3번 두드려서 소리를 감지합니다.\n크게 두드려 주세요!")
                }
                Spacer()
                VStack {
                    TitleView(isMicActive: viewModel.isMicActive)
                    Spacer()
                    if viewModel.isMicActive {
                        SeedIndicatorView(highlightIndex: viewModel.highlightIndex, indicatorCount: viewModel.indicatorCount)
                            .padding(.bottom, UIConstants.bottomMargin)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            
            // MARK: - Debug Overlay (항상 맨 위)
            DebugOverlayView(
                soundClassifier: viewModel.soundClassifier,
                isVisible: viewModel.showDebugOverlay
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: viewModel.isRedBackground ? [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientMedium, location: 0.20),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ] : [
                    .init(color: ColorConstants.blueGradientStart, location: 0.15),
                    .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: viewModel.isRedBackground)
        )
        .ignoresSafeArea()
        .onAppear {
            print("[MainView] onAppear")
            coordinator.mainViewModel = viewModel
            viewModel.coordinator = coordinator
        }
        .onDisappear {
            print("[MainView] onDisappear")
        }
    }
}

#Preview {
    MainView()
        .environmentObject(Coordinator())
}
