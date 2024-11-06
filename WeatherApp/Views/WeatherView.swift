//
//  WeatherView.swift
//  WeatherApp
//
//  Created by Mounika Sakinapally on 05/11/24.
//

import SwiftUI

struct WeatherView:View {
    @StateObject private var viewModel = WeatherViewModel()
    @StateObject private var locationManegr = LocationManager()
    @State private var city = ""

    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [.blue,Color("lightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            VStack{
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
                        .font(.system(size: 20))
                        .foregroundColor(.red)
                        .padding()
                } else if let currentWeather = viewModel.currentWeather{
                    VStack(alignment: .center, spacing: 10){
                        Text("\(currentWeather.name),\(currentWeather.sys.country)")
                            .font(.system(size: 24,weight: .medium, design: .default))
                            .foregroundColor(.white)
                        Image(currentWeather.weather.first?.iconImageName() ?? "default_icon")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 80, height: 80)
                        Text("\(currentWeather.main.temp, specifier: "%.1f")°C")
                            .font(.system(size: 30,weight: .medium))
                            .foregroundColor(.white)
                        Text("Feels Like: \(currentWeather.main.feels_like, specifier: "%.1f")°C")
                            .font(.system(size: 15,weight: .medium))
                            .foregroundColor(.white)
                        Text("Condition: \(currentWeather.weather.first?.description.capitalized ?? "N/A")")
                            .font(.system(size: 15,weight: .medium))
                            .foregroundColor(.white)

                        Text("Humidity: \(currentWeather.main.humidity)%")
                            .font(.system(size: 15,weight: .medium))
                            .foregroundColor(.white)
                        Text("Wind Speed: \(currentWeather.wind.speed) m/s")
                            .font(.system(size: 15,weight: .medium))
                            .foregroundColor(.white)

                    }.padding(.bottom,20)
                    if !viewModel.forecast.isEmpty {
                        Text("3-Day Forecast")
                            .font(.title2)
                            .padding(.top)
                            .foregroundColor(.white)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(viewModel.forecast) { day in
                                    WeatherForecastDayView(forecast: day)
                                        .frame(width: 120)
                                }
                            }
                            .padding()
                        }
                    }
                    Spacer()
                }
            }
        }.onAppear{
            locationManegr.requestLocation()
        }
        .onReceive(locationManegr.$location) { location in
            guard let location = location else {return}
            viewModel.currentWeather(for: location)
        }
    }
}
struct WeatherForecastDayView:View {

    var forecast:DailyForecast

    var body: some View {
        VStack{
            Text(forecast.date)
                .font(.system(size: 14,weight: .bold,design: .default))
                .foregroundColor(.white)
            Image(forecast.weather?.iconImageName() ?? "default_icon")
                .renderingMode(.original)
                .resizable()
                .frame(width: 30, height: 30)
            Text("\(Int(forecast.maxTemp))°/\(Int(forecast.minTemp))°")
                .font(.system(size: 10,weight: .bold))
                .foregroundColor(.white)
            Text("\(forecast.condition)")
                .font(.system(size: 10,weight: .bold))
                .foregroundColor(.white)
        }
        .padding(EdgeInsets(top: 20, leading: 10, bottom: 20, trailing: 10))
        .background(.ultraThinMaterial)
        .cornerRadius(5)
    }
}
