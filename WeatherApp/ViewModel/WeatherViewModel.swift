//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Mounika Sakinapally on 05/11/24.
//

import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: WeatherData?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var forecast:[DailyForecast] = []
    private let apiKey = "376077bdff96081f11bc77484bfeb246"

    func fetchWeather(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(encodedCity)&appid=\(apiKey)&units=metric") else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received."
                    return
                }
                // Print raw JSON data as a String
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                
                // Parse JSON data
                do {
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherData.self, from: data)
                    self?.currentWeather = weatherResponse
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print("Decoding Error: \(error)")
                }
            }
        }.resume()
    }
    func fetchWeatherForecast(for city: String) {
        guard let encodedCity = city.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(encodedCity)&appid=\(apiKey)&units=metric") else {
            self.errorMessage = "Invalid URL."
            return
        }
        
        self.isLoading = true
        self.errorMessage = nil
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            DispatchQueue.main.async {
                self?.isLoading = false
                
                if let error = error {
                    self?.errorMessage = error.localizedDescription
                    return
                }
                
                guard let data = data else {
                    self?.errorMessage = "No data received."
                    return
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response Forecast: \(jsonString)")
                }
                // Parse JSON data
                do {
                    let decoder = JSONDecoder()
                    let forecastResponse = try decoder.decode(ForecastData.self, from: data)
                    self?.forecast = self?.processForecastData(forecastResponse) ?? []
                } catch {
                    self?.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print("Decoding Error: \(error)")
                }
            }
        }.resume()
    }
    func processForecastData(_ data: ForecastData) -> [DailyForecast] {
        var dailyForecasts: [DailyForecast] = []
        var dailyData: [String: [ForecastData.ForecastItem]] = [:]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for item in data.list {
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let dateString = dateFormatter.string(from: date)
            
            if dailyData[dateString] == nil {
                dailyData[dateString] = []
            }
            dailyData[dateString]?.append(item)
        }
        
        for (date, items) in dailyData.prefix(3) {
            let minTemp = items.map { $0.main.temp_min }.min() ?? 0.0
            let maxTemp = items.map { $0.main.temp_max }.max() ?? 0.0
            let condition = items.first?.weather.first?.description.capitalized ?? "N/A"

            let main = items.first?.weather.first?.main ?? "N/A"
            let description = items.first?.weather.first?.description ?? "N/A"
            let icon = items.first?.weather.first?.icon ?? ""
            let weatherCondition = WeatherCondition(main: main, description: description, icon: icon)

            dailyForecasts.append(DailyForecast(
                date: date,
                minTemp: minTemp,
                maxTemp: maxTemp,
                condition: condition,
                weather: weatherCondition
            ))
        }
        return dailyForecasts
    }
}

//current weather
extension WeatherViewModel{
    func currentWeather(for location:CLLocation){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&units=metric&appid=\(apiKey)"
        guard let url = URL(string: urlString) else {
            self.errorMessage = "Invalid URL."
            return
        }
        print(url)
        self.isLoading = true
        self.errorMessage = nil

        URLSession.shared.dataTask(with: url) { data, responce, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = error.localizedDescription
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received."
                    return
                }
                
                // Print raw JSON data as a String
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("JSON Response: \(jsonString)")
                }
                do {
                    let decoder = JSONDecoder()
                    let weatherResponce = try decoder.decode(WeatherData.self, from: data)
                    self.currentWeather = weatherResponce
                }catch{
                    self.errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    print("Decoding Error: \(error)")
                }
                
            }
        }.resume()
    }
}
