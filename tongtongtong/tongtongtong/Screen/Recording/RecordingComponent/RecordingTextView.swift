import SwiftUI

struct RecordingTextView: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(spacing: 13) {
            Text(title)
                .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
            Text(subtitle)
                .font(.system(size: UIConstants.subtitleFontSize, weight: .regular))
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.72))
        }
    }
}
