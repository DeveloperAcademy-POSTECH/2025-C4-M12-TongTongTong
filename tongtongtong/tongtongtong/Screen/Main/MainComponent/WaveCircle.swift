import SwiftUI
import AVFoundation

struct WaveCircle: View {
  @State private var animate = false
  let color: Color
  let baseSize: CGFloat
  let scale: CGFloat
  let delay: Double
  let opacity: Double
  
  var body: some View {
    Circle()
      .fill(color)
      .frame(width: baseSize, height: baseSize)
      .scaleEffect(animate ? scale : 1)
      .opacity(animate ? 0 : opacity)
      .animation(
        .easeOut(duration: UIConstants.waveAnimationDuration)
        .repeatForever(autoreverses: false)
        .delay(delay),
        value: animate
      )
      .onAppear {
        animate = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
          animate = true
        }
      }
  }
}
