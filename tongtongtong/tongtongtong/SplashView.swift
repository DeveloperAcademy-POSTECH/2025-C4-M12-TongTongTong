import SwiftUI

struct SplashView: View {
    // MARK: - Properties
    @State private var visibleIndex = 0
    @State private var isBouncing: [Bool] = [false, false, false]
    
    // MARK: - Constants
    private let total = 3
    private let interval: TimeInterval = UIConstants.splashInterval

    var body: some View {
        HStack(spacing: -8) {
            ForEach(0..<total, id: \.self) { idx in
                VStack {
                    if idx < visibleIndex {
                        Circle()
                            .frame(width: UIConstants.splashCircleSize, height: UIConstants.splashCircleSize)
                            .foregroundColor(.black)
                            .transition(.opacity)
                        Text("통")
                            .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.black)
                            .scaleEffect(isBouncing[idx] ? 1.3 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.2), value: isBouncing[idx])
                            .transition(.opacity)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            visibleIndex = 0
            isBouncing = Array(repeating: false, count: total)
            for i in 1...total {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                    withAnimation {
                        visibleIndex = i
                    }
                    // 통 튀는 효과
                    DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i) + UIConstants.bounceDelay) {
                        isBouncing[i-1] = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.bounceDuration) {
                            isBouncing[i-1] = false
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SplashView()
} 



