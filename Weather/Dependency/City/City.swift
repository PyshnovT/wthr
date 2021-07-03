//
//  City.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import UIKit

typealias CityID = String

struct City: Codable {
    let id: CityID
    let name: String
    let address: String
    let centerCoordinate: Coordinate
}
