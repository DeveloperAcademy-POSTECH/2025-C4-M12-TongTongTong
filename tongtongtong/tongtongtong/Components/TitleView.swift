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
    let isTransitioning: Bool
    
    var body: some View {
        VStack {
            if !isMicActive {
                VStack(spacing: 4){
                    Image(systemName: "waveform")
                        .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    VStack(spacing: 3){
                        Text("녹음 시작")
                            .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Text("가운데 수박 버튼을 탭하세요")
                            .font(.system(size: UIConstants.subtitleFontSize, weight: .regular))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.72))
                    }
                }
            } else {
                VStack(spacing: 4){
                    Image(systemName: "hand.wave.fill")
                        .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    VStack(spacing: 3){
                        Text("통통통")
                            .font(.system(size: UIConstants.titleFontSize, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Text("손 끝을 모아서 수박을 세 번 두드리세요")
                            .font(.system(size: UIConstants.subtitleFontSize, weight: .bold))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white.opacity(0.72))
                    }
                }
            }
        }
    }
}

#Preview {
    TitleView(isMicActive: true)
        .background(Color.blue)
}
