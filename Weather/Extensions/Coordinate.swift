//
//  Coordinate.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import CoreLocation

struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    
    var coreCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
}

extension CLLocationCoordinate2D {
    
    var weatherCoordinate: Coordinate {
        Coordinate(latitude: latitude, longitude: longitude)
    }
    
}

