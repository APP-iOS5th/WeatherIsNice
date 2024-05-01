import Foundation
import CoreLocation


struct Forecast: Codable {
    struct List: Codable {
        let dt: Date
        struct Main: Codable {
            let temp: Double
            let temp_min: Double
            let temp_max: Double
        }
        let main: Main
        struct Weather: Codable {
            let id: Int
            let description: String
            let icon: String
            var weatherIconURL: URL {
                let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                return URL(string: urlString)! // 굉장히 위험함
            }
        }
        let weather: [Weather]
    }
    let list: [List]
    
}

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


//Test
let apiService = APIService.shared
let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "E, MMM, d"
CLGeocoder().geocodeAddressString("Seoul") {(placemarks, error) in
    if let error = error {
        print(error.localizedDescription)
    }
    if let lat = placemarks?.first?.location?.coordinate.latitude,
        let lon = placemarks?.first?.location?.coordinate.longitude {
        apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=ce878d5130eaace7c56141ff9190f16f&units=metric", dateDecodingStrategy: .secondsSince1970) {
            (result: Result<Forecast,APIService.APIError>) in
            switch result {
            case .success(let forecast):
                for day in forecast.list {
                    print(dateFormatter.string(from: day.dt))
                    print("     Temp: ", day.main.temp)
                    print("     Temp_min: ", day.main.temp_min)
                    print("     Temp_max: ", day.main.temp_max)
                    print("     Description: ", day.weather[0].description)
                    print("     IconURL: ", day.weather[0].weatherIconURL)
                }
                
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    print(errorString)
                }
            }
            
        }

    }
}



struct Current: Codable {
    let dt: Date
    struct Main: Codable{
        let temp: Double
    }
    let main: Main
    struct Weather: Codable{
        let id: Int
        let main: String
        let description:  String
        let icon: String
        var weatherIconURL: URL {
            let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
            return URL(string: urlString)! // 굉장히 위험함
        }
    }
    let weather: [Weather]
}

@available(iOS 8.0, *)
public class CurrentAPIService {
    public static let shared = CurrentAPIService()

    public enum APIError: Error {
        case error(_ errorString: String)
    }

    @available(iOS 8.0, *)
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



//Test

let currentapiService = CurrentAPIService.shared
let currentdateFormatter = DateFormatter()
currentdateFormatter.dateFormat = "MMM, d, HH:mm"
CLGeocoder().geocodeAddressString("Seoul") { (placemarks, error) in
    if let error = error {
        print(error.localizedDescription)
    }
    if let lat = placemarks?.first?.location?.coordinate.latitude,
       let lon = placemarks?.first?.location?.coordinate.longitude {
        currentapiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=ce878d5130eaace7c56141ff9190f16f&units=metric", dateDecodingStrategy: .secondsSince1970) { (result: Result<Current, CurrentAPIService.APIError>) in
            switch result {
            case .success(let current):
                print(dateFormatter.string(from: current.dt))
                print("     Temp: \(current.main.temp)")
                print("     main: \(current.weather[0].main)")
                print("     discription: \(current.weather[0].description)")
                print("     Icon: \(current.weather[0].weatherIconURL)")
            case .failure(let apiError):
                switch apiError {
                case .error(let errorString):
                    print(errorString)
                }
            }
            
        }
    }
}




