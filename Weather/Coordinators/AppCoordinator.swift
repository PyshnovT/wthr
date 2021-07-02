//
//  AppCoordinator.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit
import CoreLocation

class AppCoordinator: Coordinator {
    
    enum Page {
        case list
        case city(City)
        case main
    }
    
    let window: UIWindow
    
    private(set) var appDependency: AppDependency
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window
        
        self.appDependency = AppDependency(
            citiesService: CitiesService(geocodeApi: Geocoder()),
            weatherService: WeatherService(api: WeatherDownloader()),
            cityService: CityService(locationService: LocationService(locationManager: CLLocationManager()))
        )
        
        super.init()
    }
    
    // MARK: - Coordinator
    
    override func start() {
        show(page: .main)
        
        window.makeKeyAndVisible()
    }
    
    // MARK: - Navigation
    
    private var page: Page?
    
    func show(page: Page) {
        switch page {
        case .list:
            showList()
            
        case .city(let city):
            showCity(city)

        case .main:
            showMain()
            
        }
        
        self.page = page
    }

    private func showMain() {
        let cityViewController = MainViewController(cityService: appDependency.cityService)
        window.rootViewController = cityViewController
    }
    
    private func showList() {
        let citiesViewController = CitiesViewController(citiesService: appDependency.citiesService, weatherService: appDependency.weatherService)
        
        citiesViewController.onTap = { [unowned self] city in
            self.showCity(city)
        }
        
        window.rootViewController = citiesViewController
    }
    
    private func showCity(_ city: City) {
        let cityViewController = CityViewController(
            city: city,
            citiesService: appDependency.citiesService,
            weatherService: appDependency.weatherService
        )
        
        window.rootViewController?.show(cityViewController, sender: nil)
    }
    
}
