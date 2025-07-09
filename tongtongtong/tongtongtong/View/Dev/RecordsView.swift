//
//  RecordView.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import SwiftUI
import Charts

struct RecordsView: View {
    @ObservedObject private var vm = RecordsViewModel.shared

    var body: some View {
        List(vm.records) { record in
            NavigationLink(destination: RecordDetailView(record: record)) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(record.label)
                            .font(.headline)
                        Text(record.timestamp, style: .time)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(String(format: "%.1f%%", record.confidence * 100))
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        Text("\(record.audioDataPoints.count) 데이터")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("기록")
    }
}

struct RecordDetailView: View {
    let record: SoundRecord
    @State private var selectedGraphType: GraphType = .amplitude
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // 기록 정보 카드
                VStack(spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("분류 결과")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(record.label)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("신뢰도")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(String(format: "%.1f%%", record.confidence * 100))
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.blue)
                        }
                    }
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("측정 시간")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(record.timestamp, style: .date)
                                .font(.subheadline)
                        }
                        Spacer()
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("측정 시각")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text(record.timestamp, style: .time)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .systemBackground))
                        .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                )
                
                // 그래프 영역
                if !record.audioDataPoints.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .foregroundColor(.blue)
                            Text("측정 데이터")
                                .font(.headline)
                            Spacer()
                        }
                        
                        // 탭 선택
                        Picker("그래프 타입", selection: $selectedGraphType) {
                            Text("진폭").tag(GraphType.amplitude)
                            Text("신뢰도").tag(GraphType.confidence)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        
                        // 선택된 그래프 표시
                        if selectedGraphType == .amplitude {
                            amplitudeGraph
                        } else {
                            confidenceGraph
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                } else {
                    VStack(spacing: 12) {
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .font(.title)
                            .foregroundColor(.secondary)
                        Text("그래프 데이터가 없습니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 120)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(uiColor: .systemGray6))
                    )
                }
            }
            .padding(20)
        }
        .navigationTitle("기록 상세")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(uiColor: .systemGroupedBackground))
    }
    
    // 진폭 그래프
    private var amplitudeGraph: some View {
        Chart {
            ForEach(record.audioDataPoints) { dataPoint in
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
        .frame(height: 200)
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
        .chartYScale(domain: 0...max(record.audioDataPoints.map(\.amplitude).max() ?? 0.1, 0.1))
    }
    
    // 신뢰도 그래프
    private var confidenceGraph: some View {
        Chart {
            ForEach(record.audioDataPoints) { dataPoint in
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
        .frame(height: 200)
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
    }
}
