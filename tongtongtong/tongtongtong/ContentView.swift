//
//  ContentView 2.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var highlightIndex = 2
    let indicatorCount = 3
    @StateObject private var audioMonitor = AudioLevelMonitor()
    @State private var isRedBackground = false
    @State private var showMicAlert = false
    @State private var isMicActive = false
    @State private var isResultActive = false
    
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
                // 다양한 색상의 파동 원 5개 (중앙)
                WaveCircle(color: isRedBackground ? Color(red: 1, green: 0.5, blue: 0.5).opacity(0.35) : Color.white.opacity(0.15), baseSize: 240, scale: 1.6, delay: 0.0, opacity: isRedBackground ? 1.0 : 0.7)
                WaveCircle(color: isRedBackground ? Color(red: 1, green: 0.4, blue: 0.4).opacity(0.38) : Color(red: 0.15, green: 0.65, blue: 0.95).opacity(0.18), baseSize: 220, scale: 1.7, delay: 0.2, opacity: isRedBackground ? 0.9 : 0.6)
                WaveCircle(color: isRedBackground ? Color(red: 1, green: 0.3, blue: 0.3).opacity(0.36) : Color(red: 0.10, green: 0.50, blue: 0.85).opacity(0.16), baseSize: 200, scale: 1.8, delay: 0.4, opacity: isRedBackground ? 0.8 : 0.5)
                WaveCircle(color: isRedBackground ? Color(red: 1, green: 0.6, blue: 0.4).opacity(0.33) : Color(red: 0.20, green: 0.81, blue: 1.0).opacity(0.13), baseSize: 260, scale: 1.5, delay: 0.6, opacity: isRedBackground ? 0.7 : 0.5)
                WaveCircle(color: isRedBackground ? Color(red: 1, green: 0.32, blue: 0.32).opacity(0.32) : Color(red: 0.08, green: 0.58, blue: 0.9).opacity(0.12), baseSize: 280, scale: 1.4, delay: 0.8, opacity: isRedBackground ? 0.6 : 0.4)
                
                VStack {
                    Spacer().frame(height: 139)
                    // 상단 타이틀
                    VStack(spacing: 8) {
                        HStack(spacing: -8) {
                            ForEach(0..<3) { _ in
                                VStack(spacing: 0) {
                                    Circle()
                                        .frame(width: 6, height: 6)
                                        .foregroundColor(.white)
                                    Text("통")
                                        .font(.system(size: 34, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        Text("수박을 두드려 주세요")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                    }
                    Spacer()
                    // 수박 이미지와 파동을 중앙에 고정
                    ZStack {
                        // 파동 원들은 이미 ZStack의 중앙에 있음
                        Image("WholeWatermelon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 140, height: 140)
                            .offset(y: -60)
                            .onTapGesture {
                                if !isMicActive {
                                    showMicAlert = true
                                }
                            }
                    }
                    .alert("마이크를 켜시겠습니까?", isPresented: $showMicAlert) {
                        Button("취소", role: .cancel) {}
                        Button("확인") {
                            isMicActive = true
                            audioMonitor.onLoudSound = {
                                highlightIndex = (highlightIndex + 1) % indicatorCount
                                isRedBackground = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    isRedBackground = false
                                }
                            }
                            audioMonitor.startMonitoring()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                audioMonitor.stopMonitoring()
                                isMicActive = false
                                isResultActive = true
                            }
                        }
                    } message: {
                        Text("3초간 소리를 감지합니다.\n크게 두드려 주세요!")
                    }
                    Spacer()
                    // 하단 인디케이터 (이미지 + 하이라이트 애니메이션)
                    HStack(spacing: 0) {
                        ForEach(0..<indicatorCount) { idx in
                            ZStack {
                                if idx == highlightIndex {
                                    Image("WhiteSeeds")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                } else {
                                    Image("BlackSeeds")
                                        .resizable()
                                        .frame(width: 32, height: 32)
                                }
                                if idx == highlightIndex {
                                    Circle()
                                        .stroke(Color.white.opacity(0.7), lineWidth: 12)
                                        .frame(width: 32, height: 32)
                                        .blur(radius: 2)
                                        .transition(.opacity)
                                        .animation(.easeInOut(duration: 0.2), value: highlightIndex)
                                }
                            }
                        }
                    }
                    Spacer().frame(height: 80)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                NavigationLink(destination: ResultView().navigationBarHidden(true), isActive: $isResultActive) {
                    EmptyView()
                }
            }
            .frame(width: 393, height: 852)
            .background(
                LinearGradient(
                    stops: isRedBackground ? [
                        .init(color: Color(red: 1, green: 0.32, blue: 0.32), location: 0.00),
                        .init(color: Color(red: 1, green: 0.55, blue: 0.32), location: 1.00)
                    ] : [
                        .init(color: Color(red: 0.08, green: 0.58, blue: 0.9), location: 0.00),
                        .init(color: Color(red: 0.2, green: 0.81, blue: 1), location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .animation(.easeInOut(duration: 0.3), value: isRedBackground)
            )
            .ignoresSafeArea()
        }
        .navigationBarHidden(true)
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
