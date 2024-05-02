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
                List(forecastListVM.forecasts, id: \.day) { day in
                        VStack(alignment: .leading) {
                            Text(day.day)
                                .fontWeight(.bold)
                            HStack(alignment: .top){
                                WebImage(url: day.weatherIconURL)
                                VStack(alignment: .leading){
                                    Text(day.overview)
                                    HStack{
                                        Text(day.high)
                                        Text(day.low)
                                    }
                                }
                            }
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
