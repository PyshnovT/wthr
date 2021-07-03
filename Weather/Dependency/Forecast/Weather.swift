//
//  Weather.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

typealias Temperature = Int

struct Weather: Codable {
    let condition: Condition
    let daytime: Daytime
    let temperature: Temperature
    let temperatureFeelsLike: Temperature
    let humidity: Int
    let windSpeed: Int
    let pressure: Int
}

struct DayForecast: Codable {
    let date: Date
    let day: Weather.Part
    let night: Weather.Part
}

struct Forecast: Codable {
    let current: Weather
    let future: [DayForecast]
}

extension Weather {

    struct Part: Codable {
        let daytime: Daytime
        let temperature: Temperature
        let condition: Condition
    }

    enum Daytime: String, Codable {
        case day
        case night
    }
    
    var isDay: Bool {
        daytime == .day
    }
    
    var isNight: Bool {
        daytime == .night
    }
    
    var conditionsIcon: UIImage {
        if isNight {
            return condition.nightIcon
        }
        
        return condition.dayIcon
    }
    
}

extension Weather {
    
    enum Condition: String, Codable {
        case clear
        case partlyCloudy = "partly-cloudy"
        case cloudy
        case overcast
        case drizzle
        case lightRain = "light-rain"
        case rain
        case moderateRain = "moderate-rain"
        case heavyRain
        case continuousHeavyRain = "continuous-heavy-rain"
        case showers
        case wetSnow = "wet-snow"
        case lightSnow = "light-snow"
        case snow
        case snowShowers = "snow-showers"
        case hail
        case thunderstorm
        case thunderstormWithRain = "thunderstorm-with-rain"
        case thunderstormWithHail = "thunderstorm-with-hail"
        case unknown
    }
    
}

extension Weather.Condition {
    
    var dayIcon: UIImage {
        switch self {
        case .clear:
            return AppConstants.Images.Weather.clear
            
        case .cloudy, .partlyCloudy:
            return AppConstants.Images.Weather.cloudy
        
        case .overcast:
            return AppConstants.Images.Weather.overcast
        
        case .drizzle:
            return AppConstants.Images.Weather.drizzle
            
        case .lightRain, .rain, .moderateRain:
            return AppConstants.Images.Weather.rain
            
        case .heavyRain, .continuousHeavyRain, .showers:
            return AppConstants.Images.Weather.heavyRain
            
        case .wetSnow, .lightSnow, .snow, .snowShowers:
            return AppConstants.Images.Weather.snow
            
        case .hail:
            return AppConstants.Images.Weather.hail
            
        case .thunderstorm, .thunderstormWithRain, .thunderstormWithHail:
            return AppConstants.Images.Weather.thunderstorm
            
        default:
            return AppConstants.Images.Weather.clear
            
        }
    }
    
    var text: String {
        switch self {
        case .clear: return "ясно"
        case .cloudy: return "облачно"
        case .partlyCloudy: return "малооблачно"
        case .overcast: return "пасмурно"
        case .drizzle: return "моросит"
        case .lightRain: return "небольшой дождь"
        case .rain: return "дождь"
        case .moderateRain: return "дождь"
        case .heavyRain: return "сильный дождь"
        case .continuousHeavyRain: return "дождь"
        case .showers: return "ливень"
        case .wetSnow: return "мокрый снег"
        case .lightSnow: return "снег"
        case .snow: return "снег"
        case .snowShowers: return "снегопад"
        case .hail: return "град"
        case .thunderstorm: return "гроза"
        case .thunderstormWithRain: return "гроза"
        case .thunderstormWithHail: return "гроза"
        default: return "ясно"
        }
    }
    
    var nightIcon: UIImage {
        switch self {
        case .clear:
            return AppConstants.Images.Weather.clearNight
         
        default:
            return dayIcon
            
        }
    }
    
}

extension Temperature {

    var descriptionWithSign: String {
        if self >= 0 {
            return "+\(description)"
        }

        return description
    }

}
