import SwiftUI
import UIKit

struct SplashView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var visibleIndex = 0
    @State private var isBouncing: [Bool] = [false, false, false]

    init() {
        print("[SplashView] init")
    }

    // MARK: - Constants
    private let total = 3
    private let interval: TimeInterval = UIConstants.splashInterval

    var body: some View {
        VStack(spacing: 31) {
            HStack(spacing: -8) {
                ForEach(Array(0..<total), id: \.self) { idx in
                    VStack {
                        if idx < visibleIndex {
                            Circle()
                                .frame(width: UIConstants.splashCircleSize, height: UIConstants.splashCircleSize)
                                .foregroundColor(.black)
                                .transition(.opacity)
                            Text("통")
                                .font(.system(size: UIConstants.splashTitleFontSize, weight: .bold))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .scaleEffect(isBouncing[idx] ? 1.3 : 1.0)
                                .animation(.spring(response: 0.3, dampingFraction: 0.4, blendDuration: 0.2), value: isBouncing[idx])
                                .transition(.opacity)
                        }
                    }
                }
            }
            
            Text("잘 익은 수박을 고르는\n가장 똑똑한 방법")
                .multilineTextAlignment(.center)
                .font(.system(size: UIConstants.subtitleFontSize, weight: .medium))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .onAppear {
            print("[SplashView] onAppear")
            visibleIndex = 1
            isBouncing = Array(repeating: false, count: total)
            for i in 1...total {
                DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i)) {
                    withAnimation {
                        visibleIndex = i
                        HapticManager.shared.impact(style: .medium)
                    }
                    // 통 튀는 효과
                    DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(i) + UIConstants.bounceDelay) {
                        HapticManager.shared.impact(style: .light) // haptic on bounce start
                        isBouncing[i-1] = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.bounceDuration) {
                            isBouncing[i-1] = false
                            HapticManager.shared.impact(style: .soft) // haptic on bounce end
                        }
                    }
                }
            }
            // splashDisplayDuration 후 coordinator 상태 변경
            DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.splashDisplayDuration) {
                print("[SplashView] 2초 지연 시간 종료. 화면 전환을 요청합니다.")
                HapticManager.shared.impact(style: .medium)
                coordinator.goToMain()
            }
        }
        .onDisappear {
            print("[SplashView] onDisappear")
        }
    }
}

#Preview {
    SplashView()
}
