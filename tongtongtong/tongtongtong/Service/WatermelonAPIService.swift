//
//  WatermelonAPIService.swift
//  tongtongtong
//
//  Created by 조유진 on 7/17/25.
//

import Foundation
import AVFoundation

class WatermelonAPIService {
    static let shared = WatermelonAPIService()
    
    private let baseURL: String = {
        Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
    }()
    
    private init() {}
    
    // MARK: - 서버 상태 확인
    func checkServerHealth(completion: @escaping (Result<ServerHealthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/health") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let healthResponse = try JSONDecoder().decode(ServerHealthResponse.self, from: data)
                completion(.success(healthResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - 수박 상태 예측
    /// Uploads an audio file and receives ripeness prediction result from the server.
    /// - Parameters:
    ///   - audioFileURL: Local file URL of the audio file to upload.
    ///   - completion: Called with PredictionResponse on success, or Error on failure.
    func predictWatermelon(audioFileURL: URL, completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/predict") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let fileData = try Data(contentsOf: audioFileURL)
            let fileName = audioFileURL.lastPathComponent
            let mimeType = getMimeType(for: audioFileURL.pathExtension)
            
            var body = Data()
            
            // 파일 데이터 추가
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n")
            body.append("Content-Type: \(mimeType)\r\n\r\n")
            body.append(fileData)
            body.append("\r\n--\(boundary)--\r\n")
            
            request.httpBody = body
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    completion(.failure(APIError.noData))
                    return
                }
                
                do {
                    let predictionResponse = try JSONDecoder().decode(PredictionResponse.self, from: data)
                    completion(.success(predictionResponse))
                } catch {
                    // 에러 응답 파싱 시도
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        completion(.failure(APIError.serverError(errorResponse.error)))
                    } else {
                        completion(.failure(error))
                    }
                }
            }.resume()
            
        } catch {
            completion(.failure(error))
        }
    }

    /// Uploads an audio file and receives ripeness prediction result from the server.
    /// - Parameters:
    ///   - audioFile: Local file URL of the audio file to upload.
    ///   - completion: Called with PredictionResponse on success, or Error on failure.
    public func predictWatermelon(audioFile: URL, completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
        predictWatermelon(audioFileURL: audioFile, completion: completion)
    }
    
    // MARK: - 지원 형식 확인
    func getSupportedFormats(completion: @escaping (Result<SupportedFormatsResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/supported-formats") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let formatsResponse = try JSONDecoder().decode(SupportedFormatsResponse.self, from: data)
                completion(.success(formatsResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Helper Methods
    private func getMimeType(for fileExtension: String) -> String {
        switch fileExtension.lowercased() {
        case "wav":
            return "audio/wav"
        case "m4a":
            return "audio/m4a"
        case "mp3":
            return "audio/mpeg"
        default:
            return "application/octet-stream"
        }
    }
}

// MARK: - Data Extension
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

// MARK: - API 에러 정의
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case serverError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다."
        case .noData:
            return "데이터를 받지 못했습니다."
        case .serverError(let message):
            return "서버 에러: \(message)"
        }
    }
}
