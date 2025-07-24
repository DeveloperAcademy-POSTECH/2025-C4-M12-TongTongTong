import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var showCustomAlert = true
    @State private var isTransitioning = false

    init() {
        print("[MainView] init")
    }

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: UIConstants.mainTopMargin)

                WatermelonView(
                    isMicActive: viewModel.isMicActive,
                    isRedBackground: viewModel.isRedBackground
                ) {
                    HapticManager.shared.impact(style: .medium)
                    viewModel.showMicAlert = true
                }
                .onTapGesture {
                    HapticManager.shared.impact(style: .light)
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
                            coordinator.goToRecordingComplete()
                        }
                    }
                } message: {
                    Text("수박을 3번 두드려서 소리를 감지합니다.\n크게 두드려 주세요!")
                }

                Spacer()

                BottomContentView(
                    viewModel: viewModel,
                    isTransitioning: isTransitioning
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)

            DebugOverlayView(
                soundClassifier: viewModel.soundClassifier,
                isVisible: viewModel.showDebugOverlay
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .mainBackground(isRed: viewModel.isRedBackground)
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
