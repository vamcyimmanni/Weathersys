//
//  WeatherService.swift
//  Weathersys
//
//  Created by Vamsi on 8/21/24.
//

import Foundation

protocol WeatherServiceProtocol {
    func fetchWeather(cityName: String, completion: @escaping (Weather?) -> Void)
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Weather?) -> Void)
}


class WeatherService:  WeatherServiceProtocol{
    private let apiKey = "f28f276eff731be98458435a1611560c"
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    func fetchWeather(cityName: String, completion: @escaping (Weather?) -> Void) {
        let urlString = "\(baseURL)?q=\(cityName)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            completion(weather)
        }.resume()
    }

    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Weather?) -> Void) {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }

            let weather = try? JSONDecoder().decode(Weather.self, from: data)
            completion(weather)
        }.resume()
    }
}

