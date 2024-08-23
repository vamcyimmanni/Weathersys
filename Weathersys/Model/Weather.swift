//
//  Weather.swift
//  Weathersys
//
//  Created by Vamsi on 8/21/24.
//

import Foundation

struct Weather: Codable {
    let name: String
    let main: Main
    let weather: [WeatherCondition]
}

struct Main: Codable {
    let temp: Double
}

struct WeatherCondition: Codable {
    let description: String
    let icon: String
}
