import CoreLocation

protocol LocationServiceProtocol: AnyObject {

    var delegate: LocationServiceDelegateProtocol? { get set }

    var locationStatus: LocationStatus { get }

    func requestCurrentLocation()

}

protocol LocationServiceDelegateProtocol: AnyObject {

    func locationService(_ locationService: LocationServiceProtocol, didChangeAuthorization status: LocationStatus)

    func locationService(_ locationService: LocationServiceProtocol, didUpdateLocation location: Coordinate)

    func locationService(_ locationService: LocationServiceProtocol, didFailWith error: Error)

}

class LocationService: NSObject, LocationServiceProtocol {

    var delegate: LocationServiceDelegateProtocol?

    private let locationManager: CLLocationManager

    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager

        super.init()

        configure()
    }

    private func configure() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
    }

    // MARK: - LocationServiceProtocol

    var locationStatus: LocationStatus {
        .init(from: locationManager.authorizationStatus)
    }

    func requestCurrentLocation() {
        switch locationStatus {
        case .always, .denied, .inUse:
            locationManager.requestLocation()

        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        }
    }

}

extension LocationService: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationService(self, didChangeAuthorization: .init(from: status))
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWith: error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        delegate?.locationService(self, didUpdateLocation: location.coordinate.weatherCoordinate)
    }

}

extension CLLocationManager {

    var authorizationStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }

}
