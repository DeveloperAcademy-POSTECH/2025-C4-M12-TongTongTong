import SwiftUI

struct ResultAnalysisView: View {
    @ObservedObject var state: ResultState
    
    var body: some View {
        VStack {
            HStack {
                VStack(spacing: 8) {
                    Text("통통통의 제안")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("\(state.ripeness.score)점")
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    StarRatingView(
                        rating: Double(state.ripeness.starRating)
                    )
                }
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 0.5, height: 48)
                    .background(.white.opacity(0.8))
                    .padding(.horizontal, 35)
                
                VStack(spacing: 8) {
                    Text("익음도")
                        .font(.system(size: 12, weight: .medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text(state.result)
                        .font(.system(size: 24, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    
                    Text("ADA 지수")
                        .font(.system(size: 10, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white.opacity(0.8))
                }
            }
        }
    }
}

#Preview {
    ResultAnalysisView(state: {
        let state = ResultState()
        state.result = "잘 익음"
        state.confidence = 0.9
        return state
    }())
    .background(Color.green)
}
