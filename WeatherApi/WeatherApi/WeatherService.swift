//
//  WeatherService.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import Foundation
import CoreLocation


public final class WeatherService: NSObject {
    
    private let locationManager = CLLocationManager()
    private let API_KEY = "ce878d5130eaace7c56141ff9190f16f"
    private var completionHandler: ((Weather) -> Void)?
    private var forecastcompletionHandler: ((ForecastWeather) -> Void)?
    private var ForecastDatalist: [String] = []
    
    public override init() {
        super.init()
        locationManager.delegate = self
    }
    
    
    
    public func loadWeatherData(_ completionHandler: @escaping((Weather) -> Void)) {
        self.completionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    public func loadForecastWeatherData(_ completionHandler: @escaping((ForecastWeather) -> Void)) {
        self.forecastcompletionHandler = completionHandler
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    //https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key} // 위도 경도 넣으세요
    private func makeDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        guard let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {return}
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(APIResponse.self, from: data) {
                self.completionHandler?(Weather(response: response))
            }
        }.resume()
    }
    
    // forcast API
    private func makeForecastDataRequest(forCoordinates coordinates: CLLocationCoordinate2D) {
        
        
        guard let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(coordinates.latitude)&lon=\(coordinates.longitude)&appid=\(API_KEY)&units=metric"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("error")
            return
        }
        
        guard let url = URL(string: urlString) else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {return}
            if let response = try? JSONDecoder().decode(ForecastAPIResponse.self, from: data) {
                self.forecastcompletionHandler?(ForecastWeather(response: response))
            }
            
        }.resume()
        
    }

    
}

extension WeatherService: CLLocationManagerDelegate {
    public func locationManager (
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {
        guard let location = locations.first else { return}
        makeDataRequest(forCoordinates: location.coordinate)
        makeForecastDataRequest(forCoordinates: location.coordinate)
    }
    
    public func locationManager(
        _ manager: CLLocationManager,
        didFailWithError error: Error
    ) {
        print("Something went wrong: \(error.localizedDescription)")
    }
}


struct APIResponse: Decodable {
    let name: String
    let main: APIMain
    let weather: [APIWeather]
}

struct APIMain: Decodable {
    let temp: Double
}

struct APIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey{
        case description
        case iconName = "main"
    }
}



// forcast

// MARK: - WeatherData
//struct ForecastWeatherData: Decodable {
//    let list: [ForecastAPIWeather]
//}

// MARK: - List
struct ForecastAPIResponse: Decodable {
    let dt: Int
    let Forecastmain: ForecastAPIMain
    let ForecastWeather: [ForecastAPIWeather]
    let dt_txt: String? //날짜
}

// MARK: - MainClass
struct ForecastAPIMain: Decodable {
    let temp: Double
    let temp_min, temp_max: Double?
}


// MARK: - Weather
struct ForecastAPIWeather: Decodable {
    let description: String
    let iconName: String
    
    enum CodingKeys: String, CodingKey{
        case description
        case iconName = "main"
    }
}
