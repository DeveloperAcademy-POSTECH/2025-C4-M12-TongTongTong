import SwiftUI

struct ResultView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var state: ResultState
    
    init() {
        print("[ResultView] init")
    }
    
    var body: some View {
        ZStack {
            Image(state.resultImageName)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .onTapGesture(count: 3) {
                    state.cycleResultForDebug()
                }
            
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
                    coordinator.goToMain()
                }
                .padding(.bottom, UIConstants.resultBottomMargin)
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
    ResultView().environmentObject(ResultState())
}
