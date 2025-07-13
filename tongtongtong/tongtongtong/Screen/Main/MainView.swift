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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: viewModel.isRedBackground ? [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ] : [
                    .init(color: ColorConstants.greenGradientStart, location: 0.20),
                    .init(color: ColorConstants.greenGradientEnd, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: viewModel.isRedBackground)
        )
        .ignoresSafeArea()
        .onAppear {
            print("[MainView] onAppear")
        }
        .onDisappear {
            print("[MainView] onDisappear")
        }
    }
}
