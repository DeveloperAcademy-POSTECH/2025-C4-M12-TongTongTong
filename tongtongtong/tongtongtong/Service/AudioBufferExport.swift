import Foundation
import AVFoundation

struct AudioBufferExport {
    /// Saves the given AVAudioPCMBuffer as a .wav file at the specified URL.
    static func writeWAV(buffer: AVAudioPCMBuffer, to url: URL) throws {
        let format = buffer.format
        guard let file = try? AVAudioFile(forWriting: url, settings: format.settings, commonFormat: .pcmFormatInt16, interleaved: true) else {
            throw NSError(domain: "AudioBufferExport", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to create AVAudioFile"])
        }
        try file.write(from: buffer)
    }
}
