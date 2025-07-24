//
//  WaveCircleView 2.swift
//  tongtongtong
//
//  Created by cheshire on 7/24/25.
//


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