import SwiftUI

struct RecordingCompleteView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack {
            Spacer().frame(height: UIConstants.topMargin)
            // 추후 TitleView 컴포넌트 리팩토링
            VStack(spacing: UIConstants.titleSpacing) {
                Text("녹음 완료")
                    .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                Text("주파수 분석을 시작할게요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
            }
            .foregroundColor(.white)
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.white)
                .font(.system(size: 122))
            
            Spacer()
            SeedIndicatorView(highlightIndex: 3, indicatorCount: 3)
                .padding(.bottom, UIConstants.bottomMargin)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 1, green: 1, blue: 0.97), location: 0.00),
                    Gradient.Stop(color: Color(red: 1, green: 0.33, blue: 0.23).opacity(0.9), location: 0.20),
                    Gradient.Stop(color: Color(red: 0.91, green: 0.22, blue: 0.11).opacity(0.9), location: 1.00),
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
