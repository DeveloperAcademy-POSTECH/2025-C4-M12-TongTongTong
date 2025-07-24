import SwiftUI

struct WatermelonView: View {
    let isMicActive: Bool
    let isRedBackground: Bool
    let onTap: () -> Void
    
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            if isMicActive {
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
            
            ZStack {
                WaveCircleView(
                    color: .white.opacity(0.7),
                    count: 2,
                    duration: 2.5,
                    spacing: 1.25
                )
                
                Circle()
                    .frame(width: 220, height: 220)
                    .foregroundStyle(Color.white)
                    .scaleEffect(!isMicActive ? (pulse ? 1.04 : 0.96) : 1)
                    .animation(!isMicActive ? Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true) : .default, value: pulse)
                    .overlay(
                        Image("WholeWatermelon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIConstants.watermelonSize, height: UIConstants.watermelonSize)
                            .padding(.bottom, 2)
                            .scaleEffect(!isMicActive ? (pulse ? 1.04 : 0.96) : 1)
                            .animation(!isMicActive ? Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true) : .default, value: pulse)
                    )
                    .onTapGesture {
                        if !isMicActive {
                            onTap()
                        }
                    }
            }
        }
        .onAppear {
            if !isMicActive {
                pulse = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    pulse = true
                }
            }
        }
        .onChange(of: isMicActive) { oldValue, newValue in
            if !newValue {
                pulse = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                    pulse = true
                }
            }
        }
    }
}

#Preview {
    WatermelonView(isMicActive: false, isRedBackground: false) {
        print("Watermelon tapped")
    }
    .background(Color.blue)
}
