//
//  InitWeatherService.swift
//  WeatherIsNice
//
//  Created by wonyoul heo on 5/3/24.
//

import Foundation
import CoreLocation

public final class InitWeatherService: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    @Published var currentCity: String = ""
    
    private let locationManager = CLLocationManager()
    private var completionHandler: (() -> Void)?
    
    var currentLat: Double = 0
    var currentLon: Double = 0
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    public func loadLocation(completion: @escaping () -> Void) {
        self.completionHandler = completion
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLat = location.coordinate.latitude
        currentLon = location.coordinate.longitude
        
        // 위치가 업데이트되면 도시 이름을 가져오는 함수 호출
        getCityNameFromCoordinates(latitude: currentLat, longitude: currentLon)
        
        // completion handler 호출
        completionHandler?()
    }
    
    private func getCityNameFromCoordinates(latitude: Double, longitude: Double) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Reverse geocoding failed with error: \(error.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?.first else {
                print("No placemarks found.")
                return
            }
            
            if let city = placemark.locality {
                self.currentCity = city
                print(city)
            } else {
                print("City not found.")
            }
        }
    }
}

