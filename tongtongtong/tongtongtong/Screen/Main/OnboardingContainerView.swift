import SwiftUI

struct OnboardingContainerView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var currentTab = 0
    
    private let onboardingSteps = [
        OnboardingStep(image: "onboarding_1", text: "측정할 수박에 iPhone을\n가까이 붙여주세요"),
        OnboardingStep(image: "onboarding_2", text: "가운데 수박 버튼을 눌러\n녹음을 시작하세요"),
        OnboardingStep(image: "onboarding_3", text: "손끝을 모아\n세 번 두드리세요")
    ]
    
    init() {
        print("[OnboardingContainerView] init")
    }
    
    var body: some View {
        ZStack {
            // 1. 배경색
            Color(red: 0.14, green: 0.26, blue: 0.40)
                .edgesIgnoringSafeArea(.all)
            
            // 2. TabView
            TabView(selection: $currentTab) {
                ForEach(0..<onboardingSteps.count, id: \.self) { index in
                    OnboardingPageView(
                        imageName: onboardingSteps[index].image,
                        text: onboardingSteps[index].text
                    ).tag(index)
                }
            }
            // ‼️‼️ 중요: TabView를 페이지처럼 스와이프 가능하게 만듭니다.
            .tabViewStyle(.page(indexDisplayMode: .never))
            
            // 3. 하단 오버레이 UI (인디케이터 + 버튼)
            VStack(spacing: 30) {
                // ‼️‼️ 중요: 이 Spacer가 하단 UI를 아래로 밀어주고,
                // allowsHitTesting(false)가 스와이프를 가능하게 합니다.
                Spacer()
                    .allowsHitTesting(true)
                
                // 커스텀 인디케이터
                HStack(spacing: 8) {
                    ForEach(0..<onboardingSteps.count, id: \.self) { index in
                        Capsule()
                            .fill(currentTab == index ? Color.white : Color.gray.opacity(0.5))
                            .frame(width: currentTab == index ? 24 : 8, height: 8)
                            .animation(.spring(), value: currentTab)
                    }
                }
                
                // 시작하기 버튼 또는 빈 공간
                if currentTab == onboardingSteps.count - 1 {
                    Button(action: {
                        print("[OnboardingContainerView] '시작하기' button tapped.")
                        coordinator.completeOnboarding()
                    }) {
                        Text("시작하기")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .transition(.opacity.animation(.easeInOut))
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 54) // 버튼 높이와 동일하게 설정
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .onAppear {
            print("[OnboardingContainerView] onAppear")
        }
        .onDisappear {
            print("[OnboardingContainerView] onDisappear")
        }
    }
}

struct OnboardingStep {
    let image: String
    let text: String
}
