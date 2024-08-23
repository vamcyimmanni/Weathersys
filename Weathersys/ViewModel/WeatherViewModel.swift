//
//  WeatherViewModel.swift
//  Weathersys
//
//  Created by Vamsi on 8/21/24.
//

import Foundation

class WeatherViewModel {
    private let weatherService: WeatherServiceProtocol
    private let lastSearchedCityKey = "LastSearchedCity"

    var temperature: String = ""
    var condition: String = ""
    var city: String = ""
    var iconURL: URL?

    var didUpdate: (() -> Void)?

    init(weatherService: WeatherServiceProtocol = WeatherService()) {
        self.weatherService = weatherService
    }

    func fetchWeather(cityName: String) {
        weatherService.fetchWeather(cityName: cityName) { [weak self] weather in
            guard let self = self, let weather = weather else { return }

            self.temperature = "\(weather.main.temp)°C"
            self.condition = weather.weather.first?.description ?? "Unknown"
            self.city = weather.name
            if let iconCode = weather.weather.first?.icon {
                self.iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            }

            // Save the last searched city
            UserDefaults.standard.set(cityName, forKey: self.lastSearchedCityKey)

            DispatchQueue.main.async {
                self.didUpdate?()
            }
        }
    }

    func fetchWeather(latitude: Double, longitude: Double) {
        weatherService.fetchWeather(latitude: latitude, longitude: longitude) { [weak self] weather in
            guard let self = self, let weather = weather else { return }

            self.temperature = "\(weather.main.temp)°C"
            self.condition = weather.weather.first?.description ?? "Unknown"
            self.city = weather.name
            if let iconCode = weather.weather.first?.icon {
                self.iconURL = URL(string: "https://openweathermap.org/img/wn/\(iconCode)@2x.png")
            }

            DispatchQueue.main.async {
                self.didUpdate?()
            }
        }
    }

    // Method to retrieve the last searched city
    func loadLastSearchedCity() -> String? {
        return UserDefaults.standard.string(forKey: lastSearchedCityKey)
    }
}
