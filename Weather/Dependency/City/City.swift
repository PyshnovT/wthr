//
//  City.swift
//  Weather
//
//  Created by Lisa Pyshnova on 30.07.2021.
//

import UIKit

typealias CityID = String

struct City {
    let id: CityID
    let name: String
    let address: String
    let centerCoordinate: Coordinate
}
