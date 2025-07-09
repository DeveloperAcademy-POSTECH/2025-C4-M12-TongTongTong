//
//  WaveBackgroundView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct WaveBackgroundView: View {
    let isRedBackground: Bool
    
    var body: some View {
        ZStack {
            let waveConfigs = isRedBackground ? WaveCircleConfig.redWaves : WaveCircleConfig.blueWaves
            
            ForEach(Array(waveConfigs.enumerated()), id: \.offset) { _, config in
                WaveCircle(
                    color: config.color.opacity(config.opacity),
                    baseSize: config.baseSize,
                    scale: config.scale,
                    delay: config.delay,
                    opacity: config.opacity
                )
            }
        }
    }
}

#Preview {
    WaveBackgroundView(isRedBackground: false)
        .background(Color.blue)
} 