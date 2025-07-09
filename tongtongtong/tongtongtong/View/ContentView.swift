//
//  ContentView 2.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//
import SwiftUI
import AVFoundation

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Wave Background
                WaveBackgroundView(isRedBackground: viewModel.isRedBackground)
                
                // MARK: - Main Content
                VStack {
                    Spacer().frame(height: UIConstants.topMargin)
                    TitleView()
                    Spacer()
                    WatermelonView(isMicActive: viewModel.isMicActive) {
                        viewModel.showMicAlert = true
                    }
                    .alert("마이크를 켜시겠습니까?", isPresented: $viewModel.showMicAlert) {
                        Button("취소", role: .cancel) {}
                        Button("확인") {
                            viewModel.startMicMonitoring()
                        }
                    } message: {
                        Text("3초간 소리를 감지합니다.\n크게 두드려 주세요!")
                    }
                    Spacer()
                    SeedIndicatorView(highlightIndex: viewModel.highlightIndex, indicatorCount: viewModel.indicatorCount)
                    Spacer().frame(height: UIConstants.bottomMargin)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                // MARK: - Navigation: AnalyzingView로 이동
                NavigationLink(
                    destination: AnalyzingView(isRedBackground: viewModel.isRedBackground)
                        .navigationBarHidden(true),
                    isActive: Binding(
                        get: { viewModel.isAnalyzingActive },
                        set: { viewModel.isAnalyzingActive = $0 }
                    )
                ) {
                    EmptyView()
                }
                // MARK: - Navigation: ResultView로 이동
                NavigationLink(
                    destination: ResultView(isRedBackground: viewModel.isRedBackground)
                        .navigationBarHidden(true),
                    isActive: Binding(
                        get: { viewModel.isResultActive },
                        set: { viewModel.isResultActive = $0 }
                    )
                ) {
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(
                    stops: viewModel.isRedBackground ? [
                        .init(color: ColorConstants.redGradientStart, location: 0.00),
                        .init(color: ColorConstants.redGradientEnd, location: 1.00)
                    ] : [
                        .init(color: ColorConstants.blueGradientStart, location: 0.00),
                        .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: viewModel.isRedBackground)
            )
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
}
