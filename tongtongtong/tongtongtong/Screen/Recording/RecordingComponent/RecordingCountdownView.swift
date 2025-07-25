import SwiftUI

struct RecordingCountdownView: View {
    @Binding var isShowing: Bool
    var onFinished: () -> Void
    
    @State private var count: Int = 3
    @State private var scale: CGFloat = 0.1
    
    @State private var previousCount: Int? = nil
    @State private var previousOpacity: Double = 0
    @State private var previousScale: CGFloat = 1.0
    
    var body: some View {
        if isShowing {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 200, height: 200)
                    .overlay (
                        ZStack {
                            if let prev = previousCount {
                                Text("\(prev)")
                                    .font(.system(size: 240, weight: .bold))
                                    .foregroundColor(Color(red: 1, green: 0.55, blue: 0.47))
                                    .scaleEffect(previousScale)
                                    .opacity(previousOpacity)
                            }
                            
                            Text("\(count)")
                                .font(.system(size: 128, weight: .bold))
                                .foregroundColor(Color(red: 1, green: 0.55, blue: 0.47))
                                .scaleEffect(scale)
                        }
                    )
                    .onAppear(perform: startCountdown)
            }
            .transition(.opacity)
        }
    }
    
    private func startCountdown() {
        count = 3
        scale = 0.1
        previousCount = nil
        previousOpacity = 0
        previousScale = 1.0
        
        withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
            scale = 1.2
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            withAnimation(.easeIn(duration: 0.2)) {
                scale = 0.1
            }
        }
        
        let nextCounts = [2, 1]
        for (index, newCount) in nextCounts.enumerated() {
            let delay = Double(index + 1)   // 1초 후에 2, 2초 후에 1
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                previousCount = count
                previousOpacity = 0.3
                previousScale   = 1.0
                
                withAnimation(.easeOut(duration: 0.8)) {
                    previousOpacity = 0
                    previousScale   = 1.3
                }
                
                count = newCount
                scale = 0.1
                withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                    scale = 1.2
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.easeIn(duration: 0.2)) {
                        scale = 0.1
                    }
                }
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                withAnimation {
                    self.isShowing = false
                }
            }
            self.onFinished()
        }
    }
}
