//
//  DevView.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import SwiftUI

struct DevView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    init() {
        print("[DevView] init")
    }
    
    var body: some View {
        TabView {

        }
        .onAppear {
            print("[DevView] onAppear")
        }
        .onDisappear {
            print("[DevView] onDisappear")
        }
    }
}



#Preview {
    DevView()
}
