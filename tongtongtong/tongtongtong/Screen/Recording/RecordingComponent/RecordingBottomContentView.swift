import SwiftUI

struct RecordingBottomContentView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                Button(action: action) {
                    Text(title)
                        .foregroundColor(.white)
                        .padding(.vertical, 16)
                        .frame(minWidth: 140, alignment: .center)
                        .background(Color(red: 0.92, green: 0.23, blue: 0.12))
                        .cornerRadius(80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 80)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0.98, green: 0.85, blue: 0.82), lineWidth: 1)
                        )
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}
