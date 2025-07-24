//
//  ContentView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI
import AVFoundation

struct AnalysisView: View {
    @State private var overlayOffsetX: CGFloat = 190
    @State private var overlayOpacity: Double = 0.8
    @State private var loadingRotation: Double = 0
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        print("[AnalysisView] init")
    }
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: UIConstants.mainSpacing) {
                    Spacer().frame(height: UIConstants.analysisTopMargin)
                    HStack {
                        Text("주파수 분석중")
                        Image(systemName: "waveform")
                    }
                    .font(.system(size: UIConstants.resultFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    
                    ZStack {
                        Image("WholeWatermelon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 540, height: 540)
                            .padding(.bottom, 59)
                        
                        Image("LoadingShadow")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 472, height: 472)
                            .rotationEffect(.degrees(loadingRotation))
                            .offset(x: 2.5)
                            .offset(y: -1.5)
                    }
                    .offset(x: 200)
                    .offset(y: -48)
                    .shadow(color: .white.opacity(0.5), radius: 60)
                    .onAppear {
                        withAnimation(.easeOut(duration: 3.0)) {
                            overlayOffsetX += 200
                            overlayOpacity = 0
                            loadingRotation = 180
                        }
                    }
                    Spacer()
                }
                Spacer()
            }
            
            ZStack {
                StarView(imageName: "Star", size: CGSize(width: 20, height: 20), offset: CGSize(width: -80, height: -200))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -100, height: -150))
                StarView(imageName: "Star", size: CGSize(width: 20, height: 20), offset: CGSize(width: -100, height: -100))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -120, height: 30))
                StarView(imageName: "Star", size: CGSize(width: 30, height: 30), offset: CGSize(width: -100, height: 180))
                StarView(imageName: "Star", size: CGSize(width: 60, height: 60), offset: CGSize(width: -80, height: 200))
                StarView(imageName: "Star", size: CGSize(width: 30, height: 30), offset: CGSize(width: -40, height: 280))
                StarView(imageName: "Star", size: CGSize(width: 40, height: 40), offset: CGSize(width: 30, height: 300))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.18, green: 0.19, blue: 0.29), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.34, green: 0.33, blue: 0.47), location: 0.70),
                    Gradient.Stop(color: Color(red: 0.43, green: 0.36, blue: 0.47), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
        )
        .ignoresSafeArea()
        .onDisappear {
            print("[AnalysisView] onDisappear")
        }
        .onAppear {
            print("[AnalysisView] onAppear - 서버 분석 시작")
            guard let url = coordinator.resultState.audioFileURL else {
                print("[AnalysisView] 오디오 파일 없음")
                return
            }
            // 3초간 로딩 화면 노출 후 서버 호출
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                WatermelonAPIService.shared.predictWatermelon(audioFileURL: url) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success(let response):
                            print("[API] 예측 성공: \(response)")
                            coordinator.resultState.update(with: response)
                            coordinator.goToResult()
                        case .failure(let error):
                            print("[API] 예측 실패: \(error)")
                            // 에러 처리 필요시 추가
                        }
                    }
                }
                print("[AnalysisView] onAppear")
                DispatchQueue.main.asyncAfter(deadline: .now() + 4.0) {
                    coordinator.goToResult()
                }
            }
        }
    }
}
#Preview {
    AnalysisView()
        .environmentObject(Coordinator())
}
