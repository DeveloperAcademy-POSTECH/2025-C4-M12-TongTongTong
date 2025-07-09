//
//  TitleView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct TitleView: View {
    @State private var tapCount = 0
    @State private var path: [TitleNavigation] = []
    
    var body: some View {
        NavigationStack(path: $path) {
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
                .onTapGesture {
                    tapCount += 1
                    if tapCount >= 3 {
                        path.append(.dev)
                        tapCount = 0
                    }
                }
                
                Text("수박을 눌러 분석을 시작해주세요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                    .foregroundColor(.white)
            }
            .navigationDestination(for: TitleNavigation.self) { destination in
                switch destination {
                case .dev:
                    DevView()
                }
            }
        }
    }
}

enum TitleNavigation: Hashable {
    case dev
}

#Preview {
    TitleView()
        .background(Color.blue)
}
