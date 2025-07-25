import SwiftUI

struct RecordingContentView: View {
    @ObservedObject var viewModel: RecordingViewModel
    
    var body: some View {
        VStack {
            Spacer().frame(height: UIConstants.mainTopMargin)

            WatermelonView(isMicActive: viewModel.isMicActive)

            Spacer().frame(height: 32)

            RecordingTextView(title: "녹음 시작", subtitle: "손끝으로 수박을 세 번 두드리세요")

            SeedIndicatorView(
                highlightIndex: viewModel.soundCount,
                indicatorCount: 3
            )

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                stops: [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientMedium, location: 0.20),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .ignoresSafeArea()
    }
}
