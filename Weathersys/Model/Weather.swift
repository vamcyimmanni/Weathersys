//
//  Weather.swift
//  Weathersys
//
//  Created by Vamsi on 8/21/24.
//

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
    let wind: Wind
    let clouds: Clouds
}

struct Main: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}

struct Wind: Codable {
    let speed: Double
}

struct Clouds: Codable {
    let all: Int
}
