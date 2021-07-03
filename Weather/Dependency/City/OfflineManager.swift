//
//  OfflineManager.swift
//  Weather
//
//  Created by Tim Pyshnov on 03.07.2021.
//

import Foundation

protocol OfflineManagerProtocol {

    var offlineCity: City? { get }

    var offlineForecast: Forecast? { get }

    func save(city: City, andForecast forecast: Forecast)

    func removeAll()

}

class OfflineManager: OfflineManagerProtocol {

    let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    var offlineCity: City? {
        get {
            if let data = userDefaults.value(forKey: Constants.cityKey) as? Data {
                return try? PropertyListDecoder().decode(City.self, from: data)
            }

            return nil
        }
        set {
            guard let city = newValue else {
                userDefaults.removeObject(forKey: Constants.cityKey)
                return
            }

            userDefaults.set(try? PropertyListEncoder().encode(city), forKey: Constants.cityKey)
        }
    }

    var offlineForecast: Forecast? {
        get {
            if let data = userDefaults.value(forKey: Constants.forecastKey) as? Data {
                return try? PropertyListDecoder().decode(Forecast.self, from: data)
            }

            return nil
        }
        set {
            guard let forecast = newValue else {
                userDefaults.removeObject(forKey: Constants.forecastKey)
                return
            }

            userDefaults.set(try? PropertyListEncoder().encode(forecast), forKey: Constants.forecastKey)
        }
    }

    func save(city: City, andForecast forecast: Forecast) {
        offlineCity = city
        offlineForecast = forecast
    }

    func removeAll() {
        offlineCity = nil
        offlineForecast = nil
    }

}

private enum Constants {
    static let cityKey = "OfflineManager.city"
    static let forecastKey = "OfflineManager.forecast"
}
