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
            // MARK: - Main Content
            VStack {
                Spacer().frame(height: UIConstants.topMargin)
                TitleView(isMicActive: viewModel.isMicActive, isTransitioning: isTransitioning)
                Spacer()
                
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
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                coordinator.goToRecordingComplete()
                            }
                        }
                    }
                } message: {
                    Text("수박을 3번 두드려서 소리를 감지합니다.\n크게 두드려 주세요!")
                }
                Spacer()
                SeedIndicatorView(highlightIndex: viewModel.highlightIndex, indicatorCount: viewModel.indicatorCount)
                    .padding(.bottom, UIConstants.bottomMargin)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .zIndex(0)
            
            // MARK: - Debug Overlay (항상 맨 위)
            DebugOverlayView(
                soundClassifier: viewModel.soundClassifier,
                isVisible: viewModel.showDebugOverlay
            )
        }
        .overlay(
            Group {
                if showCustomAlert {
                    ZStack {
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .contentShape(Rectangle())
                            .onTapGesture { showCustomAlert = false }
                        
                        VStack {
                            ZStack {
                                VStack {
                                    Text("TIP")
                                        .font(.system(size: 28, weight: .bold))
                                        .multilineTextAlignment(.center)
                                        .foregroundColor(.black)
                                        .padding(.bottom, 20)
                                    
                                    Image("HandWM")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 190)
                                        .padding(.bottom, 10)
                                    
                                    Text("수박에 iPhone을 가까이 대고\n손 끝으로 세 번 두드리세요")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.black.opacity(0.8))
                                        .multilineTextAlignment(.center)
                                }
                                .padding(16)
                                
                                Button(action: {
                                    withAnimation {
                                        showCustomAlert = false
                                    }
                                }) {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.black.opacity(0.6))
                                        .padding(16)
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                                .padding()
                            }
                            .frame(width: 300, height: 400)
                            .background(.white.opacity(0.8))
                            .background(.black.opacity(0.2))
                            .cornerRadius(24)
                            .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 0)
                            .overlay(
                                RoundedRectangle(cornerRadius: 24)
                                    .inset(by: 0.5)
                                    .stroke(.white.opacity(0.8), lineWidth: 1)
                            )
                            .transition(.opacity)
                        }
                        .onTapGesture {
                            withAnimation {
                                showCustomAlert = false
                            }
                        }
                    }
                    .ignoresSafeArea()
                }
            }
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: viewModel.isRedBackground ? [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ] : [
                    .init(color: ColorConstants.blueGradientStart, location: 0.20),
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
