//
//  Extensions.swift
//  WeatherApp
//
//  Created by Mounika Sakinapally on 05/11/24.
//

import SwiftUI
extension WeatherCondition {
    func iconImageName() -> String {
        switch icon {
        case "01d", "01n": return "sunny"
        case "02d", "02n": return "partly_cloudy"
        case "03d", "03n": return "cloudy"
        case "04d", "04n": return "overcast"
        case "09d", "09n": return "rainy"
        case "10d", "10n": return "light_rain"
        case "11d", "11n": return "thunderstorm"
        case "13d", "13n": return "snow"
        case "50d", "50n": return "mist"
        default: return "default_icon" // fallback icon
        }
    }
}
