//
//  GeocodeApi.swift
//  Weather
//
//  Created by Lisa Pyshnova on 01.08.2021.
//

import Foundation

typealias CitiesHandler = (Result<[City], Error>) -> Void

protocol GeocodeApi {
    
    func geocode(value: String, then handler: @escaping CitiesHandler)
    
}
