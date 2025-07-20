//
//  ContentView 2.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//
import SwiftUI
import AVFoundation

struct MainView: View {
    @StateObject private var viewModel = ContentViewModel()
    @EnvironmentObject var coordinator: Coordinator
    @State private var showCustomAlert = true

    init() {
        print("[MainView] init")
    }

    var body: some View {
        ZStack {
            // MARK: - Main Content
            VStack {
                Spacer().frame(height: UIConstants.topMargin)
                TitleView()
                Spacer()

                // 3번 인식 안내 텍스트
                if viewModel.isMicActive {
                    VStack(spacing: 8) {
                        Text("\(viewModel.soundCount)/3")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)

                        Text("수박을 두드려주세요!")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)

#if targetEnvironment(simulator)
                        if viewModel.showTapInstruction {
                            Text("(시뮬레이터: 수박을 탭하세요)")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white.opacity(0.8))
                                .multilineTextAlignment(.center)
                        }
#endif
                    }
                    .padding(.bottom, 20)
                }

                WatermelonView(isMicActive: viewModel.isMicActive, isRedBackground: viewModel.isRedBackground) {
                    HapticManager.shared.impact(style: .medium) // 햅틱 피드백 추가
                    viewModel.showMicAlert = true
                }
                .onTapGesture {
                    HapticManager.shared.impact(style: .light) // 탭 시 햅틱 피드백
#if targetEnvironment(simulator)
                    if viewModel.isMicActive {
                        viewModel.handleSimulatorTap {
                            coordinator.goToAnalysis()
                        }
                    }
#endif
                }
                .alert("마이크를 켜시겠습니까?", isPresented: $viewModel.showMicAlert) {
                    Button("취소", role: .cancel) {}
                    Button("확인") {
                        viewModel.startMicMonitoring {
                            coordinator.goToAnalysis()
                        }
                    }
                } message: {
                    Text("수박을 3번 두드려서 소리를 감지합니다.\n크게 두드려 주세요!")
                }
                Spacer()
                SeedIndicatorView(highlightIndex: viewModel.highlightIndex, indicatorCount: viewModel.indicatorCount)
                Spacer().frame(height: UIConstants.bottomMargin)
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
                    Color.black.opacity(0.04)
                        .ignoresSafeArea()
                        .contentShape(Rectangle())
                        .onTapGesture { showCustomAlert = false }
                        .blur(radius: 16)

                    VStack {
                        ZStack {
                            VStack(spacing: 20) {
                                Text("TIP")
                                    .font(.system(size: 28, weight: .bold))
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.black)
                                Image("HandWM")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 20)
                                Text("수박에 iPhone을 가까이 대고\n손끝으로 세 번 두드리세요")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.black.opacity(0.8))
                                    .multilineTextAlignment(.center)
                            }
                            .padding(32)
                        }
                        .frame(width: 300, height: 400)
                        .background(.white.opacity(0.8))
                        .background(.black.opacity(0.2))
                        .cornerRadius(24)
                        .shadow(color: .black.opacity(0.08), radius: 8, x: 0, y: 0)
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .inset(by: 0.5)
                                .stroke(.white, lineWidth: 1)
                        )
                        .transition(.opacity)
                    }
                    .offset(y: 38)
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
            viewModel.coordinator = coordinator // 이 줄을 꼭 추가!
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
