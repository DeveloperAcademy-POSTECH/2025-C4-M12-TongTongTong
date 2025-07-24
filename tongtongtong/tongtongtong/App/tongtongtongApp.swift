//
//  tongtongtongApp.swift
//  tongtongtong
//
//  Created by cheshire on 7/8/25.
//

import SwiftUI

@main
struct tongtongtongApp: App {
    @StateObject var coordinator = Coordinator()
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(coordinator)
        }
    }
}


