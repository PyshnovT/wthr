//
//  ForecastResponse.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import Foundation

struct ForecastResponse: Codable {
    
    var fact: WeatherResponse
    var forecasts: [ForecastResponse]
    
}

extension ForecastResponse {
    
    struct WeatherResponse: Codable {
        let temp: Int
        let feelsLike: Int
        let condition: String
        let pressureMm: Int
        let windSpeed: Double
        let humidity: Double
        let daytime: String
    }

    struct PartResponse: Codable {
        let condition: String
        let temp: Int?
        let tempAvg: Int?
    }

    struct ForecastResponse: Codable {
        let date: String
        let parts: [String: PartResponse]
    }
    
}

// MARK: - Responses

extension ForecastResponse {

    var forecast: Forecast {
        let future: [DayForecast] = forecasts.compactMap { forecast in
            let date = forecast.date.getDate()

            guard let dayResponse = forecast.parts["day"],
                  let nightResponse = forecast.parts["night"] else {
                return nil
            }

            guard let date = date,
                  let dayTemp = dayResponse.temp ?? dayResponse.tempAvg,
                  let nightTemp = nightResponse.temp ?? nightResponse.tempAvg else {
                return nil
            }

            let day = Weather.Part(
                daytime: .day,
                temperature: dayTemp,
                condition: Weather.Condition(rawValue: dayResponse.condition) ?? .unknown
            )

            let night = Weather.Part(
                daytime: .night,
                temperature: nightTemp,
                condition: Weather.Condition(rawValue: dayResponse.condition) ?? .unknown
            )

            return DayForecast(date: date, day: day, night: night)
        }

        return Forecast(current: weather, future: future)
    }

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
