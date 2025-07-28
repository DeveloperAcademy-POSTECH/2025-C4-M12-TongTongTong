import SwiftUI

struct RecordingCompleteView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    
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
                    Text("소리를 확인하고 분석을 시작하세요.")
                        .font(.system(size: UIConstants.subtitleFontSize, weight: .regular))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.72))
                }
                
                Spacer()
                
                VStack(spacing: 12) {
                    Button(action: {
                        if let url = coordinator.resultState.audioFileURL {
                            if audioPlayerManager.isPlaying {
                                audioPlayerManager.stopAudio()
                            } else {
                                audioPlayerManager.playAudio(url: url)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: audioPlayerManager.isPlaying ? "stop.fill" : "play.fill")
                            Text(audioPlayerManager.isPlaying ? "정지" : "녹음된 소리 듣기")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.white.opacity(0.2))
                        .cornerRadius(12)
                    }

                    Button(action: {
                        audioPlayerManager.stopAudio()
                        coordinator.goToAnalysis()
                    }) {
                        Text("분석 시작하기")
                            .font(.headline.bold())
                            .foregroundColor(.red)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
                    .frame(height: UIConstants.seedIndicatorBottomMargin / 2)
                    .padding(.bottom, geometry.safeAreaInsets.bottom)
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
            .onDisappear {
                audioPlayerManager.stopAudio()
            }
        }
    }
}

#Preview {
    RecordingCompleteView().environmentObject(Coordinator())
}
