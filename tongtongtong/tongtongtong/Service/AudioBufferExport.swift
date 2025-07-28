import Foundation
import AVFoundation

struct AudioBufferExport {
    /// Saves the given AVAudioPCMBuffer as a .wav file at the specified URL.
    static func writeWAV(buffer: AVAudioPCMBuffer, to url: URL) throws {
        let outputFormat = AVAudioFormat(commonFormat: .pcmFormatInt16,
                                         sampleRate: buffer.format.sampleRate,
                                         channels: buffer.format.channelCount,
                                         interleaved: true)!

        guard let converter = AVAudioConverter(from: buffer.format, to: outputFormat) else {
            throw NSError(domain: "AudioBufferExport", code: -2, userInfo: [NSLocalizedDescriptionKey: "Failed to create converter"])
        }

        let convertedBuffer = AVAudioPCMBuffer(pcmFormat: outputFormat,
                                               frameCapacity: buffer.frameCapacity)!
        convertedBuffer.frameLength = buffer.frameLength

        var error: NSError?
        converter.convert(to: convertedBuffer, error: &error) { inNumPackets, outStatus in
            outStatus.pointee = .haveData
            return buffer
        }

        if let error = error {
            throw error
        }

        let file = try AVAudioFile(forWriting: url,
                                   settings: outputFormat.settings,
                                   commonFormat: .pcmFormatInt16,
                                   interleaved: true)
        try file.write(from: convertedBuffer)
    }
}
