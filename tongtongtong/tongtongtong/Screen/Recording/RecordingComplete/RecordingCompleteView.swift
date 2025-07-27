import SwiftUI

struct RecordingCompleteView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: UIConstants.mainTopMargin)
                
                Image("GuideImage_4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 220, height: 220)
                
                Spacer().frame(height: 66)
                
                VStack(spacing: 13) {
                    Text("녹음 완료")
                        .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                        .kerning(0.4)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Text("소리 분석을 바로 시작할게요")
                        .font(.system(size: UIConstants.subtitleFontSize, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.72))
                }
                
                Spacer()
                Spacer().frame(height: UIConstants.seedIndicatorBottomMargin)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                LinearGradient(
                    stops: [
                        .init(color: ColorConstants.redGradientStart, location: 0.00),
                        .init(color: ColorConstants.redGradientMedium, location: 0.20),
                        .init(color: ColorConstants.redGradientEnd, location: 1.00)
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    coordinator.goToAnalysis()
                }
            }
        }
    }
}

#Preview {
    RecordingCompleteView().environmentObject(Coordinator())
}
