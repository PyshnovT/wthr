enum LocationError: Error {
    case coreLocationError(Error)
    case denied
}
