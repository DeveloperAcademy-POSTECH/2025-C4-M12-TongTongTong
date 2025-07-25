import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject private var viewModel = MainViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var showCustomAlert = true
    
    init() {
        print("[MainView] init")
    }
    
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                    .frame(height: UIConstants.mainTopMargin)
                
                WatermelonView(
                    isMicActive: viewModel.isMicActive
                ) {
                    HapticManager.shared.impact(style: .medium)
                    coordinator.goToRecordingGuide()
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
                
                BottomContentView(
                    viewModel: viewModel
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops : [
                    .init(color: ColorConstants.blueGradientStart, location: 0.15),
                    .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            ))
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
