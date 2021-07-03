//
//  Geocoder.swift
//  Weather
//
//  Created by Tim Pyshnov on 01.08.2021.
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
                
                do {
                    let cities = try decoder.decode(GeocodeResponseContainer.self, from: data).cities                    
                    handler(.success(cities))
                } catch {
                    handler(.failure(error))
                }
            }
        }
        
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
    
}

extension Data {
    var prettyPrintedJSONString: NSString? { /// NSString gives us a nice sanitized debugDescription
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return nil }

        return prettyPrintedString
    }
}
