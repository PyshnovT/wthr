//
//  CityService.swift
//  Weather
//
//  Created by Tim Pyshnov on 01.07.2021.
//

import Foundation

typealias CityHandler = (Result<City, Error>) -> Void
typealias CityStatusHandler = (CityStatus) -> Void

typealias CityAndForecastHandler = (Result<(City, Forecast), Error>) -> Void

protocol CityServiceProtocol {

    var currentCity: City? { get }

    var cityStatus: CityStatus { get }

    func subscribeToCityStatus(onUpdate: @escaping CityStatusHandler)

    func fetchLocation()

    // Custom set city

    func setCustomCity(_ city: City?)

    var isCurrentCityCustom: Bool { get }

    // Forecast

    var currentForecast: Forecast? { get }

    func fetchForecast(then handler: @escaping CityAndForecastHandler)

}

final class CityService: CityServiceProtocol {

    let locationService: LocationServiceProtocol
    let geocoderService: GeocoderServiceProtocol
    let forecastService: ForecastServiceProtocol
    private(set) var offlineManager: OfflineManagerProtocol

    // MARK: - Init

    init(
        locationService: LocationServiceProtocol,
        geocoderService: GeocoderServiceProtocol,
        forecastService: ForecastServiceProtocol,
        offlineManager: OfflineManagerProtocol
    ) {
        self.locationService = locationService
        self.geocoderService = geocoderService
        self.forecastService = forecastService
        self.offlineManager = offlineManager

        self.locationService.delegate = self
    }

    // MARK: - City

    var currentCity: City? {
        switch cityStatus {
        case .locatedCity(let city):
            return city
        case .savedCity(let city):
            return city
        default:
            return nil
        }
    }

    var isCurrentCityCustom: Bool {
        switch cityStatus {
        case .savedCity:
            return true
        default:
            return false
        }
    }

    private(set) var cityStatus: CityStatus = .empty {
        didSet {
            invokeCallbacks(cityStatus: cityStatus)
        }
    }

    // MARK: - Location

    func fetchLocation() {
        if locationService.locationStatus == .denied {
            cityStatus = .error(.location(.denied))
        } else {
            cityStatus = .locating
            locationService.requestCurrentLocation()
        }
    }

    private var isLocating: Bool {
        switch cityStatus {
        case .locating:
            return true
        default:
            return false
        }
    }

    // MARK: - Custom

    func setCustomCity(_ city: City?) {
        currentForecast = nil
        
        guard let city = city else {
            fetchLocation()
            return
        }

        cityStatus = .savedCity(city)
    }

    // MARK: - Geocoding

    private func geocode(_ location: Coordinate) {
        geocoderService.geocode(coordinate: location) { [weak self] result in
            switch result {
            case .success(let city):
                self?.cityStatus = .locatedCity(city)

            case .failure(let error):
                if let offlineCity = self?.offlineManager.offlineCity {
                    self?.cityStatus = .savedCity(offlineCity)
                } else {
                    self?.cityStatus = .error(.geocoding(.responseError(error)))
                }

            }
        }
    }

    // MARK: - Forecast

    private(set) var currentForecast: Forecast?

    private var isFetchingForecast: Bool = false

    private var forecastResultCallbacks: [CityAndForecastHandler?] = []

    func fetchForecast(then handler: @escaping CityAndForecastHandler) {
        guard let city = currentCity else {
            handler(.failure(ForecastError.noCity))
            return
        }

        forecastResultCallbacks.append(handler)

        guard !isFetchingForecast else { return }

        isFetchingForecast = true

        forecastService.fetchWeather(for: city) { [weak self] result in
            if case .success(let forecast) = result {
                self?.currentForecast = forecast

                if let city = self?.currentCity {
                    self?.offlineManager.save(city: city, andForecast: forecast)
                }
            }

            self?.invokeCallbacks(forecastResult: result)

            self?.isFetchingForecast = false
        }
    }

    private func invokeCallbacks(forecastResult: Result<Forecast, Error>) {
        forecastResultCallbacks.forEach { callback in
            switch forecastResult {
            case .success(let forecast):
                if let city = currentCity {
                    callback?(.success((city, forecast)))
                } else {
                    callback?(.failure(ForecastError.noCity))
                }

            case .failure(let error):
                if let offlineForecast = offlineManager.offlineForecast,
                   let city = offlineManager.offlineCity {
                    currentForecast = offlineForecast

                    callback?(.success((city, offlineForecast)))
                } else {
                    callback?(.failure(ForecastError.requestError(error)))
                }
            }
        }

        forecastResultCallbacks.removeAll()
    }

    // MARK: - Subscription

    private var locationResultCallbacks: [CityStatusHandler?] = []

    func subscribeToCityStatus(onUpdate: @escaping CityStatusHandler) {
        locationResultCallbacks.append(onUpdate)
    }

    private func invokeCallbacks(cityStatus: CityStatus) {
        locationResultCallbacks.forEach {
            $0?(cityStatus)
        }
    }

}

extension CityService: LocationServiceDelegateProtocol {

    func locationService(_ locationService: LocationServiceProtocol, didUpdateLocation location: Coordinate) {
        geocode(location)
    }

    func locationService(_ locationService: LocationServiceProtocol, didChangeAuthorization status: LocationStatus) {
        guard isLocating else { return }

        switch status {
        case .always, .inUse:
            locationService.requestCurrentLocation()
            
        case .denied:
            cityStatus = .error(.location(.denied))

        case .notDetermined:
            cityStatus = .locating

        }
    }

    func locationService(_ locationService: LocationServiceProtocol, didFailWith error: Error) {
        guard isLocating else { return }

        cityStatus = .error(.location(.coreLocationError(error)))
    }

}
