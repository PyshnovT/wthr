//
//  AppConstants.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit
import CoreLocation

enum AppConstants {
    
    enum Color {
        static let black = UIColor.black
        static let white = UIColor.white

        static let gray = UIColor.hex("#EFEFEF")
        static let lightGray = UIColor(white: 0, alpha: 0.2)
    }
    
    enum Images {
        static let search = UIImage(named: "search")!
        static let close = UIImage(named: "close")!
        
        enum Weather {
            static let clear = UIImage(named: "clear")!
            static let snow = UIImage(named: "snow")!
            static let rain = UIImage(named: "rain")!
            static let thunderstorm = UIImage(named: "thunderstorm")!
            static let cloudy = UIImage(named: "cloudy")!
            static let hail = UIImage(named: "hail")!
            static let heavyRain = UIImage(named: "heavy-rain")!
            static let drizzle = UIImage(named: "drizzle")!
            static let overcast = UIImage(named: "overcast")!
            
            static let clearNight = UIImage(named: "clear-night")!
        }
    }
    
    enum Font {
        static let regular = UIFont.systemFont(ofSize: 17)
    }
    
    enum ApiKeys {
        static let yandexForecast = "1a719ed6-de11-45bb-acd7-318372018214"
        static let yandexGeocoding = "cff499ba-8492-4bcd-8cfc-47546d935f2e"
    }
    
    enum Strings {

    }
    
    enum Cities {
        static let paris = City(id: "paris", name: "Париж", address: "Paris", centerCoordinate: Coordinates.paris)
        static let moscow = City(id: "moscow", name: "Москва", address: "Moscow", centerCoordinate: Coordinates.moscow)
        static let losAngeles = City(id: "los angeles", name: "Лос Анджелес", address: "Los Angeles", centerCoordinate: Coordinates.losAngeles)
        static let newYork = City(id: "new york", name: "Нью-Йорк", address: "New York", centerCoordinate: Coordinates.newYork)
        static let saintPetersburg = City(id: "saint-p", name: "Санкт-Петербург", address: "Санкт-Петербург", centerCoordinate: Coordinates.saintPetersburg)
        static let riga = City(id: "riga", name: "Рига", address: "Рига", centerCoordinate: Coordinates.riga)
        static let tallinn = City(id: "Таллинн", name: "Таллинн", address: "Таллинн", centerCoordinate: Coordinates.tallinn)
        static let helsinki = City(id: "Хельсинки", name: "Хельсинки", address: "Хельсинки", centerCoordinate: Coordinates.helsinki)
        static let stockholm = City(id: "Стокгольм", name: "Стокгольм", address: "Стокгольм", centerCoordinate: Coordinates.stockholm)
        static let rome = City(id: "Рим", name: "Рим", address: "Рим", centerCoordinate: Coordinates.rome)
    }
    
    enum Coordinates {
        static let saintPetersburg = Coordinate(latitude: 59.93202, longitude: 30.34072)
        static let paris = Coordinate(latitude: 48.864716, longitude: 2.349014)
        static let moscow = Coordinate(latitude: 55.751244, longitude: 37.618423)
        static let losAngeles = Coordinate(latitude: 34.052235, longitude: -118.243683)
        static let newYork = Coordinate(latitude: 40.730610, longitude: -73.935242)
        static let riga = Coordinate(latitude: 56.56466260, longitude: 24.6182808)
        static let tallinn = Coordinate(latitude: 59.436962, longitude: 24.753574)
        static let helsinki = Coordinate(latitude: 60.11314124, longitude: 24.56449916)
        static let stockholm = Coordinate(latitude: 59.334591, longitude: 18.063240)
        static let rome = Coordinate(latitude: 41.902782, longitude: 12.496366)
    }

    enum Api {
        static let forecast: String = "https://api.weather.yandex.ru/v2/forecast"
        static let geocoding: String = "https://geocode-maps.yandex.ru/1.x/"
    }
    
}
