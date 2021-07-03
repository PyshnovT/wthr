//
//  AppDependency.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import Foundation

struct AppDependency {
    let citiesService: CitiesServiceProtocol
    let weatherService: ForecastServiceProtocol
    var cityService: CityServiceProtocol
    let locationService: LocationServiceProtocol
}
