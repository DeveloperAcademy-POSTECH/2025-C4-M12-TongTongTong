import Foundation

struct ServerHealthResponse: Codable {
    let status: String
    let message: String
}

struct PredictionResponse: Codable {
    let success: Bool
    let filename: String
    let prediction: Double
    let result: String
    let confidence: Double
}

struct ErrorResponse: Codable {
    let success: Bool
    let error: String
}

struct SupportedFormatsResponse: Codable {
    let formats: [String]
    let description: String
}
