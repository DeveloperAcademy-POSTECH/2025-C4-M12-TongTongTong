//
//  Constants.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI
import AVFoundation

// MARK: - UI Constants
struct UIConstants {
    // Spacing
    static let titleSpacing: CGFloat = 8
    static let circleSpacing: CGFloat = -8
    static let mainSpacing: CGFloat = 45
    
    // Sizes
    static let watermelonSize: CGFloat = 140
    static let seedSize: CGFloat = 32
    static let circleDotSize: CGFloat = 6
    static let splashCircleSize: CGFloat = 8
    
    // Fonts
    static let titleFontSize: CGFloat = 34
    static let subtitleFontSize: CGFloat = 20
    static let resultFontSize: CGFloat = 22
    
    // Margins
    static let topMargin: CGFloat = 139
    static let bottomMargin: CGFloat = 80
    static let splashTopMargin: CGFloat = 80
    
    // Animation
    static let splashInterval: TimeInterval = 0.3
    static let bounceDelay: TimeInterval = 0.05
    static let bounceDuration: TimeInterval = 0.18
    static let waveAnimationDuration: Double = 1.6
    static let backgroundAnimationDuration: Double = 0.3
    static let highlightAnimationDuration: Double = 0.2
    static let redBackgroundDuration: TimeInterval = 3.0
    static let micMonitoringDuration: TimeInterval = 3.0
    static let splashDisplayDuration: TimeInterval = 2.0
}

// MARK: - Color Constants
struct ColorConstants {
    // Green Theme
    static let greenGradientStart = Color(red: 0.47, green: 0.59, blue: 0.24)
    static let greenGradientEnd = Color(red: 0.24, green: 0.45, blue: 0.02)
    
    // Blue Theme
    static let blueGradientStart = Color(red: 0.08, green: 0.58, blue: 0.9)
    static let blueGradientEnd = Color(red: 0.2, green: 0.81, blue: 1)
    
    // Red Theme
    static let redGradientStart = Color(red: 1, green: 0.32, blue: 0.32)
    static let redGradientEnd = Color(red: 1, green: 0.55, blue: 0.32)
    
    // Wave Colors
    static let waveGreen1 = Color(red: 0.22, green: 0.52, blue: 0.12)
    static let waveGreen2 = Color(red: 0.35, green: 0.66, blue: 0.20)
    static let waveGreen3 = Color(red: 0.45, green: 0.78, blue: 0.28)
    static let waveGreen4 = Color(red: 0.55, green: 0.86, blue: 0.36)
    
    static let waveBlue1 = Color(red: 0.15, green: 0.65, blue: 0.95)
    static let waveBlue2 = Color(red: 0.10, green: 0.50, blue: 0.85)
    static let waveBlue3 = Color(red: 0.20, green: 0.81, blue: 1.0)
    static let waveBlue4 = Color(red: 0.08, green: 0.58, blue: 0.9)
    
    static let waveRed1 = Color(red: 1, green: 0.5, blue: 0.5)
    static let waveRed2 = Color(red: 1, green: 0.4, blue: 0.4)
    static let waveRed3 = Color(red: 1, green: 0.3, blue: 0.3)
    static let waveRed4 = Color(red: 1, green: 0.6, blue: 0.4)
    static let waveRed5 = Color(red: 1, green: 0.32, blue: 0.32)
}

// MARK: - Audio Constants
struct AudioConstants {
    static let threshold: Float = -20 // dB
    static let bufferSize: AVAudioFrameCount = 1024
    static let busIndex: Int = 0
}

// MARK: - Wave Circle Configuration
struct WaveCircleConfig {
    let color: Color
    let baseSize: CGFloat
    let scale: CGFloat
    let delay: Double
    let opacity: Double
    
    static let greenWaves: [WaveCircleConfig] = [
        WaveCircleConfig(color: ColorConstants.waveGreen1, baseSize: 220, scale: 1.4, delay: 0.2, opacity: 0.6),
        WaveCircleConfig(color: ColorConstants.waveGreen2, baseSize: 240, scale: 1.6, delay: 0.4, opacity: 0.5),
        WaveCircleConfig(color: ColorConstants.waveGreen3, baseSize: 260, scale: 1.7, delay: 0.6, opacity: 0.4),
        WaveCircleConfig(color: ColorConstants.waveGreen4, baseSize: 280, scale: 1.64, delay: 0.8, opacity: 0.3)
    ]
    
    static let blueWaves: [WaveCircleConfig] = [
        WaveCircleConfig(color: Color.white, baseSize: 240, scale: 1.6, delay: 0.0, opacity: 0.7),
        WaveCircleConfig(color: ColorConstants.waveBlue1, baseSize: 220, scale: 1.7, delay: 0.2, opacity: 0.6),
        WaveCircleConfig(color: ColorConstants.waveBlue2, baseSize: 200, scale: 1.8, delay: 0.4, opacity: 0.5),
        WaveCircleConfig(color: ColorConstants.waveBlue3, baseSize: 260, scale: 1.5, delay: 0.6, opacity: 0.5),
        WaveCircleConfig(color: ColorConstants.waveBlue4, baseSize: 280, scale: 1.4, delay: 0.8, opacity: 0.4)
    ]
    
    static let redWaves: [WaveCircleConfig] = [
        WaveCircleConfig(color: ColorConstants.waveRed1, baseSize: 240, scale: 1.6, delay: 0.0, opacity: 1.0),
        WaveCircleConfig(color: ColorConstants.waveRed2, baseSize: 220, scale: 1.7, delay: 0.2, opacity: 0.9),
        WaveCircleConfig(color: ColorConstants.waveRed3, baseSize: 200, scale: 1.8, delay: 0.4, opacity: 0.8),
        WaveCircleConfig(color: ColorConstants.waveRed4, baseSize: 260, scale: 1.5, delay: 0.6, opacity: 0.7),
        WaveCircleConfig(color: ColorConstants.waveRed5, baseSize: 280, scale: 1.4, delay: 0.8, opacity: 0.6)
    ]
}
