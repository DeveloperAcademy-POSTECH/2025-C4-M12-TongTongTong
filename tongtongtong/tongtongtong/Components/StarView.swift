//
//  StarView.swift
//  tongtongtong
//
//  Created by cheshire on 7/13/25.
//

import SwiftUI


struct StarView: View {
    var imageName: String
    var size: CGSize
    var offset: CGSize

    @State private var opacity: Double = 1.0

    var body: some View {
        Image(imageName)
            .resizable()
            .frame(width: size.width, height: size.height)
            .offset(x: offset.width, y: offset.height)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: Double.random(in: 1.0...2.0)).repeatForever(autoreverses: true)) {
                    opacity = 0.2
                }
            }
    }
}
