//
//  ForecastViewModel.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 5/2/24.
//

import Foundation
import SwiftUI

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
            hourFormatter.dateFormat = "H시"
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
    
    var weatherIcon: String {
            switch forecast.weather[0].icon {
            case "01d":
                return "sun.max.fill"
            case "01n":
                return "moon.stars.fill"
            case "02d":
                return "cloud.sun.fill"
            case "02n":
                return "cloud.moon.fill"
            case "03d":
                return "cloud"
            case "03n":
                return "cloud.fill"
            case "04d":
                return "smoke"
            case "04n":
                return "smoke.fill"
            case "09d", "09n":
                return "cloud.heavyrain.fill"
            case "10d":
                return "cloud.sun.rain.fill"
            case "10n":
                return "cloud.moon.rain.fill"
            case "11d", "11n":
                return "cloud.bolt.fill"
            case "13d", "13n":
                return "snow.fill"
            case "50d", "50n":
                return "cloud.fog.fill"
            default:
                return "questionmark.square"
            }
        }
        
        var iconColor: (Color, Color?) {
            switch forecast.weather[0].icon {
            case "01d":
                return (.yellow, nil)
            case "02d":
                return (.black, .yellow)
            case "09d", "09n":
                return (.black, .blue)
            case "10d":
                return (.black, .yellow)
            case "11d", "11n":
                return (.black, .yellow)
            default:
                return (.black, nil)
            }
        }

        
        func isWithin24Hours() -> Bool {
            let calendar = Calendar.current
            if let tomorrow = calendar.date(byAdding: .hour, value: 24, to: Date()) {
                return self.forecast.dt < tomorrow
            }
            return false
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
