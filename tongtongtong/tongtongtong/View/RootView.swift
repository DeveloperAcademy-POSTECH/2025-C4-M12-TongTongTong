//
//  RootView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct RootView: View {
    @State private var showSplash = true
    @State private var path = NavigationPath()

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
            NavigationStack(path: $path) {
                ContentView(navigationPath: $path)
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .analyzing(let isRed):
                            AnalyzingView(isRedBackground: isRed, navigationPath: $path)
                        case .result(let isRed):
                            ResultView(isRedBackground: isRed, navigationPath: $path)
                        }
                    }
            }
        }
    }
}
