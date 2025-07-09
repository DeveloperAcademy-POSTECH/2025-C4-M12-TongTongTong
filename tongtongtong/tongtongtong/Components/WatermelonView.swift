//
//  WatermelonView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct WatermelonView: View {
    let isMicActive: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            Image("WholeWatermelon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: UIConstants.watermelonSize, height: UIConstants.watermelonSize)
                .offset(y: -60)
                .onTapGesture {
                    if !isMicActive {
                        onTap()
                    }
                }
        }
    }
}

#Preview {
    WatermelonView(isMicActive: false) {
        print("Watermelon tapped")
    }
} 