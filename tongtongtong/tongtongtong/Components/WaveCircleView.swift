import SwiftUI

/// 단일 파동 뷰
struct RippleCircle: View {
    var color: Color = .white.opacity(0.2)
    var lineWidth: CGFloat = 1
    var maxScale: CGFloat = 2.0
    var duration: Double = 2.0
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
                .easeOut(duration: duration)
                .repeatForever(autoreverses: false),
                value: animate
            )
    }
}

/// 여러 파동을 쌓아주는 뷰
struct WaveCircleView: View {
    var color: Color = .white.opacity(0.2)
    var count: Int = 2
    var duration: Double = 1.0
    var spacing: Double = 2.0
    
    var body: some View {
        ZStack {
            ForEach(0..<count, id: \.self) { i in
                RippleCircle(
                    color: color,
                    lineWidth: 1,
                    maxScale: 2.0,
                    duration: duration,
                    delay: spacing * Double(i)
                )
            }
        }
    }
}

#Preview() {
    WaveCircleView(
        color: .white.opacity(0.7),
        count: 2,
        duration: 2.5,
        spacing: 1.25
    )
    .frame(width: 300, height: 300)
    .background(Color.blue)
}
