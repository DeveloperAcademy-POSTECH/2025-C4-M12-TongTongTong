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
            VStack(spacing: 45) {
                Spacer().frame(height: 80)
                Text("과즙 분석중...")
                    .font(.system(size: 22, weight: .bold))
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
                        .shadow(color: .white.opacity(0.5), radius: 60, x: 0, y: 0)
                }
                Spacer()
            }
        }
        .frame(width: 394, height: 852)
        .background(
            LinearGradient(
                stops: [
                    .init(color: Color(red: 0.08, green: 0.58, blue: 0.9), location: 0.00),
                    .init(color: Color(red: 0.2, green: 0.81, blue: 1), location: 1.00)
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



