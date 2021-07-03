//
//  IWeatherService.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import Foundation

protocol ForecastServiceProtocol {
    
    func fetchWeather(for city: City, then handler: @escaping ForecastHandler)
    
    func weather(for city: City) -> Forecast?
    
}

class ForecastService: ForecastServiceProtocol {
    
    let api: WeatherApi
    
    // MARK: - Init
    
    init(api: WeatherApi) {
        self.api = api
    }
    
    // MARK: - Weather
    
    private var allWeather: [CityID: Forecast] = [:]
    
    func weather(for city: City) -> Forecast? {
        allWeather[city.id]
    }
    
    // MARK: - Fething
    
    func fetchWeather(for city: City, then handler: @escaping ForecastHandler) {
        api.fetchForecast(forPlaceAt: city.centerCoordinate) { [unowned self] (result) in
            switch result {
            case .success(let weather):
                self.allWeather[city.id] = weather
                
            case .failure:
                break
            }
            
            handler(result)
        }
    }
    
}
