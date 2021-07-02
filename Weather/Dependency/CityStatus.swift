enum CityStatus {
    case locatedCity(City)
    case savedCity(City)
    case locating
    case empty
    case error(CityStatus.Error)
}

extension CityStatus {

    enum Error: Swift.Error {
        case location(LocationError)
        case geocoding(Swift.Error)
    }

}

extension CityStatus: CustomStringConvertible {

    var description: String {
        switch self {
        case .locatedCity(let city):
            return "Located Город \(city.name) :\(city.centerCoordinate)"
        case .savedCity(let city):
            return "Saved Город \(city.name) :\(city.centerCoordinate)"
        case .locating:
            return "Locating.."
        case .empty:
            return "Пусто"
        case .error(let error):
            return error.localizedDescription
        }
    }

}

extension CityStatus.Error {

    var localizedDescription: String {
        switch self {
        case .geocoding(let error):
            return error.localizedDescription

        case .location(let locationError):
            switch locationError {
            case .denied:
                return "Denied"

            case .coreLocationError(let error):
                return error.localizedDescription
            }
        }
    }

}
