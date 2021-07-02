//
//  WeatherApi.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

typealias WeatherHandler = (Result<Weather, Error>) -> Void

protocol WeatherApi {
    
    func fetchForecast(forPlaceAt coordinate: Coordinate, then handler: @escaping WeatherHandler)
    
}
