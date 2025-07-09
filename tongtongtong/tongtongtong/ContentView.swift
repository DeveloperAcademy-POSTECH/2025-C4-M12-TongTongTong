//
//  ContentView 2.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    // MARK: - Properties
    @State private var highlightIndex = 2
    @StateObject private var audioMonitor = AudioLevelMonitor()
    @State private var isRedBackground = false
    @State private var showMicAlert = false
    @State private var isMicActive = false
    @State private var isResultActive = false
    
    // MARK: - Constants
    private let indicatorCount = 3
    
    // 프리뷰용 이니셜라이저
    init(
        highlightIndex: Int = 2,
        isRedBackground: Bool = false,
        showMicAlert: Bool = false,
        isMicActive: Bool = false,
        isResultActive: Bool = false
    ) {
        _highlightIndex = State(initialValue: highlightIndex)
        _isRedBackground = State(initialValue: isRedBackground)
        _showMicAlert = State(initialValue: showMicAlert)
        _isMicActive = State(initialValue: isMicActive)
        _isResultActive = State(initialValue: isResultActive)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // MARK: - Wave Background
                WaveBackgroundView(isRedBackground: isRedBackground)
                
                // MARK: - Main Content
                VStack {
                    Spacer().frame(height: UIConstants.topMargin)
                    
                    // MARK: - Title Section
                    TitleView()
                    
                    Spacer()
                    
                    // MARK: - Watermelon Section
                    WatermelonView(isMicActive: isMicActive) {
                        showMicAlert = true
                    }
                    .alert("마이크를 켜시겠습니까?", isPresented: $showMicAlert) {
                        Button("취소", role: .cancel) {}
                        Button("확인") {
                            startMicMonitoring()
                        }
                    } message: {
                        Text("3초간 소리를 감지합니다.\n크게 두드려 주세요!")
                    }
                    
                    Spacer()
                    
                    // MARK: - Seed Indicator Section
                    SeedIndicatorView(highlightIndex: highlightIndex, indicatorCount: indicatorCount)
                    
                    Spacer().frame(height: UIConstants.bottomMargin)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // MARK: - Navigation
                NavigationLink(destination: ResultView().navigationBarHidden(true), isActive: $isResultActive) {
                    EmptyView()
                }
            }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                NavigationLink(destination: ResultView().navigationBarHidden(true), isActive: $isResultActive) {
                    EmptyView()
                }
            }
//            .frame(width: 393, height: 852)
            .background(
                LinearGradient(
                    stops: isRedBackground ? [
                        .init(color: ColorConstants.redGradientStart, location: 0.00),
                        .init(color: ColorConstants.redGradientEnd, location: 1.00)
                    ] : [
                        .init(color: ColorConstants.blueGradientStart, location: 0.00),
                        .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: isRedBackground)
            )
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Private Methods
    private func startMicMonitoring() {
        isMicActive = true
        audioMonitor.onLoudSound = {
            highlightIndex = (highlightIndex + 1) % indicatorCount
            isRedBackground = true
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.redBackgroundDuration) {
                isRedBackground = false
            }
        }
        audioMonitor.startMonitoring()
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.micMonitoringDuration) {
            audioMonitor.stopMonitoring()
            isMicActive = false
            isResultActive = true
        }
    }
}

extension ContentView {
    static var preview: ContentView {
        let view = ContentView()
        // 필요하다면, @StateObject는 직접 접근 불가하므로, 내부적으로 더미 AudioLevelMonitor를 사용하도록 구현 필요
        return view
    }
}

#Preview {
    ContentView(
        highlightIndex: 1,
        isRedBackground: true,
        showMicAlert: false,
        isMicActive: false,
        isResultActive: false
    )
}
