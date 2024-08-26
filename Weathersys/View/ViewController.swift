//
//  ViewController.swift
//  Weathersys
//
//  Created by Vamsi on 8/21/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate {
    private let weatherViewModel = WeatherViewModel()
    private let locationManager = CLLocationManager()
    
    weak var coordinator: MainCoordinator?
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
        setupLocationManager()
        loadLastSearchedCity()
    }
    
    private func setupViews() {
        searchBar.delegate = self
        self.temperatureLabel.textColor = .black
        self.cityLabel.textColor = .black
        self.conditionLabel.textColor = .black
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
    }

    private func setupBindings() {
        weatherViewModel.didUpdate = { [weak self] in
            guard let self = self else { return }

            self.cityLabel.text = "City: \(self.weatherViewModel.city)"
            self.temperatureLabel.text = "Temperature: \(self.weatherViewModel.temperature)"
            self.conditionLabel.text = "Condition: \(self.weatherViewModel.condition)"
            
            if let iconURL = self.weatherViewModel.iconURL {
                self.loadImage(from: iconURL)
            }
        }
    }
    
    func loadImage(from url: URL) {
        let cacheKey = url.absoluteString
        if let cachedImage = ImageCache.shared.image(forKey: cacheKey) {
            self.weatherIconImageView.image = cachedImage
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil, let image = UIImage(data: data) else {
                return
            }

            ImageCache.shared.setImage(image, forKey: cacheKey)
            
            DispatchQueue.main.async {
                self.weatherIconImageView?.image = image
            }
        }.resume()
    }


    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    private func loadLastSearchedCity() {
        if let lastCity = weatherViewModel.loadLastSearchedCity() {
            weatherViewModel.fetchWeather(cityName: lastCity)
        }
    }

    // CLLocationManagerDelegate Methods

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied or restricted")
        case .notDetermined:
            break
        default:
            break
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude

            weatherViewModel.fetchWeather(latitude: latitude, longitude: longitude)
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
    }

    // UISearchBarDelegate Method

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let cityName = searchBar.text, !cityName.isEmpty else {
            return
        }

        weatherViewModel.fetchWeather(cityName: cityName)
        searchBar.resignFirstResponder()
    }
    
    @IBAction func didTapWeatherDetails(_ sender: Any) {
    
        if !weatherViewModel.city.isEmpty {
            coordinator?.showWeatherDetail(for: weatherViewModel.city)
        } else {
            // Optionally, handle the case where the city is empty
            print("City name is empty")
        }
    }
}
