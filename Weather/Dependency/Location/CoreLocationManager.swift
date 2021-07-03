import CoreLocation

protocol CoreLocationManagerProtocol: AnyObject {

    var authorizationStatus: CLAuthorizationStatus { get }

}

class CoreLocationManager: CoreLocationManagerProtocol {

    var authorizationStatus: CLAuthorizationStatus {
        CLLocationManager.authorizationStatus()
    }

}
