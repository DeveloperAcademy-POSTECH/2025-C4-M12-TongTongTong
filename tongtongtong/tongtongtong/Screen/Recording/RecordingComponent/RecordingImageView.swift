import SwiftUI

struct RecordingImageView: View {
    let imageName: String
    @State private var pulse = false
    
    var body: some View {
        ZStack {
            RippleCirclesView(
                color: .white.opacity(0.7),
                count: 1,
                spacing: 1.25
            )
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 220)
                .frame(width: UIConstants.watermelonSize, height: UIConstants.watermelonSize)
                .padding(.bottom, 2)
                .scaleEffect(pulse ? 1.04 : 0.96)
                .animation(
                    Animation.easeInOut(duration: 1.2)
                        .repeatForever(autoreverses: true),
                    value: pulse
                )
            
        }
        .onAppear {
            pulse = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
                pulse = true
            }
        }
    }
}
