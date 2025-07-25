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
    ///   - audioFile: Local file URL of the audio file to upload.
    ///   - completion: Called with PredictionResponse on success, or Error on failure.
    func predictWatermelon(audioFile: URL, completion: @escaping (Result<PredictionResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/predict") else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        do {
            let fileData = try Data(contentsOf: audioFile)
            let fileName = "recorded_sound.wav"
            let mimeType = "audio/wav"
            
            var body = Data()
            
            // 파일 데이터 추가
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
            body.append(fileData)
            body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
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
                        //MARK: - Decoding 에러 디버깅
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("Failed to decode JSON: \(jsonString)")
                        }
                        completion(.failure(error))
                    }
                }
            }.resume()
            
        } catch {
            completion(.failure(error))
        }
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
