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
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        print("[AnalysisView] init")
    }
    
    var body: some View {
        ZStack {
            ZStack {
                VStack(spacing: UIConstants.mainSpacing) {
                    Spacer().frame(height: UIConstants.splashTopMargin)
                    Text("과즙 분석중...")
                        .font(.system(size: UIConstants.resultFontSize, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)

                    ZStack {
                        VStack {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 280, height: 280)
                                .background(
                                    Image("WholeWatermelon")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 600, height: 600)
                                        .clipped()
                                        .offset(y: 110)
                                        .offset(x: 160)
                                )
                                .overlay(
                                    Circle()
                                        .fill(Color.black.opacity(overlayOpacity))
                                        .frame(width: 490, height: 1000)
                                        .offset(x: overlayOffsetX, y: 110)
                                        .blur(radius: 10)
                                        .onAppear {
                                            withAnimation(.easeOut(duration: 3.0)) {
                                                overlayOffsetX += 200
                                                overlayOpacity = 0
                                            }
                                        }
                                )
                                .shadow(color: .white.opacity(0.5), radius: 60, x: 0, y: 0)
                            Spacer()
//                            // ProgressCircleView 추가
//                            ProgressCircleView(progress: 0.8)
//                                .padding(.bottom, 30)
                        }
                    }
                    Spacer()
                }
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
        .frame(width: 394, height: 852)
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
        .onAppear {
            print("[AnalysisView] onAppear")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                coordinator.goToRecordingComplete()
            }
        }
        .onDisappear {
            print("[AnalysisView] onDisappear")
        }
    }
}

#Preview {
    AnalysisView()
}
