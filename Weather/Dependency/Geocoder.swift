//
//  Geocoder.swift
//  Weather
//
//  Created by Lisa Pyshnova on 01.08.2021.
//

import Foundation

class Geocoder: GeocodeApi {
    
    private let session = URLSession.mainQueue
    
    private var task: URLSessionDataTask?
    
    // MARK: - Request

    func geocode(value: String, then handler: @escaping CitiesHandler) {
        var components = URLComponents(string: AppConstants.Api.geocoding)!
        
        components.queryItems = [
            URLQueryItem(name: "apikey", value: AppConstants.ApiKeys.yandexGeocoding),
            URLQueryItem(name: "geocode", value: value),
            URLQueryItem(name: "format", value: "json")
        ]
        
        let newUrl = components.url!
        
        var request = URLRequest(url: newUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        cancel()
        
        task = session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                print(data.utf8!)
                
                do {
                    let cities = try decoder.decode(GeocodeResponseContainer.self, from: data).cities                    
                    handler(.success(cities))
                } catch {
                    handler(.failure(error))
                }
            }
        }
        
//        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}
