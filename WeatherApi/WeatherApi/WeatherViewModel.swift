//
//  WeatherViewModel.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import Foundation

private let defualutIcon = "🐭"
private let iconMap = [
    "Drizzle" : "🌧️",
    "Thunderstorm" : "🌩️",
    "Rain" : "🌧️",
    "Snow" : "❄️",
    "Clear" : "☀️",
    "Clouds" : "☁️"
]

public class WeatherViewModel: ObservableObject {
    @Published var cityName: String = "City Name"
    @Published var temperature: String = "--"
    @Published var weatherDescription: String = "--"
    @Published var weatherIcon: String = defualutIcon
    
    public let weatherService: WeatherService
    
    public init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    public func refresh() {
        weatherService.loadWeatherData { weather in
            DispatchQueue.main.async {
                self.cityName = weather.city
                self.temperature = "\(weather.temperature)ºC"
                self.weatherDescription = weather.description.capitalized
                self.weatherIcon = iconMap[weather.iconName] ?? defualutIcon
            }
        }
    }
}
