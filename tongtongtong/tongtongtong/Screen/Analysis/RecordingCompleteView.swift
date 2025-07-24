import SwiftUI

struct RecordingCompleteView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Spacer().frame(height: UIConstants.mainTopMargin)
            
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 124))
            
            Spacer().frame(height: 106)
            
            VStack(spacing: UIConstants.titleSpacing) {
                Text("녹음 완료")
                    .font(.system(size: UIConstants.completeTitleFontSize, weight: .bold))
                    .kerning(0.4)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                Text("주파수 분석을 시작할게요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.72))
            }
            Spacer()
            SeedIndicatorView(highlightIndex: 3, indicatorCount: 3)
                .padding(.bottom, UIConstants.bottomMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                coordinator.goToAnalysis()
            }
        }
    }
}

#Preview {
    RecordingCompleteView().environmentObject(Coordinator())
}
