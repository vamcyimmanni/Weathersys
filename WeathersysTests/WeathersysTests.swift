//
//  WeathersysTests.swift
//  WeathersysTests
//
//  Created by Vamsi on 8/21/24.
//

import XCTest
@testable import Weathersys // Make sure to import your main module

class MockWeatherService: WeatherServiceProtocol {
    var mockWeather: Weather?
    
    func fetchWeather(cityName: String, completion: @escaping (Weather?) -> Void) {
        completion(mockWeather)
    }
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Weather?) -> Void) {
        completion(mockWeather)
    }
}

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var mockService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherViewModel(weatherService: mockService)
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }

    func testFetchWeatherByCityName() {
        let expectation = self.expectation(description: "Weather data is fetched")
        
        // Setup mock data
        let mockWeather = Weather(name: "Herndon", main: Main(temp: 15.0), weather: [WeatherCondition(description: "Clear", icon: "01d")])
        mockService.mockWeather = mockWeather
        
        viewModel.didUpdate = {
            XCTAssertEqual(self.viewModel.city, "Herndon")
            XCTAssertEqual(self.viewModel.temperature, "15.0°C")
            XCTAssertEqual(self.viewModel.condition, "Clear")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(cityName: "Herndon")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherByCoordinates() {
        let expectation = self.expectation(description: "Weather data is fetched")
        
        // Setup mock data
        let mockWeather = Weather(name: "New York", main: Main(temp: 22.0), weather: [WeatherCondition(description: "Sunny", icon: "01d")])
        mockService.mockWeather = mockWeather
        
        viewModel.didUpdate = {
            XCTAssertEqual(self.viewModel.city, "New York")
            XCTAssertEqual(self.viewModel.temperature, "22.0°C")
            XCTAssertEqual(self.viewModel.condition, "Sunny")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(latitude: 40.7128, longitude: -74.0060)
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testLoadLastSearchedCity() {
        UserDefaults.standard.set("Paris", forKey: "LastSearchedCity")
        
        let lastCity = viewModel.loadLastSearchedCity()
        XCTAssertEqual(lastCity, "Paris")
    }
}
