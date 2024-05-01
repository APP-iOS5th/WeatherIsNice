//
//  APIService.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 5/1/24.
//

import Foundation

public class APIService {
    public static let shared = APIService()
    
    public enum APIError: Error {
        case error(_ errorString: String)
    }
    
    
    func getJSON(urlString: String,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                 completion: @escaping (Result<Forecast, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error("Error: Invalid URL")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }
            
            guard let data = data else {
                completion(.failure(.error(NSLocalizedString("Error: Data us corrupt.", comment: ""))))
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(Forecast.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                return
            }
            
        }.resume()
    }
}

public class CurrentAPIService {
    public static let shared = CurrentAPIService()

    public enum APIError: Error {
        case error(_ errorString: String)
    }

//    @available(iOS 8.0, *)
    public func getJSON<T: Decodable>(urlString: String,
                 dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                 keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
                 completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error("Error: Invalid URL")))
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }

            guard let data = data else {
                completion(.failure(.error(NSLocalizedString("Error: Data us corrupt.", comment: ""))))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy

            do {
                let decodedData = try decoder.decode(T.self, from: data)
                completion(.success(decodedData))
            } catch let decodingError {
                completion(.failure(APIError.error("Error: \(decodingError.localizedDescription)")))
                return
            }

        }.resume()
    }
}
