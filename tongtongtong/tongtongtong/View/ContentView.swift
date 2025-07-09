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

    // 프리뷰용 이니셜라이저는 필요 없다면 삭제해도 됩니다.

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
                NavigationLink(destination: ResultView().navigationBarHidden(true), isActive: $viewModel.isResultActive) {
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
