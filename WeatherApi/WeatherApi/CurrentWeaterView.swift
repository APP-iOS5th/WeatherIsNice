//
//  CurrentWeaterView.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import SwiftUI

struct CurrentWeaterView: View {
    
    @ObservedObject var viewModel: WeatherViewModel
    
    var body: some View {
        VStack{
            Text(viewModel.cityName)
                .font(.largeTitle)
                .padding()
            Text(viewModel.temperature)
                .font(.system(size: 70))
                .bold()
            Text(viewModel.weatherIcon)
                .font(.largeTitle)
                .padding()
            Text(viewModel.weatherDescription)
        }.onAppear(perform: viewModel.refresh)
    }
}

#Preview {
    CurrentWeaterView(viewModel: WeatherViewModel(weatherService: WeatherService()))
}
