//
//  TitleView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        VStack(spacing: UIConstants.titleSpacing) {
            HStack(spacing: UIConstants.circleSpacing) {
                ForEach(0..<3) { _ in
                    VStack(spacing: 0) {
                        Circle()
                            .frame(width: UIConstants.circleDotSize, height: UIConstants.circleDotSize)
                            .foregroundColor(.white)
                        Text("통")
                            .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
            }
            
            Text("수박을 눌러 분석을 시작해주세요")
                .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    TitleView()
        .background(Color.blue)
} 
