import SwiftUI

struct OnboardingPageView: View {
    let imageName: String
    let text: String

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            // --- 수정된 부분 ---
            Image(imageName)
                .resizable()
                .scaledToFit()
                // 1. 이미지를 둥근 사각형 모양으로 잘라냅니다.
                .clipShape(RoundedRectangle(cornerRadius: 30))
                .padding(.horizontal, 10) // 전체적인 좌우 여백
                .padding(.top, 30)        // 전체적인 상단 여백
            // --- 여기까지 수정 ---

            // 설명 텍스트 (변경 없음)
            Text(text)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .padding(.horizontal)

            Spacer()
            Spacer()
        }
        .padding()
    }
}
