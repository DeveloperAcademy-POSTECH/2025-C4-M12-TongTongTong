import SwiftUI
import AVFoundation

struct RecordingView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject private var viewModel = RecordingViewModel()
    @State private var showMicAlert = false
    @State private var showCountdown = false
    
    var body: some View {
        ZStack {
            if showCountdown {
                RecordingCountdownView(
                    isShowing: $showCountdown,
                    onFinished: {
                        viewModel.startMonitoring {
                            coordinator.goToRecordingComplete()
                        }
                    }
                )
            } else {
                RecordingContentView(viewModel: viewModel)
            }
        }
        .onAppear {
            showMicAlert = true
            viewModel.onRecordingCompleted = { url in
                coordinator.resultState.audioFileURL = url
                coordinator.goToRecordingComplete()
            }
        }
        .onDisappear {
            viewModel.stopMonitoring()
        }
        .alert("마이크를 켜시겠습니까?", isPresented: $showMicAlert) {
            Button("취소", role: .cancel) {
                coordinator.goToMain()
            }
            Button("확인") {
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    DispatchQueue.main.async {
                        if granted {
                            withAnimation {
                                showCountdown = true
                            }
                        } else {
                            coordinator.goToMain()
                        }
                    }
                }
            }
        } message: {
            Text("수박을 3번 두드려서 소리를 감지합니다.\n크게 두드려 주세요!")
        }
    }
}
