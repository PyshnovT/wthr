//
//  CityService.swift
//  Weather
//
//  Created by Tim Pyshnov on 01.07.2021.
//

import Foundation

typealias CityHandler = ((Result<City, Error>) -> Void)
typealias CityStatusHandler = ((CityStatus) -> Void)

protocol CityServiceProtocol {

    var currentCity: City? { get }

    var cityStatus: CityStatus { get }

    func fetchLocation()

    func subscribeToCityStatus(onUpdate: @escaping CityStatusHandler)

}

final class CityService: CityServiceProtocol {

    let locationService: LocationServiceProtocol

    // MARK: - Init

    init(locationService: LocationServiceProtocol) {
        self.locationService = locationService
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

    private(set) var cityStatus: CityStatus = .empty {
        didSet {
            invokeCallbacks(cityStatus: cityStatus)
        }
    }

    // MARK: - Location

    func fetchLocation() {
        cityStatus = .locating
        locationService.requestCurrentLocation()
    }

    private var isLocating: Bool {
        switch cityStatus {
        case .locating:
            return true
        default:
            return false
        }
    }

    // MARK: - Geocoding

    private func geocode(_ location: Coordinate) {
        print("Start geocodding!", location)
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
