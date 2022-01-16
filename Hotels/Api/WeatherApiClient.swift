//
//  WeatherApiClient.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/17/22.
//

import Foundation

class WeatherApiClient {
    class func getCurrentWeatherByCoordinate(q: String, lat: Double, lon: Double, completion: @escaping (WeatherResponse?, Error?) ->  Void) {
        let headers = [
            "x-rapidapi-host": "community-open-weather-map.p.rapidapi.com",
            "x-rapidapi-key": "ZX4BjoSRbjmshLRPbUXKVb8gOqcWp1QZ3HsjsnMJ1FQpV2rY9T"
        ]
        
        do {
            var request = try URLRequest(url: URL(string: "https://community-open-weather-map.p.rapidapi.com/weather?q=\(q.trimmingCharacters(in: .whitespacesAndNewlines))&lat=\(lat)&lon=\(lon)&lang=null&units=metric")! as URL,
                                                    cachePolicy: .useProtocolCachePolicy,
                                                timeoutInterval: 10.0)
            request.httpMethod = "GET"
            request.allHTTPHeaderFields = headers

            let session = URLSession.shared
            let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    
                    return
                }
                do {
                    let responseObject = try JSONDecoder().decode(WeatherResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(responseObject, nil)
                    }
                    
                }catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                    
                }
            })

            dataTask.resume()
        }catch {
            DispatchQueue.main.async {
                completion(nil, error)
            }
        }
        
    }
}
