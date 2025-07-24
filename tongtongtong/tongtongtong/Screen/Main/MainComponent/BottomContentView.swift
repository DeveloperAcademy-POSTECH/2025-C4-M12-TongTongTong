// MARK: - 하단 콘텐츠 뷰
private struct BottomContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    let isTransitioning: Bool
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                TitleView(isMicActive: viewModel.isMicActive, isTransitioning: isTransitioning)
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