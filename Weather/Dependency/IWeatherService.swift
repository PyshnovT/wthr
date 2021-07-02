//
//  IWeatherService.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

protocol IWeatherService {
    
    func fetchWeather(for city: City, then handler: @escaping WeatherHandler)
    
    func weather(for city: City) -> Weather?
    
}

class WeatherService: IWeatherService {
    
    let api: WeatherApi
    
    // MARK: - Init
    
    init(api: WeatherApi) {
        self.api = api
    }
    
    // MARK: - Weather
    
    private var allWeather: [CityID: Weather] = [:]
    
    func weather(for city: City) -> Weather? {
        allWeather[city.id]
    }
    
    // MARK: - Fething
    
    func fetchWeather(for city: City, then handler: @escaping WeatherHandler) {
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
