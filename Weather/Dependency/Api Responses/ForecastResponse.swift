//
//  ForecastResponse.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import Foundation

struct ForecastResponse: Codable {
    
    var fact: Fact
    
}

extension ForecastResponse {
    
    struct Fact: Codable {
        let temp: Int
        let feelsLike: Int
        let condition: String
        let pressureMm: Int
        let windSpeed: Double
        let humidity: Double
        let daytime: String
    }
    
}

// MARK: - Responses

extension ForecastResponse {
    
    var weather: Weather {
        let daytime: Weather.Daytime
        
        if fact.daytime == "d" {
            daytime = .day
        } else {
            daytime = .night
        }
        
        return Weather(
            condition: Weather.Condition(rawValue: fact.condition) ?? .unknown,
            daytime: daytime,
            temperature: fact.temp,
            temperatureFeelsLike: fact.feelsLike,
            humidity: Int(fact.humidity),
            windSpeed: Int(fact.windSpeed),
            pressure: fact.pressureMm
        )
    }
    
}
