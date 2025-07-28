import SwiftUI

struct StarRatingView: View {
    var rating: Double
    var maxRating: Int = 5
    var spacing: CGFloat = 4
    
    var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<maxRating, id: \.self) { index in
                ZStack {
                    Image(systemName: "star")
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 10, height: 10)
                        .foregroundColor(.white.opacity(0.8))
                    
                    if rating >= Double(index) + 1.0 {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    else if rating >= Double(index) + 0.5 {
                        Image(systemName: "star.leadinghalf.filled")
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 10, height: 10)
                            .foregroundColor(.white.opacity(0.8))
                    }
                }
            }
        }
    }
}
