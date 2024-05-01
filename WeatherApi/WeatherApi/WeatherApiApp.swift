//
//  WeatherApiApp.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import SwiftUI

@main
struct WeatherApiApp: App {
    var body: some Scene {
        WindowGroup {
            let weatherService = WeatherService()
            let viewModel = WeatherViewModel(weatherService: weatherService)
            CurrentWeaterView(viewModel: viewModel)
        }
    }
}
