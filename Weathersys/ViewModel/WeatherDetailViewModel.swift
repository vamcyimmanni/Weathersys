//
//  WeatherDetailViewModel.swift
//  Weathersys
//
//  Created by Vamsi on 8/24/24.
//

import Foundation

class WeatherDetailViewModel: ObservableObject {
    @Published var weather: Weather?
    
    func fetchWeatherDetails(for city: String) {
        let weatherService = WeatherService()
        weatherService.fetchWeather(cityName: city) { [weak self] weather in
            DispatchQueue.main.async {
                self?.weather = weather
            }
        }
    }
}

