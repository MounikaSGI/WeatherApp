//
//  ContentView.swift
//  WeatherApp
//
//  Created by Mounika Sakinapally on 05/11/24.
//

import SwiftUI
/*
struct ContentView: View {
    
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter City Name", text: $city, onCommit: {
                    viewModel.fetchWeather(for: city)
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if let currentWeather = viewModel.currentWeather {
                    Text("Current Weather in \(city)")
                        .font(.headline)
                    Text("\(currentWeather.temperature ?? 0.0, specifier: "%.1f")°C, \(currentWeather.condition ?? "")")
                    
                    Divider().padding()
                    
                    Text("3-Day Forecast")
                        .font(.headline)
                    List(viewModel.forecast) { day in
                        VStack(alignment: .leading) {
                            Text(day.date ?? "")
                            Text("\(day.minTemperature ?? 0.0, specifier: "%.1f")°C - \(day.maxTemperature ?? 0.0, specifier: "%.1f")°C, \(day.condition ?? "")")
                        }
                    }
                }
            }
            .navigationTitle("Weather App")
            .padding()
        }
    }
}
*/

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    @State private var city = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter City Name", text: $city, onCommit: {
                    viewModel.fetchWeather(for: city)
                    viewModel.fetchWeatherForecast(for: city)

                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                
                if viewModel.isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else if let currentWeather = viewModel.currentWeather {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Weather in \(currentWeather.name), \(currentWeather.sys.country)")
                            .font(.headline)
                        
                        Text("Temperature: \(currentWeather.main.temp, specifier: "%.1f")°C")
                        Text("Feels Like: \(currentWeather.main.feels_like, specifier: "%.1f")°C")
                        Text("Condition: \(currentWeather.weather.first?.description.capitalized ?? "N/A")")
                        Text("Humidity: \(currentWeather.main.humidity)%")
                        Text("Wind Speed: \(currentWeather.wind.speed) m/s")
                    }
                    .padding()
                }
                // 3-Day Forecast
                if !viewModel.forecast.isEmpty {
                    Text("3-Day Forecast")
                        .font(.title2)
                        .padding(.top)
                    
                    List(viewModel.forecast) { day in
                        VStack(alignment: .leading) {
                            Text(day.date)
                                .font(.headline)
                            Text("Min: \(day.minTemp, specifier: "%.1f")°C, Max: \(day.maxTemp, specifier: "%.1f")°C")
                            Text("Condition: \(day.condition)")
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Weather App")
            .padding()
        }
    }
}

//#Preview {
//    ContentView()
//}

//struct PracticeContentView :View {
//    @StateObject private var locationManegr = LocationManager()
//    @State private var weatherData:WeatherData?
//    @StateObject private var viewModel = WeatherViewModel()
//    var body: some View {
//        VStack{
//            if let weatherData = weatherData {
//                Text("\(Int(weatherData.current?.temperature ?? 0))°C")
//                    .font(.custom("", size: 70))
//                    .padding()
//                
//                VStack{
//                    Text("\(weatherData.current?.locationName ?? "")")
//                        .font(.title2).bold()
//                    Text("\(weatherData.current?.condition ?? "")")
//                        .font(.body).bold()
//                        .foregroundStyle(.gray)
//                }
//                Spacer()
//                Text("CodeLab")
//                    .bold()
//                    .padding()
//                    .foregroundColor(.gray)
//            }else{
//                ProgressView()
//            }
//        }.frame(width: 300, height: 300)
//            .background(.ultraThinMaterial)
//            .cornerRadius(20)
//            .onAppear{
//                locationManegr.requestLocation()
//            }
//            .onReceive(locationManegr.$location) { location in
//                guard let location = location else {return}
//                viewModel.weatherDataFetch(for: location)
//            }
//        
//    }
//}
