import SwiftUI

struct TitleView: View {
    @EnvironmentObject var coordinator: Coordinator
    let isMicActive: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 13){
                Text("시작하기")
                    .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text("가운데 버튼을 눌러 측정을 시작하세요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .regular))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.72))
            }
        }
    }
}

