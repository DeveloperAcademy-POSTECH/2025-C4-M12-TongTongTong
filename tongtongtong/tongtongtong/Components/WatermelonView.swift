//
//  WatermelonView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct WatermelonView: View {
    let isMicActive: Bool
    let isRedBackground: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            let waveConfigs = isRedBackground ? WaveCircleConfig.redWaves : WaveCircleConfig.greenWaves
            
            ForEach(Array(waveConfigs.enumerated()), id: \.offset) { _, config in
                WaveCircle(
                    color: config.color.opacity(config.opacity),
                    baseSize: config.baseSize,
                    scale: config.scale,
                    delay: config.delay,
                    opacity: config.opacity
                )
            }
            
            Circle()
                .frame(width: 220, height: 220)
                .foregroundStyle(Color.white)
                .overlay(
                    Image("WholeWatermelon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: UIConstants.watermelonSize, height: UIConstants.watermelonSize)
                        .onTapGesture {
                            if !isMicActive {
                                onTap()
                            }
                        }
                )
        }
    }
}

#Preview {
    WatermelonView(isMicActive: false, isRedBackground: false) {
        print("Watermelon tapped")
    }
    .background(Color.blue)
}
