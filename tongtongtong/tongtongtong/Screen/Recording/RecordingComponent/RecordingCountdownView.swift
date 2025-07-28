import SwiftUI

struct RecordingCountdownView: View {
  @Binding var isShowing: Bool
  var onFinished: () -> Void
  
  @State private var count: Int = 3
  @State private var scale: CGFloat = 0.1
  
  @State private var previousCount: Int? = nil
  @State private var previousOpacity: Double = 0
  @State private var previousScale: CGFloat = 1.0
  
  var body: some View {
    if isShowing {
      GeometryReader { geometry in
        VStack {
          Spacer().frame(height: UIConstants.mainTopMargin)
          ZStack {
            Circle()
              .fill(Color.white)
              .frame(width: 220, height: 220)
              .overlay (
                ZStack {
                  if let prev = previousCount {
                    Text("\(prev)")
                      .font(.system(size: 240, weight: .bold))
                      .kerning(0.4)
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 1, green: 0.55, blue: 0.47))
                      .scaleEffect(previousScale)
                      .opacity(previousOpacity)
                  }
                  
                  Text("\(count)")
                    .font(.system(size: 128, weight: .bold))
                    .kerning(0.4)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 1, green: 0.55, blue: 0.47))
                    .scaleEffect(scale)
                }
                  .frame(width: 220, height: 220)
                  .background(Color.white)
                  .clipShape(Circle())
              )
              .onAppear(perform: startCountdown)
          }
          .transition(.opacity)
          
          Spacer().frame(height: 66)
          
          RecordingTextView(title: "녹음 시작", subtitle: "3초 후 녹음이 시작됩니다")
          
          Spacer().frame(height: 102)
          
          SeedIndicatorView(highlightIndex: 0, indicatorCount: 3)
            .frame(maxWidth: .infinity)
            .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
        }
        .background(
          LinearGradient(
            stops: [
              .init(color: ColorConstants.redGradientStart, location: 0.00),
              .init(color: ColorConstants.redGradientMedium, location: 0.20),
              .init(color: ColorConstants.redGradientEnd, location: 1.00)
            ],
            startPoint: .top,
            endPoint: .bottom
          )
        )
      }
    }
    
  }
  
  private func startCountdown() {
    count = 3
    scale = 0.1
    previousCount = nil
    previousOpacity = 0
    previousScale = 1.0
    
    withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
      scale = 1.2
    }
    let nextCounts = [2, 1]
    for (index, newCount) in nextCounts.enumerated() {
      let delay = Double(index + 1)
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        previousCount = count
        previousOpacity = 0.3
        previousScale = 1.0
        
        withAnimation(.easeOut(duration: 0.8)) {
          previousOpacity = 0
          previousScale = 1.3
        }
        count = newCount
        scale = 0.1
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
          scale = 1.2
        }
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      withAnimation {
        self.isShowing = false
      }
      self.onFinished()
    }
  }
}
