//
//  ForecastViewModel.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 5/2/24.
//

import Foundation

struct ForecastViewModel {
    let forecast: Forecast.List
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, MMM, d, HH"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0 // 최대 소수자리
        return numberFormatter
    }
    
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var overview: String {
        forecast.weather[0].description.capitalized
    }
    
    var high: String {
        return "H: \(Self.numberFormatter.string(for: forecast.main.temp_max) ?? "0")ºC"
    }
    
    var low: String {
        return "L: \(Self.numberFormatter.string(for: forecast.main.temp_min) ?? "0")ºC"
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
}


struct CurrentViewModel {
    let current: Current
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM, d, HH:mm"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0 // 최대 소수자리
        return numberFormatter
    }
    var temp: String {
        return "현재온도: \(Self.numberFormatter.string(for: current.main.temp) ?? "0")ºC"
    }
    
    var day: String {
        return Self.dateFormatter.string(from: current.dt)
    }
    
    var main: String{
        current.weather[0].main
    }
    
    var overview: String {
        current.weather[0].description.capitalized
    }
    
    var high: String {
        return "최고: \(Self.numberFormatter.string(for: current.main.temp_max) ?? "0")ºC"
    }
    
    var low: String {
        return "최저: \(Self.numberFormatter.string(for: current.main.temp_min) ?? "0")ºC"
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(current.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
}