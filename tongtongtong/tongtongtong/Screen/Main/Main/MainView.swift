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
        GeometryReader { geometry in
            ZStack {
                VStack {
                    Spacer().frame(height: UIConstants.mainTopMargin)
                    
                    WatermelonView(
                        isMicActive: viewModel.isMicActive
                    ) {
                        HapticManager.shared.impact(style: .medium)
                        coordinator.goToRecordingGuide()
                    }
                    .onTapGesture {
                        HapticManager.shared.impact(style: .light)
                    }
                    
                    Spacer().frame(height: 66)
                    
                    BottomContentView(
                        viewModel: viewModel
                    )
                    
                    Spacer()
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .zIndex(0)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                LinearGradient(
                    stops : [
                        .init(color: ColorConstants.blueGradientStart, location: 0.15),
                        .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                ))
            
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
}

#Preview {
    MainView()
        .environmentObject(Coordinator())
}
