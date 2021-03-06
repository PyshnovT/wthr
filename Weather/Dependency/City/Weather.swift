//
//  Weather.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

struct Weather {
    let condition: Condition
    let daytime: Daytime
    let temperature: Int
    let temperatureFeelsLike: Int
    let humidity: Int
    let windSpeed: Int
    let pressure: Int
}

extension Weather {
    
    enum Daytime {
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
    
    enum Condition: String {
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
        case .clear: return "????????"
        case .cloudy: return "??????????????"
        case .partlyCloudy: return "??????????????????????"
        case .overcast: return "????????????????"
        case .drizzle: return "??????????????"
        case .lightRain: return "?????????????????? ??????????"
        case .rain: return "??????????"
        case .moderateRain: return "??????????"
        case .heavyRain: return "?????????????? ??????????"
        case .continuousHeavyRain: return "??????????"
        case .showers: return "????????????"
        case .wetSnow: return "???????????? ????????"
        case .lightSnow: return "????????"
        case .snow: return "????????"
        case .snowShowers: return "????????????????"
        case .hail: return "????????"
        case .thunderstorm: return "??????????"
        case .thunderstormWithRain: return "??????????"
        case .thunderstormWithHail: return "??????????"
        default: return "????????"
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
