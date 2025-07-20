//
//  ResultAnalysisView.swift
//  tongtongtong
//
//  Created by 조유진 on 7/20/25.
//

import SwiftUI

struct ResultAnalysisView: View {
    @ObservedObject var state: ResultState
    
    var ripeScore: Double {
        let score: Double
        if state.confidence < 0.5 {
            score = (state.confidence / 0.5) * 2 + 1
        } else {
            score = ((state.confidence - 0.5) / 0.5) * 2 + 3
        }
        return min(max(score, 1), 5)
    }
    
    var body: some View {
        HStack {
            VStack(spacing: 8) {
                Text("숙성도")
                    .font(.system(size: 12, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(String(format: "%.1f", ripeScore))
                    .font(.system(size: 24, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("⭐️⭐️⭐️⭐️⭐️")
                    .font(.system(size: 10, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 0.5, height: 48)
                .background(.white.opacity(0.8))
                .padding(.horizontal, 35)
            
            VStack(spacing: 8) {
                Text("주파수")
                    .font(.system(size: 12, weight: .medium))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
                
                Text(String(state.result)) // 모델에서 Hz 보내도록 변경하면 바꿀 예정
                    .font(.system(size: 24, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("헤르츠 (Hz)")
                    .font(.system(size: 10, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white.opacity(0.8))
            }
        }
    }
}

#Preview {
    let state = ResultState()
    state.confidence = 0.737
    state.result = "높음"
    return ResultAnalysisView(state: state)
}
