//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 4/30/24.
//

import SwiftUI
import SDWebImage
import SDWebImageSwiftUI

struct ContentView: View {
    @StateObject private var forecastListVM = ForecastListViewModel()
    @StateObject private var currentListVM = CurrentListViewModel()
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    TextField("Enter Location", text: $forecastListVM.location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        forecastListVM.getWeatherForecast()
                        currentListVM.getWeatherCurrent()
                        print(forecastListVM.forecasts)
                        
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                VStack{
                    Text(currentListVM.current?.day ?? "")
                    Text(currentListVM.current?.temp ?? "")
                    Text(currentListVM.current?.main ?? "")
                    WebImage(url: currentListVM.current?.weatherIconURL ?? nil)
                    Text(currentListVM.current?.overview ?? "")
                }
                List(forecastListVM.temperatureInfoPerDay, id: \.date) { temperatureInfo in
                    VStack(alignment: .leading) {
                        Text(temperatureInfo.date)
                            .font(.headline)
                        Text("Min Temp: \(String(format: "%.0f", temperatureInfo.minTemp))°C")
                        Text("Max Temp: \(String(format: "%.0f", temperatureInfo.maxTemp))°C")
                    }
                }
                
                .listStyle(PlainListStyle())
                
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    
}

#Preview {
    ContentView()
}
