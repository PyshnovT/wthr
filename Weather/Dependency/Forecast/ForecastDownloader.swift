//
//  WeatherDownloader.swift
//  Weather
//
//  Created by Tim Pyshnov on 30.07.2021.
//

import Foundation

class ForecastDownloader: WeatherApi {
    
    private let session = URLSession.mainQueue
    
    // MARK: - Request
    
    func fetchForecast(forPlaceAt coordinate: Coordinate, then handler: @escaping ForecastHandler) {
        var components = URLComponents(string: AppConstants.Api.forecast)!
        
        components.queryItems = [
            URLQueryItem(name: "lat", value: coordinate.latitude.description),
            URLQueryItem(name: "lon", value: coordinate.longitude.description),
            URLQueryItem(name: "limit", value: "7")
        ]
        
        let newUrl = components.url!
        
        var request = URLRequest(url: newUrl)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "X-Yandex-API-Key": AppConstants.ApiKeys.yandexForecast
        ]
        
        let task = session.dataTask(with: request) { (data, _, error) in
            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                do {
                    let weather = try decoder.decode(ForecastResponse.self, from: data).forecast
                    handler(.success(weather))
                } catch {
                    handler(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
}

extension URLSession {
    
    static var mainQueue: URLSession {
        URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
}

extension Data {
    
    var utf8: String? {
        String(data: self, encoding: .utf8)
    }
    
}
