import SwiftUI

struct ProgressCircleView: View {
    var progress: Double // 0.0 ~ 1.0
    var lineWidth: CGFloat = 5
    var size: CGFloat = 60
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0), lineWidth: lineWidth)
                .frame(width: size, height: size)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(Color.black.opacity(0.5), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .frame(width: size, height: size)
                .animation(.easeOut, value: progress)
            Text("\(Int(progress * 100))%")
                .font(.system(size: size * 0.28, weight: .bold, design: .rounded))
                .foregroundColor(.black)
                .opacity(0.5)
        }
    }
}

struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            ProgressCircleView(progress: 0.8)
        }
        .frame(width: 200, height: 200)
        .background(Color.clear)
        .previewLayout(.sizeThatFits)
    }
}
