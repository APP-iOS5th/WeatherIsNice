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
                VStack(alignment: .leading){
                    HStack{
                        Image(systemName: "clock")
                        Text("시간별 일기예보")
                    }
                    Divider()
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(forecastListVM.forecasts, id: \.day) { day in
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
                                Text(temperatureInfo.iconCode)
                            }
                            .padding()
                        }
                    }
                }
                .padding([.top,.leading,.trailing])
               
            }
        }
        .onAppear(perform: {
//            currentListVM.location =
//            
//            currentListVM.getWeatherCurrent()
//            forecastListVM.getWeatherForecast()
        })
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
