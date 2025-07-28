import SwiftUI

/// 단일 파동 뷰
struct RippleCircle: View {
    var color: Color = .white.opacity(0.2)
    var lineWidth: CGFloat = 1
    var maxScale: CGFloat = 2.0
    var delay: Double = 0
    
    @State private var animate = false
    
    var body: some View {
        Circle()
            .stroke(color, lineWidth: lineWidth)
            .scaleEffect(animate ? maxScale : 0.1)
            .opacity(animate ? 0 : 1)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    animate = true
                }
            }
            .animation(
                .easeOut(duration: UIConstants.waveAnimationDuration)
                .repeatForever(autoreverses: false),
                value: animate
            )
    }
}
