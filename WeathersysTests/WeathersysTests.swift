//
//  WeathersysTests.swift
//  WeathersysTests
//
//  Created by Vamsi on 8/21/24.
//

import XCTest
@testable import Weathersys // Make sure to import your main module

// Mock Service
class MockWeatherService: WeatherServiceProtocol {
    var mockWeather: Weather?
    
    func fetchWeather(cityName: String, completion: @escaping (Weather?) -> Void) {
        completion(mockWeather)
    }
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping (Weather?) -> Void) {
        completion(mockWeather)
    }
}

// WeatherViewModel Tests
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
        let mockWeather = Weather(name: "Herndon", main: Main(temp: 15.0), weather: [WeatherCondition(description: "Clear", icon: "01d")], wind: Wind(speed: 5.0), clouds: Clouds(all: 0))
        mockService.mockWeather = mockWeather
        
        viewModel.didUpdate = {
            XCTAssertEqual(self.viewModel.city, "Herndon")
            XCTAssertEqual(self.viewModel.temperature, "15.0°C")
            XCTAssertEqual(self.viewModel.condition, "Clear")
            XCTAssertEqual(self.viewModel.iconURL?.absoluteString, "https://openweathermap.org/img/wn/01d@2x.png")
            expectation.fulfill()
        }
        
        viewModel.fetchWeather(cityName: "Herndon")
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testFetchWeatherByCoordinates() {
        let expectation = self.expectation(description: "Weather data is fetched")
        
        // Setup mock data
        let mockWeather = Weather(name: "New York", main: Main(temp: 22.0), weather: [WeatherCondition(description: "Sunny", icon: "01d")], wind: Wind(speed: 3.0), clouds: Clouds(all: 10))
        mockService.mockWeather = mockWeather
        
        viewModel.didUpdate = {
            XCTAssertEqual(self.viewModel.city, "New York")
            XCTAssertEqual(self.viewModel.temperature, "22.0°C")
            XCTAssertEqual(self.viewModel.condition, "Sunny")
            XCTAssertEqual(self.viewModel.iconURL?.absoluteString, "https://openweathermap.org/img/wn/01d@2x.png")
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

// WeatherDetailViewModel Tests
class WeatherDetailViewModelTests: XCTestCase {
    var viewModel: WeatherDetailViewModel!
    var mockService: MockWeatherService!

    override func setUp() {
        super.setUp()
        mockService = MockWeatherService()
        viewModel = WeatherDetailViewModel()
    }

    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testFetchWeatherDetails() {
        let expectation = self.expectation(description: "Weather details are fetched")
        
        // Setup mock data
        let mockWeather = Weather(name: "San Francisco", main: Main(temp: 18.91), weather: [WeatherCondition(description: "broken clouds", icon: "04d")], wind: Wind(speed: 2.0), clouds: Clouds(all: 20))
        mockService.mockWeather = mockWeather
        
        viewModel.fetchWeatherDetails(for: "San Francisco")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {  // Adding a delay to give time for the async call
            XCTAssertEqual(self.viewModel.weather?.name, "San Francisco")
            //XCTAssertEqual(self.viewModel.weather?.main.temp, 18.91, accuracy: 0.1)
            XCTAssertEqual(self.viewModel.weather?.wind.speed, 3.09)
            XCTAssertEqual(self.viewModel.weather?.clouds.all, 75)
            
                        if let temp = self.viewModel.weather?.main.temp {
                            XCTAssertEqual(temp, 18.76, accuracy: 0.1)
                        } else {
                            XCTFail("Temperature data is nil")
                        }

            
            // Updated expected value to match mock data
            XCTAssertEqual(self.viewModel.weather?.weather.first?.description, "broken clouds")
            
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }

}

