import SwiftUI

struct ResultView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    // 상태 변수 추가
    @State private var sweetnessIndex: Int = 0
    @State private var watermelonTapCount: Int = 0
    @State private var isSweetnessVisible: Bool = false
    
    private let mainTexts = ["Brilliant", "Great", "Good"]
    private let subTexts = [
        "과즙폭발! 극강의 달콤함을 느껴보세요",
        "딱 좋은 당도! 누구나 좋아할 맛",
        "입안을 가득 채우는 과즙의 상쾌함"
    ]
    
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
                Text(mainTexts[sweetnessIndex])
                    .font(.system(size: 60, weight: .bold, design: .default))
                    .italic()
                    .foregroundColor(.white)
                    .shadow(color: .white.opacity(0.8), radius: 20)
                    .padding(.top, 20)
                
                // 서브텍스트
                Text(subTexts[sweetnessIndex])
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.top, 10)
                
                Spacer(minLength: 20)
                
                // 수박 이미지
                ZStack {
                    Image("WM")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(2.7)
                        .shadow(color: .white.opacity(0.5), radius: 100)
                        .onTapGesture {
#if DEBUG
                            watermelonTapCount += 1
                            print("수박 탭 횟수: \(watermelonTapCount)")

                            if watermelonTapCount >= 3 {
                                isSweetnessVisible.toggle()
                                watermelonTapCount = 0
                                print("당도 버튼  \(isSweetnessVisible ? "표시" : "숨김") 전환됨")
                            }
#endif
                        }
                }
                .padding(.top, 20)
                
                Spacer()
                
                // 하단 버튼 영역
                HStack(spacing: 16) {
                    // 원형 새로고침 버튼
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 80, height: 80)
                        Image("Refresh")
                    }
                    .onTapGesture {
                        HapticManager.shared.impact(style: .medium)
                        coordinator.goToContent()
                    }
                    
                    // 당도 버튼
                    
#if DEBUG
                    if isSweetnessVisible {
                        Button(action: {
                            HapticManager.shared.impact(style: .light)
                            sweetnessIndex = (sweetnessIndex + 1) % mainTexts.count
                        }) {
                            Text("당도")
                                .fontWeight(.bold)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 12)
                                .background(Color.white.opacity(0.7))
                                .foregroundColor(.blue)
                                .cornerRadius(20)
                        }
                        .transition(.opacity)
                    }
#endif
                }
                .padding(.bottom, 40)
                .frame(maxWidth: .infinity)
                .frame(alignment: .center)
            }
        }
        .onAppear {
            print("[ResultView] onAppear")
        }
        .onDisappear {
            print("[ResultView] onDisappear")
        }
        .onChange(of: sweetnessIndex) { newValue in
            print("[ResultView] sweetnessIndex changed to \(newValue)")
        }
    }
}

#Preview {
    ResultView().environmentObject(Coordinator())
}
