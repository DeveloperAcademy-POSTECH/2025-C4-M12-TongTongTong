import SwiftUI

struct GuideStep {
    let imageName: String
    let subtitle: String
}

struct RecordingGuideView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    @State private var currentIndex = 0
    
    private let steps: [GuideStep] = [
        .init(
            imageName: "GuideImage_1",
            subtitle: "수박에 마이크를 밀착시켜주세요"
        ),
        .init(
            imageName: "GuideImage_2",
            subtitle: "수박의 가운데 부분을 확인해주세요"
        ),
        .init(
            imageName: "GuideImage_3",
            subtitle: "손끝을 모아 가볍게 두드려주세요"
        ),
    ]
    
    var body: some View {
        GeometryReader { geometry in
            let step = steps[currentIndex]
            
            VStack {
                Spacer().frame(height: UIConstants.mainTopMargin)
                
                RecordingImageView(imageName: steps[currentIndex].imageName)
                    .frame(width: 220, height: 220)
                
                Spacer().frame(height: 66)
                RecordingTextView(
                    title: "녹음하기",
                    subtitle: step.subtitle
                )
                
                Spacer().frame(height: 102)
                
                VStack {
                    if currentIndex < steps.count - 1 {
                        RecordingBottomContentView(title: "다음") {
                            HapticManager.shared.impact(style: .medium)
                            currentIndex += 1
                        }
                    } else {
                        RecordingBottomContentView(title: "다음") {
                            HapticManager.shared.impact(style: .medium)
                            coordinator.goToRecording()
                        }
                    }
                }
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
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
            )
        }
    }
}

struct RecordingGuideView_Previews: PreviewProvider {
    static var previews: some View {
        RecordingGuideView()
            .environmentObject(Coordinator())
    }
}
