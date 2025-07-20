//
//  RootView.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

struct RootView: View {
    @EnvironmentObject var coordinator: Coordinator
    @State private var showSplash = true
    var body: some View {
        switch coordinator.currentScreen {
        case .splash:
            SplashView()
        case .content:
            MainView()
        case .analysis:
            AnalysisView()
        case .result:
            ResultView()
        case .dev:
            DevView()
        case .recordingComplete:
            RecordingCompleteView()
        }
    }
}
