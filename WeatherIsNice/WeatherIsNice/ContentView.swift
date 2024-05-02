//
//  ContentView.swift
//  WeatherIsNice
//
//  Created by wonyoul heo on 5/2/24.
//

import SwiftUI

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
                .padding(.vertical, 10)
                VStack{
                    Text("나의 위치")
                        .font(.title)
                    Text(currentListVM.location)
                    Text(currentListVM.current?.temp ?? "")
                        .font(.system(size: 70))
                    VStack{
//                        AsyncImage(url: currentListVM.current?.weatherIconURL) {image in
//                            image.resizable()
//                                .frame(width: 100, height: 100)
//                        } placeholder: {
//                            ProgressView()
//                        }
                        Text(currentListVM.current?.main ?? "")
                    }
                    HStack{
                        Text(currentListVM.current?.low ?? "")
                        Text(currentListVM.current?.high ?? "")
                    }
                }
                VStack{
                    Text("Three-Hour Forecast")
                        .padding(.top)
                        .fontWeight(.bold)
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(forecastListVM.forecasts, id: \.) { day in
                                VStack {
                                    Text("\(String(describing: day.hour))")
                                    AsyncImage(url: day.weatherIconURL) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 30, height: 30)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    Text("\(day.temp)°")
                                        .font(.title3)
                                }
                            }
                            
                        }
                    }
                }
                .padding()
               Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
}
