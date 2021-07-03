extension CityService {

    enum ForecastError: Swift.Error {
        case noCity
        case requestError(Error)
    }

}
