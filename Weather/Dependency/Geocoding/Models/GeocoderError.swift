enum GeocoderError: Error {
    case notFound
    case responseError(Error)
}
