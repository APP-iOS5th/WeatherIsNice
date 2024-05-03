//
//  ContentView.swift
//  WeatherIsNice
//
//  Created by wonyoul heo on 5/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var forecastListVM = ForecastListViewModel()
    @ObservedObject private var currentListVM = CurrentListViewModel()
    @StateObject private var weatherService = InitWeatherService()
        @State private var currentCity: String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    TextField("Enter Location", text: $currentCity)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        forecastListVM.location = currentCity
                        currentListVM.location = currentCity
                        forecastListVM.getWeatherForecast()
                        currentListVM.getWeatherCurrent()
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                .padding()
                VStack{
                    Text("나의 위치")
                        .font(.title)
                    Text(currentListVM.location)
                    
                    Text(currentListVM.current?.temp ?? "")
                        .font(.system(size: 70))

                    Text(currentListVM.current?.overview ?? "")
                    HStack{
                        Text(currentListVM.current?.low ?? "")
                        Text(currentListVM.current?.high ?? "")
                    }
                }
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "clock")
                        Text("시간별 일기예보")
                    }
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            ForEach(forecastListVM.forecasts.filter { $0.isWithin24Hours() }, id: \.day) { day in
                                VStack {
                                    Text("\(String(describing: day.hour))")
                                    
                                    Image(systemName: day.weatherIcon)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 30, height: 30)
                                        .padding(.vertical, 10)
                                        .foregroundStyle(day.iconColor.0, day.iconColor.1 ?? .black)
                                    Text("\(day.temp)°")
                                        .font(.title3)
                                }
                            }
                        }
                    }
                    Divider()
                }
                .padding([.top,.leading,.trailing])
                VStack(alignment: .leading)
                {
                    HStack{
                        Image(systemName: "calendar")
                        Text("5일간의 일기예보")
                    }
                    Divider()
                    ScrollView(.vertical, showsIndicators:  false) {
                        ForEach(forecastListVM.temperatureInfoPerDay, id: \.date) { temperatureInfo in
                            HStack{
                                VStack(alignment: .leading) {
                                    Text(temperatureInfo.date)
                                        .font(.headline)
                                    Text("최저 : \(String(format: "%.0f", temperatureInfo.minTemp))°C")
                                    Text("최고 : \(String(format: "%.0f", temperatureInfo.maxTemp))°C")
                                }
                                Spacer()
                                IconView(iconCode: temperatureInfo.iconCode)
                            }
                            .padding()
                        }
                    }
                }
                .padding([.top,.leading,.trailing])
               
            }
        }
        .onAppear{
            weatherService.loadLocation()
        }
        .onReceive(weatherService.$currentCity) { city in
            forecastListVM.location = city
            currentListVM.location = city
            forecastListVM.getWeatherForecast()
            currentListVM.getWeatherCurrent()
        }
    }
}

#Preview {
    ContentView()
}


/*
 1. 필터링
 값 대략 8~9개 받아오기. -> 서경님 부탁해요.
 
 2. 현재 위치 받아오기
 -> 원열님 부탁해요.
 
 3. 비동기 작업
 -> 조장님께 전체적인 코드 흐름 부탁해요.
 
 4. UI 꾸미기
 
 5. 클라우드 대신 들어갈 방법 생각 해보겠습니다.
 
 6.
 
 */
