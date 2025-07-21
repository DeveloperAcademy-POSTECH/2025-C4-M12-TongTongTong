//
//  TitleView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct TitleView: View {
    @EnvironmentObject var coordinator: Coordinator
    let isMicActive: Bool
    @State private var tapCount = 0
    
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
            .onTapGesture {
                tapCount += 1
                if tapCount >= 3 {
                    // 디버그 모드 토글
                    if let mainViewModel = coordinator.mainViewModel {
                        mainViewModel.showDebugOverlay.toggle()
                        HapticManager.shared.impact(style: .medium)
                    }
                    tapCount = 0
                }
            }
            
            if !isMicActive {
                Text("수박을 눌러 녹음을 시작해주세요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                    .foregroundColor(.white)
            } else {
                Text("손 끝으로 수박을 세 번 두드려주세요")
                    .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

#Preview {
    TitleView(isMicActive: false)
        .background(Color.blue)
}
