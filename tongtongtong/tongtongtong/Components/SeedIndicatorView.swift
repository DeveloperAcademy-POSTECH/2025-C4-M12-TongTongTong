//
//  SeedIndicatorView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct SeedIndicatorView: View {
    let highlightIndex: Int
    let indicatorCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<indicatorCount, id: \.self) { idx in
                ZStack {
                    if idx == highlightIndex {
                        Image("WhiteSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                    } else {
                        Image("BlackSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                    }
                    if idx == highlightIndex {
                        Circle()
                            .stroke(Color.white.opacity(0.7), lineWidth: 12)
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                            .blur(radius: 2)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: UIConstants.highlightAnimationDuration), value: highlightIndex)
                    }
                }
            }
        }
    }
}

#Preview {
    SeedIndicatorView(highlightIndex: 1, indicatorCount: 3)
        .background(Color.blue)
} 