//
//  MeasurementView.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import SwiftUI
import Charts

struct MeasurementView: View {
    @StateObject var viewModel = MeasurementViewModel()
    @State private var selectedGraphType: GraphType = .amplitude

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 상단 결과 영역
                VStack(spacing: 20) {
                    // 측정 상태 표시
                    statusIndicator

                    // 결과 카드들
                    HStack(spacing: 16) {
                        resultCard(title: "라벨", value: viewModel.lastLabel, icon: "tag.fill")
                        resultCard(title: "신뢰도", value: viewModel.lastConfidence.formatted(.percent), icon: "chart.bar.fill")
                    }

                    // 사운드 그래프
                    soundGraph
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 30)
                .background(Color(uiColor: .systemGroupedBackground))

                Spacer()

                // 하단 컨트롤 영역
                VStack(spacing: 16) {
                    // 측정 진행 상태
                    if viewModel.isMeasuring {
                        HStack(spacing: 12) {
                            ProgressView()
                                .scaleEffect(1.2)
                            Text("측정 중...")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.vertical, 8)
                    }

                    // 메인 버튼
                    Button(action: {
                        withAnimation(.spring()) {
                            if viewModel.isMeasuring {
                                viewModel.stop()
                            } else {
                                viewModel.start()
                            }
                        }
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: viewModel.isMeasuring ? "stop.fill" : "play.fill")
                                .font(.title3)
                            Text(viewModel.isMeasuring ? "측정 중지" : "측정 시작")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(viewModel.isMeasuring ? Color.red : Color.blue)
                        )
                        .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .scaleEffect(viewModel.isMeasuring ? 0.98 : 1.0)
                    .animation(.spring(response: 0.3), value: viewModel.isMeasuring)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationTitle("측정")
            .navigationBarTitleDisplayMode(.large)
            .background(Color(uiColor: .systemBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // 상태 표시 인디케이터
    private var statusIndicator: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(viewModel.isMeasuring ? Color.green : Color.gray)
                .frame(width: 8, height: 8)
                .scaleEffect(viewModel.isMeasuring ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: viewModel.isMeasuring)

            Text(viewModel.isMeasuring ? "활성" : "대기")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
    
    // 사운드 그래프
    private var soundGraph: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "waveform")
                    .foregroundColor(.blue)
                Text("실시간 데이터")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)
                Spacer()
            }
            
            if viewModel.audioDataPoints.isEmpty {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(uiColor: .systemGray5))
                    .frame(height: 80)
                    .overlay(
                        Text("측정을 시작하면 그래프가 표시됩니다")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    )
            } else {
                // 탭 선택
                Picker("그래프 타입", selection: $selectedGraphType) {
                    Text("진폭").tag(GraphType.amplitude)
                    Text("신뢰도").tag(GraphType.confidence)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 8)
                
                // 선택된 그래프 표시
                if selectedGraphType == .amplitude {
                    amplitudeGraph
                } else {
                    confidenceGraph
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
    
    // 진폭 그래프
    private var amplitudeGraph: some View {
        Chart {
            ForEach(viewModel.audioDataPoints) { dataPoint in
                LineMark(
                    x: .value("시간", dataPoint.timestamp),
                    y: .value("진폭", dataPoint.amplitude)
                )
                .foregroundStyle(.blue)
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                AreaMark(
                    x: .value("시간", dataPoint.timestamp),
                    y: .value("진폭", dataPoint.amplitude)
                )
                .foregroundStyle(.blue.opacity(0.1))
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.second())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYScale(domain: 0...max(viewModel.audioDataPoints.map(\.amplitude).max() ?? 0.1, 0.1))
        .animation(.easeInOut(duration: 0.3), value: viewModel.audioDataPoints.count)
    }
    
    // 신뢰도 그래프
    private var confidenceGraph: some View {
        Chart {
            ForEach(viewModel.audioDataPoints) { dataPoint in
                LineMark(
                    x: .value("시간", dataPoint.timestamp),
                    y: .value("신뢰도", dataPoint.confidence)
                )
                .foregroundStyle(.red)
                .lineStyle(StrokeStyle(lineWidth: 2))
                
                AreaMark(
                    x: .value("시간", dataPoint.timestamp),
                    y: .value("신뢰도", dataPoint.confidence)
                )
                .foregroundStyle(.red.opacity(0.1))
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel(format: .dateTime.second())
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { _ in
                AxisGridLine()
                AxisTick()
                AxisValueLabel()
            }
        }
        .chartYScale(domain: 0...1.0)
        .animation(.easeInOut(duration: 0.3), value: viewModel.audioDataPoints.count)
    }

    // 결과 카드 컴포넌트
    private func resultCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)

            VStack(spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.secondary)

                Text(value)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(uiColor: .systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
        )
    }
}

struct MeasurementView_Previews: PreviewProvider {
    static var previews: some View {
        MeasurementView()
    }
}
