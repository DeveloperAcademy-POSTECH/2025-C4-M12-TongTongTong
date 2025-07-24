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
                        Image("BlackSeed")
                    } else if highlightIndex >= indicatorCount {
                        Image("WhiteSeed")
                            .shadow(color: .white, radius: 6, x: 0, y: 0)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: UIConstants.highlightAnimationDuration), value: highlightIndex)
                    } else if idx < highlightIndex {
                        Image("WhiteSeed")
                            .shadow(color: .white, radius: 6, x: 0, y: 0)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: UIConstants.highlightAnimationDuration), value: highlightIndex)
                    } else {
                        Image("BlackSeed")
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
