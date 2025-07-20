import SwiftUI

struct ResultView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var state = ResultState()
    
    init() {
        print("[ResultView] init")
    }
    
    var body: some View {
        ZStack {
            Image(state.ripeness.imageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack {
                ResultAnalysisView(state: state)
                    .padding(.top, 236)
                
                Spacer()
                
                HStack(alignment: .center) {
                    Image(systemName: "arrow.clockwise")
                    Text("처음으로")
                }
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .semibold))
                .onTapGesture {
                    HapticManager.shared.impact(style: .medium)
                    coordinator.goToContent()
                }
                .padding(.bottom, UIConstants.bottomMargin)
            }
        }
        .onAppear {
            print("[ResultView] onAppear")
        }
        .onDisappear {
            print("[ResultView] onDisappear")
        }
    }
}

#Preview {
    let state = ResultState()
    state.confidence = 0.85
    return ResultView().environmentObject(state)
}
