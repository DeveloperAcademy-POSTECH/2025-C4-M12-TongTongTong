import SwiftUI

struct RecordingContentView: View {
    @ObservedObject var viewModel: RecordingViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer().frame(height: UIConstants.mainTopMargin)
                
                    WatermelonView(isMicActive: viewModel.isMicActive)
                    
                    Spacer().frame(height: 66)

                    RecordingTextView(title: "녹음시작", subtitle: "손끝으로 수박을 세 번 두드리세요")
                
                Spacer().frame(height: 102)
                
                SeedIndicatorView(
                    highlightIndex: viewModel.soundCount,
                    indicatorCount: 3
                )
                .frame(maxWidth: .infinity)
                .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
            }
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
        }
    }
}
