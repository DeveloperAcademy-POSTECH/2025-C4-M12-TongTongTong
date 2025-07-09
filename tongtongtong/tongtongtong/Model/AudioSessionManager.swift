//
//  AudioSessionManager.swift
//  tongtongtong
//
//  Created by 조유진 on 7/9/25.
//

import AVFoundation

final class AudioSessionManager {
    static let shared = AudioSessionManager()
    private init() {}

    func configureSession() throws {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.record, mode: .measurement, options: .interruptSpokenAudioAndMixWithOthers)
        try session.setActive(true, options: .notifyOthersOnDeactivation)
    }
}

