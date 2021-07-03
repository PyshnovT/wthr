import CoreLocation

enum LocationStatus {
    case always, inUse, denied, notDetermined
}

extension LocationStatus {
    var isAllowed: Bool {
        switch self {
        case .always, .inUse:
            return true

        case .denied, .notDetermined:
            return false
        }
    }
}

extension LocationStatus {

    init(from locationAuthorizationStatus: CLAuthorizationStatus) {
        switch locationAuthorizationStatus {
        case .authorizedAlways:
            self = .always

        case .authorizedWhenInUse:
            self = .inUse

        case .restricted, .denied:
            self = .denied

        case .notDetermined:
            self = .notDetermined

        @unknown default:
            self = .notDetermined
        }
    }
    
}
