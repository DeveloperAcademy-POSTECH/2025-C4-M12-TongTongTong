import SwiftUI

// MARK: - 하단 콘텐츠 뷰
struct BottomContentView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleView(isMicActive: viewModel.isMicActive)
                Spacer()
                if viewModel.isMicActive {
                    VStack {
                        SeedIndicatorView(highlightIndex: viewModel.highlightIndex, indicatorCount: viewModel.indicatorCount)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 80)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
}

