//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Mounika Sakinapally on 05/11/24.
//

import Foundation
import CoreLocation
import Combine

//struct WeatherData: Codable {
//    let current: CurrentWeather?
//    let forecast: [ForecastWeather]?
//    
//    struct CurrentWeather: Codable {
//        let temperature: Double?
//        let condition: String?
//        let locationName:String?
//    }
//
//    struct ForecastWeather: Codable,Identifiable{
//        var id = UUID()
//        let date: String?
//        let minTemperature: Double?
//        let maxTemperature: Double?
//        let condition: String?
//    }
//}

struct WeatherResponce:Codable{
    let name:String
    let main:MainWeather
    let weather:[Weather]
}
struct MainWeather:Codable{
    let temp:Double
}
struct Weather:Codable{
    let description:String
}

class LocationManager:NSObject,ObservableObject,CLLocationManagerDelegate{
    private let locationManager = CLLocationManager()
    @Published var location : CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        self.location = location
        locationManager.stopUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print(error.localizedDescription)
    }
}
struct WeatherData: Codable {
    let name: String // City name
    let main: MainWeather
    let weather: [WeatherCondition]
    let wind: Wind
    let sys: Sys
    let timezone: Int
    
    struct MainWeather: Codable {
        let temp: Double
        let feels_like: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }

    struct Wind: Codable {
        let speed: Double
        let deg: Int
    }

    struct Sys: Codable {
        let country: String
        let sunrise: Int
        let sunset: Int
    }
}
struct WeatherCondition: Codable {
    let main: String
    let description: String
    let icon: String
}
struct ForecastData: Codable {
    let list: [ForecastItem]
    
    struct ForecastItem: Codable {
        let dt: Int
        let main: MainWeather
        let weather: [WeatherCondition]
        
        struct MainWeather: Codable {
            let temp_min: Double
            let temp_max: Double
        }
        
    }
}
struct DailyForecast:Codable, Identifiable {
    let id = UUID()
    let date: String
    let minTemp: Double
    let maxTemp: Double
    let condition: String
    let weather: WeatherCondition?
}
