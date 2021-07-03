//
//  WeatherApi.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import Foundation

typealias ForecastHandler = (Result<Forecast, Error>) -> Void

protocol WeatherApi {
    
    func fetchForecast(forPlaceAt coordinate: Coordinate, then handler: @escaping ForecastHandler)
    
}
