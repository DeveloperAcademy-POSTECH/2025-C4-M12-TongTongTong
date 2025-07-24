import SwiftUI
import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

extension View {
    func mainBackground(isRed: Bool) -> some View {
        self.background(
            LinearGradient(
                stops: isRed ? [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientMedium, location: 0.20),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ] : [
                    .init(color: ColorConstants.blueGradientStart, location: 0.15),
                    .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: isRed)
        )
    }
}
