//
//  AppDependency.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

struct AppDependency {
    let citiesService: ICitiesService
    let weatherService: IWeatherService
    let cityService: CityServiceProtocol
}
