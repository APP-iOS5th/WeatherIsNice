//
//  ContentView.swift
//  TestWeatherApp
//
//  Created by wonyoul heo on 4/30/24.
//
import CoreLocation
import SwiftUI


struct ContentView: View {
    @State private var location: String = ""
    @State private var forecast: Forecast? = nil
    @State private var current: Current? = nil
    let dateFormatter = DateFormatter()
    let currentdateFormatter = DateFormatter()
    init() {
        dateFormatter.dateFormat = "MM, d HH"
        currentdateFormatter.dateFormat = "MMM, d, HH:mm"
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    TextField("Enter Location", text: $location)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button {
                        getWeatherForecast(for: location)
                        getWeatherCurrent(for: location)
                        
                    } label: {
                        Image(systemName: "magnifyingglass.circle.fill")
                            .font(.title3)
                    }
                }
                VStack{
                    if let current = current{
                        Text("Temp: \(current.main.temp)")
                        Text(current.weather[0].main)
                        Text(current.weather[0].description)
                        Text(currentdateFormatter.string(from: current.dt))
                    }
                }
                if let forecast = forecast {
                    List(forecast.list, id: \.dt) { day in
                        VStack(alignment: .leading) {
                            Text(dateFormatter.string(from: day.dt))
                                .fontWeight(.bold)
                            HStack(alignment: .top){
                                Image(systemName: "hourglass")
                                    .font(.title)
                                    .frame(width: 50, height: 50)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.green))
                                VStack(alignment: .leading){
                                    Text("Temp:\(day.main.temp, specifier: "%.1f")")
                                    HStack{
                                        Text("Temp_min: \(day.main.temp_min, specifier: "%.0f")")
                                        Text("Temp_max: \(day.main.temp_max, specifier: "%.0f")")
                                    }
                                }
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                } else {
                    Spacer()
                }
                
            }
            .padding(.horizontal)
            .navigationTitle("Mobile Weather")
        }
    }
    func getWeatherForecast(for location: String) {
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
                        self.forecast = forecast  // @State
//                        for day in forecast.list {
//                            print(dateFormatter.string(from: day.dt))
//                            print("     Temp: ", day.main.temp)
//                            print("     Temp_min: ", day.main.temp_min)
//                            print("     Temp_max: ", day.main.temp_max)
//                            print("     Description: ", day.weather[0].description)
//                            print("     IconURL: ", day.weather[0].weatherIconURL)
//                        }
                        
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
    func getWeatherCurrent(for location: String) {
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
                        self.current = current
//                        print(dateFormatter.string(from: current.dt))
//                        print("     Temp: \(current.main.temp)")
//                        print("     main: \(current.weather[0].main)")
//                        print("     discription: \(current.weather[0].description)")
//                        print("     Icon: \(current.weather[0].weatherIconURL)")
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

#Preview {
    ContentView()
}
