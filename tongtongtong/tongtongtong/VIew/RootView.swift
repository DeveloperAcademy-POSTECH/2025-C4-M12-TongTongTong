//
//  RootView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    var body: some View {
        if showSplash {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.splashDisplayDuration) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            ContentView()
        }
    }
}
