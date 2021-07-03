protocol GeocoderServiceProtocol: AnyObject {

    func geocode(coordinate: Coordinate, then handler: @escaping CityHandler)

}

final class GeocoderService: GeocoderServiceProtocol {

    let geocodeApi: GeocodeApi

    init(geocodeApi: Geocoder) {
        self.geocodeApi = geocodeApi
    }

    func geocode(coordinate: Coordinate, then handler: @escaping CityHandler) {
        let value = [coordinate.longitude, coordinate.latitude]
            .map { $0.truncatingToString(places: 6) }
            .joined(separator: ",")

        geocodeApi.geocode(value: value) { result in
            switch result {
            case .success(let cities):
                guard let city = cities.first else {
                    handler(.failure(GeocoderError.notFound))
                    return
                }

                handler(.success(city))

            case .failure(let error):
                handler(.failure(error))
            }
        }
    }

}
