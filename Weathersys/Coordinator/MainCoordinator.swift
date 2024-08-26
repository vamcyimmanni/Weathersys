//
//  MainCoordinator.swift
//  Weathersys
//
//  Created by Vamsi on 8/23/24.
//

import UIKit
import SwiftUI

class MainCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        viewController.coordinator = self
        navigationController.pushViewController(viewController, animated: false)
    }
    
    func showWeatherDetail(for city: String) {
        let weatherDetailView = WeatherDetailView(city: city)
        let weatherDetailViewController = UIHostingController(rootView: weatherDetailView)
        navigationController.pushViewController(weatherDetailViewController, animated: true)

    }

}

