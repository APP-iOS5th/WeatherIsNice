//
//  ForecastViewModel.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 5/2/24.
//

import Foundation
import CoreLocation

class ForecastListViewModel: ObservableObject {
    
    @Published var forecasts: [ForecastViewModel] = []
    
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
                        DispatchQueue.main.async {
                            self.forecasts = forecast.list.map {ForecastViewModel(forecast: $0)}
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
