//
//  ForecastViewModel.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 5/2/24.
//

import Foundation
import CoreLocation

struct TemperatureInfo {
    let date: String
    let minTemp: Double
    let maxTemp: Double
}


class ForecastListViewModel: ObservableObject {
    
    @Published var forecasts: [ForecastViewModel] = []
    @Published var temperatureInfoPerDay: [TemperatureInfo] = []
    
    var location: String = ""
    
    func getWeatherForecast() {
        let apiService = APIService.shared
        
        CLGeocoder().geocodeAddressString(location) {(placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/forecast?lat=\(lat)&lon=\(lon)&appid=ce878d5130eaace7c56141ff9190f16f&units=metric", dateDecodingStrategy: .secondsSince1970) {
                    (result: Result<Forecast,APIService.APIError>) in
                    switch result {
                    case .success(let forecast):
                        DispatchQueue.main.async { [self] in
                            self.forecasts = forecast.list.map {ForecastViewModel(forecast: $0)}
                            self.temperatureInfoPerDay = self.calculateTemperatureInfoPerDay(from: forecasts)
                        }// @State
                    case .failure(let apiError):
                        switch apiError {
                        case .error(let errorString):
                            print(errorString)
                        }
                    }
                    
                }
                
            }
        }
    }
    //    private func calculateMinTemperatures() {
    //        self.minTemperaturesPerDay = [:] // 초기화
    //        for forecast in forecasts {
    //            let date = String(forecast.shortday) // MM.dd
    //            let minTemp = forecast.forecast.main.temp_min
    //            if let existingMin = minTemperaturesPerDay[date] {
    //                minTemperaturesPerDay[date] = min(existingMin, minTemp)
    //            } else {
    //                minTemperaturesPerDay[date] = minTemp
    //            }
    //        }
    //    }
    //
    //    private func calculateMaxTemperatures() {
    //        self.maxTemperaturesPerDay = [:] // 초기화
    //        for forecast in forecasts {
    //            let date = String(forecast.shortday) // MM.dd
    //            let maxTemp = forecast.forecast.main.temp_max
    //            if let existingMax = maxTemperaturesPerDay[date] {
    //                minTemperaturesPerDay[date] = min(existingMax, maxTemp)
    //            } else {
    //                minTemperaturesPerDay[date] = maxTemp
    //            }
    //        }
    //    }
    
    private func calculateTemperatureInfoPerDay(from forecasts: [ForecastViewModel]) -> [TemperatureInfo] {
        var temperatureInfoPerDay: [TemperatureInfo] = []
        var tempInfoDict: [String: TemperatureInfo] = [:]
        
        for forecast in forecasts {
            let date = String(forecast.shortday)
            if let existingTempInfo = tempInfoDict[date] {
                let minTemp = min(existingTempInfo.minTemp, forecast.forecast.main.temp_min)
                let maxTemp = max(existingTempInfo.maxTemp, forecast.forecast.main.temp_max)
                let updatedTempInfo = TemperatureInfo(date: date, minTemp: minTemp, maxTemp: maxTemp)
                tempInfoDict[date] = updatedTempInfo
            } else {
                let tempInfo = TemperatureInfo(date: date, minTemp: forecast.forecast.main.temp_min, maxTemp: forecast.forecast.main.temp_max)
                tempInfoDict[date] = tempInfo
            }
        }
        
        // Convert dictionary to array
        temperatureInfoPerDay = Array(tempInfoDict.values)
        
        // Sort by date if needed
        temperatureInfoPerDay.sort { $0.date < $1.date }
        
        return temperatureInfoPerDay
    }
}
    


class CurrentListViewModel: ObservableObject{
    @Published var current: CurrentViewModel?
    init(current: Current? = nil) {
        if let current = current {
            self.current = CurrentViewModel(current: current)
        }
    }
    var location: String = ""
    
    func getWeatherCurrent() {
        let apiService = CurrentAPIService.shared
        CLGeocoder().geocodeAddressString("Seoul") { (placemarks, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let lat = placemarks?.first?.location?.coordinate.latitude,
               let lon = placemarks?.first?.location?.coordinate.longitude {
                apiService.getJSON(urlString: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=ce878d5130eaace7c56141ff9190f16f&units=metric", dateDecodingStrategy: .secondsSince1970) { (result: Result<Current, CurrentAPIService.APIError>) in
                    switch result {
                    case .success(let current):
                        DispatchQueue.main.async{
                            self.current = CurrentViewModel(current: current)
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
    }
}
