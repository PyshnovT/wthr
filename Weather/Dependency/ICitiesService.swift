//
//  ICitiesService.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

protocol ICitiesService {
    
    var cities: [City] { get }
    
    var searchedCities: [City] { get }
    
    func searchCities(named name: String, then handler: @escaping CitiesHandler)
    
    func add(_ city: City)
    
}

class CitiesService: ICitiesService {
    
    let geocodeApi: GeocodeApi
    
    // MARK: - Searching
    
    init(geocodeApi: GeocodeApi) {
        self.geocodeApi = geocodeApi
    }
    
    // MARK: - Cities
    
    private(set) var cities: [City] = [
        AppConstants.Cities.paris,
        AppConstants.Cities.losAngeles,
        AppConstants.Cities.moscow,
        AppConstants.Cities.newYork,
        AppConstants.Cities.saintPetersburg,
        AppConstants.Cities.helsinki,
        AppConstants.Cities.stockholm,
        AppConstants.Cities.rome,
        AppConstants.Cities.riga,
        AppConstants.Cities.tallinn
    ]
    
    var searchedCities: [City] = []
    
    func add(_ city: City) {
        cities.append(city)
        postAddNotification()
    }
    
    // MARK: - Notifications
    
    private func postAddNotification() {
        NotificationCenter.default.post(Notification(name: .CitiesServiceDidAddCity))
    }
    
}

extension CitiesService {
    
    // MARK: - Searching
    
    func searchCities(named name: String, then handler: @escaping CitiesHandler) {
        geocodeApi.geocode(value: name) { [unowned self] (result) in
            switch result {
            case .success(let cities):
                self.searchedCities = cities
                handler(.success(cities))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
    
}

extension Notification.Name {
    static let CitiesServiceDidAddCity = Notification.Name(rawValue: "CitiesServiceDidAddCity")
}
