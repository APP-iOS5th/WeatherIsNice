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
    
    private static var shortdateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd (E)"
        return dateFormatter
    }
    
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0 // 최대 소수자리
        return numberFormatter
    }
    
    private static var hourFormatter: DateFormatter {
            let hourFormatter = DateFormatter()
            hourFormatter.dateFormat = "HH"
            return hourFormatter
        }
    
    var day: String {
        return Self.dateFormatter.string(from: forecast.dt)
    }
    
    var shortday: String {
        return Self.shortdateFormatter.string(from: forecast.dt)
    }
    
    var hour: String {
            return Self.hourFormatter.string(from: forecast.dt)
        }
    
    var temp: Int {
            return Int(forecast.main.temp.rounded())
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
    
    var lowToInt: Double {
        forecast.main.temp_min
    }
    
    var weatherIconURL: URL {
        let urlString = "https://openweathermap.org/img/wn/\(forecast.weather[0].icon)@2x.png"
        return URL(string: urlString)!
    }
    
    var iconCode: String {
        forecast.weather[0].icon
    }
    
    
    
}


struct CurrentViewModel {
    let current: Current
    
    private static var dateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }
    
    private static var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 0 // 최대 소수자리
        return numberFormatter
    }
    var temp: String {
        return "\(Self.numberFormatter.string(for: current.main.temp) ?? "0")ºC"
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
