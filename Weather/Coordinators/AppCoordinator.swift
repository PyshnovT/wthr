//
//  AppCoordinator.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit
import CoreLocation

class AppCoordinator: Coordinator {

    let window: UIWindow
    
    private(set) var appDependency: AppDependency

    let tabBarController = TabBarController()

    lazy var forecastViewController = {
        ForecastViewController(cityService: appDependency.cityService)
    }()

    lazy var mainViewController = {
        MainViewController(
            cityService: appDependency.cityService,
            locationService: appDependency.locationService
        )
    }()

    lazy var citiesViewController: CitiesViewController = {
        let citiesViewController = CitiesViewController(
            citiesService: appDependency.citiesService,
            weatherService: appDependency.weatherService
        )

        citiesViewController.onTap = { [unowned self] city in
            self.appDependency.cityService.setCustomCity(city)
            self.tabBarController.selectedIndex = 0
        }

        return citiesViewController
    }()
    
    // MARK: - Init
    
    init(window: UIWindow) {
        self.window = window

        let geocoder = Geocoder()
        let locationService = LocationService(locationManager: CLLocationManager())
        let forecastService = ForecastService(api: ForecastDownloader())

        self.appDependency = AppDependency(
            citiesService: CitiesService(geocodeApi: geocoder),
            weatherService: forecastService,
            cityService: CityService(
                locationService: locationService,
                geocoderService: GeocoderService(geocodeApi: geocoder),
                forecastService: forecastService,
                offlineManager: OfflineManager()
            ),
            locationService: locationService
        )
        
        super.init()
    }
    
    // MARK: - Coordinator
    
    override func start() {
        showTabBarController()
        
        window.makeKeyAndVisible()
    }
    
    // MARK: - Navigation

    private func showTabBarController() {
        mainViewController.tabBarItem.image = AppConstants.Images.TabBar.main
        forecastViewController.tabBarItem.image = AppConstants.Images.TabBar.forecast

        tabBarController.setViewControllers(
            [
                mainViewController,
                citiesViewController,
                forecastViewController
            ],
            animated: false
        )

        window.rootViewController = tabBarController
    }

}
