//
//  ContentView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI
import AVFoundation

struct ResultView: View {
    var body: some View {
        ZStack {
            VStack(spacing: UIConstants.mainSpacing) {
                Spacer().frame(height: UIConstants.splashTopMargin)
                Text("과즙 분석중...")
                    .font(.system(size: UIConstants.resultFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                ZStack {
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
                                .fill(Color.black.opacity(0.3))
                                .frame(width: 490, height: 490)
                                .offset(x: 200, y: 120) // to align the circle on top of the watermelon image
                        )
                        .shadow(color: .white.opacity(0.8), radius: 60, x: 0, y: 0)
                }
                Spacer()
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
    }
}

#Preview {
    ResultView()
}
