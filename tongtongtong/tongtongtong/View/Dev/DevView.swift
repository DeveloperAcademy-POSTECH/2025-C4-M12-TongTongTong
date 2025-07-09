//
//  DevView.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import SwiftUI

struct DevView: View {
    var body: some View {
        VStack {
           Text("개발자모드에오신걸환영합니다")
                .fontWeight(.bold)
            
            TabView {
                MeasurementView()
                    .tabItem {
                        Label("측정", systemImage: "mic.fill")
                    }

                NavigationView {
                    RecordsView()
                }
                .tabItem {
                    Label("기록", systemImage: "list.bullet")
                }
            }
        }
    }
}

enum GraphType {
    case amplitude
    case confidence
} 

#Preview {
    DevView()
}
