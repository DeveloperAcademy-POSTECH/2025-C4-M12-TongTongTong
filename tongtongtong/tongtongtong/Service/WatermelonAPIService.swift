import Foundation
import AVFoundation

class WatermelonAPIService {
    static let shared = WatermelonAPIService()
    
    private let baseURL: String = {
        let url = Bundle.main.object(forInfoDictionaryKey: "BASE_URL") as? String ?? ""
        print("[DEBUG] BASE_URL: \(url)")
        return url
    }()
    
    private init() {}
    
    // MARK: - 서버 상태 확인
    func checkServerHealth(completion: @escaping (Result<ServerHealthResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/health") else {
            print("[DEBUG] Invalid health URL: \(baseURL)/health")
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("[DEBUG] Checking server health at: \(url)")
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("[DEBUG] Health check error: \(error)")
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("[DEBUG] Health check response status: \(httpResponse.statusCode)")
            }
            
            guard let data = data else {
                print("[DEBUG] No data received from health check")
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let healthResponse = try JSONDecoder().decode(ServerHealthResponse.self, from: data)
                print("[DEBUG] Health check successful: \(healthResponse)")
                completion(.success(healthResponse))
            } catch {
                print("[DEBUG] Health check decode error: \(error)")
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
            print("[DEBUG] Invalid predict URL: \(baseURL)/predict")
            completion(.failure(APIError.invalidURL))
            return
        }
        
        print("[DEBUG] Making prediction request to: \(url)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let fileData = try Data(contentsOf: audioFileURL)
            let fileName = audioFileURL.lastPathComponent
            let mimeType = getMimeType(for: audioFileURL.pathExtension)
            
            print("[DEBUG] Uploading file: \(fileName), size: \(fileData.count) bytes, mime: \(mimeType)")
            
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
                    print("[DEBUG] Prediction request error: \(error)")
                    completion(.failure(error))
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("[DEBUG] Prediction response status: \(httpResponse.statusCode)")
                }
                
                guard let data = data else {
                    print("[DEBUG] No data received from prediction request")
                    completion(.failure(APIError.noData))
                    return
                }
                
                print("[DEBUG] Received data size: \(data.count) bytes")
                
                do {
                    let predictionResponse = try JSONDecoder().decode(PredictionResponse.self, from: data)
                    print("[DEBUG] Prediction successful: \(predictionResponse)")
                    completion(.success(predictionResponse))
                } catch {
                    print("[DEBUG] Prediction decode error: \(error)")
                    // 에러 응답 파싱 시도
                    if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                        print("[DEBUG] Server error response: \(errorResponse)")
                        completion(.failure(APIError.serverError(errorResponse.error)))
                    } else {
                        completion(.failure(error))
                    }
                }
            }.resume()
            
        } catch {
            print("[DEBUG] File reading error: \(error)")
            completion(.failure(error))
        }
    }
    
    func predictWatermelon(audioFileURL: URL) async throws -> PredictionResponse {
        guard let url = URL(string: "\(baseURL)/predict") else {
            throw APIError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let fileData = try Data(contentsOf: audioFileURL)
        let fileName = audioFileURL.lastPathComponent
        let mimeType = getMimeType(for: audioFileURL.pathExtension)
        
        var body = Data()
        
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(fileData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            if let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                throw APIError.serverError(errorResponse.error)
            }
            throw APIError.serverError("Invalid response from server")
        }
        
        return try JSONDecoder().decode(PredictionResponse.self, from: data)
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
    
    // MARK: - 서버 연결 테스트
    func testServerConnection(completion: @escaping (Bool) -> Void) {
        print("[DEBUG] Testing server connection...")
        
        // 먼저 서버 상태 확인
        checkServerHealth { result in
            switch result {
            case .success(let healthResponse):
                print("[DEBUG] Server is healthy: \(healthResponse)")
                completion(true)
            case .failure(let error):
                print("[DEBUG] Server health check failed: \(error)")
                
                // 간단한 ping 테스트
                guard let url = URL(string: "\(self.baseURL)/health") else {
                    print("[DEBUG] Invalid URL for ping test")
                    completion(false)
                    return
                }
                
                var request = URLRequest(url: url)
                request.timeoutInterval = 10.0
                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    if let error = error {
                        print("[DEBUG] Ping test failed: \(error)")
                        completion(false)
                    } else if let httpResponse = response as? HTTPURLResponse {
                        print("[DEBUG] Ping test response: \(httpResponse.statusCode)")
                        completion(httpResponse.statusCode == 200)
                    } else {
                        print("[DEBUG] Ping test: no valid response")
                        completion(false)
                    }
                }.resume()
            }
        }
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

// MARK: - SSL 인증 우회 Delegate (개발용)
class CustomSessionDelegate: NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let trust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: trust))
        } else {
            completionHandler(.cancelAuthenticationChallenge, nil)
        }
    }
}
