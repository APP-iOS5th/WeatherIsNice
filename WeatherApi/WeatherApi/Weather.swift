//
//  Weather.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import Foundation

public struct Weather {
    let city: String
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: APIResponse) {
        city = response.name
        temperature = "\(Int(response.main.temp))"
        description = response.weather.first?.description ?? ""
        iconName = response.weather.first?.iconName ?? ""
    }
    
}

public struct ForecastWeather {
    let temperature: String
    let description: String
    let iconName: String
    
    init(response: ForecastAPIResponse) {
        self.temperature = "\(Int(response.Forecastmain.temp))"
        self.description = response.ForecastWeather.first?.description ?? ""
        self.iconName = response.ForecastWeather.first?.iconName ?? ""
    }
}
