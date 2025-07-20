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
        HStack(spacing: 30) {
            ForEach(0..<indicatorCount, id: \.self) { idx in
                ZStack {
                    if highlightIndex == 0 {
                        Image("BlackSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                    } else if highlightIndex >= indicatorCount {
                        Image("WhiteSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                        Circle()
                            .stroke(Color.white.opacity(0.7), lineWidth: 12)
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                            .blur(radius: 2)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: UIConstants.highlightAnimationDuration), value: highlightIndex)
                    } else if idx < highlightIndex {
                        Image("WhiteSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                        Circle()
                            .stroke(Color.white.opacity(0.7), lineWidth: 12)
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
                            .blur(radius: 2)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: UIConstants.highlightAnimationDuration), value: highlightIndex)
                    } else {
                        Image("BlackSeeds")
                            .resizable()
                            .frame(width: UIConstants.seedSize, height: UIConstants.seedSize)
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
