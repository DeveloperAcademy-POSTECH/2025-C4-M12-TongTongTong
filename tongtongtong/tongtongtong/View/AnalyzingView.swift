import SwiftUI

struct AnalyzingView: View {
    var isRedBackground: Bool = false
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = AnalyzingViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: UIConstants.mainSpacing) {
                Spacer().frame(height: UIConstants.splashTopMargin)
                
                Text("Analyzing...")
                    .font(.system(size: UIConstants.resultFontSize, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 280, height: 280)
                        .background(
                            Image("WholeWatermelon")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 600, height: 600)
                                .clipped()
                                .offset(y: 110)
                                .offset(x: 160)
                        )
                        .shadow(color: .white.opacity(0.5), radius: 60, x: 0, y: 0)
                }

                Spacer()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                navigationPath.append(Route.result(isRed: isRedBackground)) // ✅ Route 사용
            }
        }
        .frame(width: 394, height: 852)
        .background(
            LinearGradient(
                stops: isRedBackground ? [
                    .init(color: ColorConstants.redGradientStart, location: 0.00),
                    .init(color: ColorConstants.redGradientEnd, location: 1.00)
                ] : [
                    .init(color: ColorConstants.blueGradientStart, location: 0.00),
                    .init(color: ColorConstants.blueGradientEnd, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 1)
            )
            .animation(.easeInOut(duration: UIConstants.backgroundAnimationDuration), value: isRedBackground)
        )
        .ignoresSafeArea()
    }
}
