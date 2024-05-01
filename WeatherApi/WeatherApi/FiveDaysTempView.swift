//
//  FiveDaysTemp.swift
//  WeatherApi
//
//  Created by wonyoul heo on 4/30/24.
//

import SwiftUI

struct WeatherData {
    enum WeatherImoge {
        case sunny
        case cloudy
        case rainy
        case snowy
    }
    
    
    var day: String
    var weatherImoge: WeatherImoge
    var lowTemp: Int
    var highTemp: Int
    
}

extension WeatherData {
    static let mon = WeatherData(day: "월", weatherImoge: .cloudy, lowTemp: 13, highTemp: 22)
    static let tue = WeatherData(day: "화", weatherImoge: .snowy, lowTemp: 12, highTemp: 23)
    static let wed = WeatherData(day: "수", weatherImoge: .sunny, lowTemp: 10, highTemp: 25)
    static let thu = WeatherData(day: "목", weatherImoge: .rainy, lowTemp: 14, highTemp: 28)
    static let fri = WeatherData(day: "금", weatherImoge: .cloudy, lowTemp: 12, highTemp: 24)
    
    static var sampleData = [mon,tue,wed,thu,fri]
}

extension WeatherData.WeatherImoge {
    var systemName: String {
        switch self {
        case .sunny:
            return "sun.max.fill"
        case .cloudy:
            return "cloud.fill"
        case .rainy:
            return "cloud.rain.fill"
        case .snowy:
            return "snow"
        }
    }
}



struct FiveDaysTempView: View {
    var sampleDatas = WeatherData.sampleData
    
    var body: some View {
        VStack{
            List(sampleDatas, id: \.day) { sampleData in
                HStack{
                    Text(sampleData.day)
                    Image(systemName: sampleData.weatherImoge.systemName)
                        .padding(.horizontal, 15)
                        .frame(width: 30, height: 30)
                    HStack{
                        Text("\(sampleData.lowTemp)°C")
                        ZStack{
                            Rectangle()
                                .frame(width:130, height: 5)
                                .foregroundStyle(.gray)
                                .padding(.horizontal, 10)
                            Rectangle()
                                .frame(width:60, height: 5)
                                .foregroundStyle(.green)
                                .padding(.horizontal, 10)
                        }
                        Text("\(sampleData.highTemp)°C")
                    }
                }
            }
        }
    }
}

#Preview {
    FiveDaysTempView()
}
