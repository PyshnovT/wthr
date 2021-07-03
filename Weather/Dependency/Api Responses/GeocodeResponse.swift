//
//  GeocodeResponse.swift
//  Weather
//
//  Created by Tim Pyshnov on 01.08.2021.
//

import Foundation

struct GeocodeResponseContainer: Codable {
    let response: GeocodeResponse
    
    var cities: [City] {
        response.GeoObjectCollection.featureMember.compactMap { $0.city }
    }
    
}

extension GeocodeResponseContainer.FeatureMember {
    
    var city: City? {
        let address = GeoObject.metaDataProperty.GeocoderMetaData.Address
        
        let components: [GeocodeResponseContainer.Component] = address.Components.compactMap {
            if $0.kind == "locality" || $0.kind == "province" {
                return $0
            }
            
            return nil
        }
        
        guard components.count > 0 else { return nil }
    
        let cityComponent = components.last!
        let name = cityComponent.name
        
        let point = GeoObject.Point
        let coordinates = point.pos.split(separator: " ")
            
        if let latitude = Double(coordinates[0]), let longitude = Double(coordinates[1]) {
            let coordinate = Coordinate(latitude: latitude, longitude: longitude)
            let city = City(id: address.formatted, name: name, address: address.formatted, centerCoordinate: coordinate)
            
            return city
        }
        
        return nil
    }
    
}

extension GeocodeResponseContainer {
    
    struct GeocodeResponse: Codable {
        let GeoObjectCollection: GeoObjectCollection
    }
    
}

extension GeocodeResponseContainer {
    
    struct GeoObjectCollection: Codable {
        let featureMember: [FeatureMember]
    }
    
}

extension GeocodeResponseContainer {
    
    struct FeatureMember: Codable {
        let GeoObject: GeoObject
    }
    
}

extension GeocodeResponseContainer {
    
    struct GeoObject: Codable {
        let metaDataProperty: MetaDataProperty
        let Point: IPoint
    }
    
}

extension GeocodeResponseContainer {
    
    struct MetaDataProperty: Codable {
        let GeocoderMetaData: IGeocoderMetaData
    }
    
}

extension GeocodeResponseContainer {
    
    struct IGeocoderMetaData: Codable {
//        let kind: String
//        let text: String
        let Address: IAddress
    }
    
    struct IPoint: Codable {
        let pos: String
    }
    
    struct IAddress: Codable {
        let Components: [Component]
    }
    
    struct Component: Codable {
        let kind: String
        let name: String
    }
    
}

extension GeocodeResponseContainer.IAddress {
    
    var formatted: String {
        if let smallest = Components.last,
           let largest = Components.first {
        
            if smallest.kind != largest.kind {
                return "\(smallest.name), \(largest.name)"
            }
            
        }
        
        return Components.last?.name ?? ""
    }
    
}
