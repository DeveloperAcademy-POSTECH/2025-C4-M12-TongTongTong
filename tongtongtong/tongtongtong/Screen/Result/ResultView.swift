import SwiftUI

struct ResultView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        print("[ResultView] init")
    }
    
    var body: some View {
        ZStack {
            // 배경 그라데이션
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.08, green: 0.58, blue: 0.90), // #1595e6
                    Color(red: 0.20, green: 0.81, blue: 1.00)  // #33cffe
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // 메인 텍스트
                Text("Brilliant")
                    .font(.system(size: 60, weight: .bold, design: .default))
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.8), radius: 20)
                    .padding(.top, 20)

                // 서브텍스트
                Text("당 폭발! 극강의 달콤함을 느껴보세요")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 10)

                Spacer(minLength: 20)

                // 수박 이미지 더미
                ZStack {
                Image("WM")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(2.7)
                    .shadow(color: .white.opacity(0.5), radius: 100)
                }
                .padding(.top, 20)

                Spacer()

                // 하단 원형 버튼
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 80, height: 80)
                    Image("Refresh")
                }
                .padding(.bottom, 40)
                .onTapGesture {
                    HapticManager.shared.impact(style: .medium) // 버튼 터치 시 햅틱 피드백
                    coordinator.goToContent()
                }
            }
        }
        .onAppear {
            print("[ResultView] onAppear")
        }
        .onDisappear {
            print("[ResultView] onDisappear")
        }
    }
}

#Preview {
    ResultView()
}
