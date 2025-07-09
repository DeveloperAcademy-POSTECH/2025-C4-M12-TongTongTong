//
//  RecordsViewModel.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import Foundation

final class RecordsViewModel: ObservableObject {
    static let shared = RecordsViewModel()
    @Published private(set) var records: [SoundRecord] = []

    private let key = "sound_records"

    private init() {
        load()
    }

    func addRecord(label: String, confidence: Double, audioDataPoints: [SoundRecord.AudioDataPoint] = []) {
        let record = SoundRecord(
            timestamp: Date(),
            label: label,
            confidence: confidence,
            audioDataPoints: audioDataPoints
        )
        records.insert(record, at: 0)
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(records) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([SoundRecord].self, from: data)
        else { return }
        records = decoded
    }
}
