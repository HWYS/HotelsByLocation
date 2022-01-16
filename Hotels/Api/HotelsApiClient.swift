//
//  HotelsApiClient.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/15/22.
//

import Foundation

class HotelsApiClient {
    private let headers = [
        "x-rapidapi-host": "booking-com.p.rapidapi.com",
        "x-rapidapi-key": "ZX4BjoSRbjmshLRPbUXKVb8gOqcWp1QZ3HsjsnMJ1FQpV2rY9T"
    ]
    
    enum EndPoints {
        private static let baseURL = "https://booking-com.p.rapidapi.com/v1/hotels/"
        
        
        case searchByCoordinate(Double, Double)
        case downloadPhoto(String)
        
        var urlString: String {
            switch self {
            case .searchByCoordinate(let lat, let lon):
                return EndPoints.baseURL + "search-by-coordinates?order_by=popularity&longitude=\(lon)&latitude=\(lat)&locale=en-gb"
                
            case.downloadPhoto(let photoUrl):
                return photoUrl
            }
        }
        
        var url: URL {
            return URL(string: urlString)!
        }
    }
    
    class func getHotelsByCoordinate(lat: Double, lon: Double, completion: @escaping  ([Hotel], Error?) -> Void) {
        taskForGETRequest(url: EndPoints.searchByCoordinate(lat, lon).url, responseType: HotelResponse.self) { response, error in
            if let response = response {
                completion(response.results, nil)
            }else {
                completion([], error)
            }
        }
    }
    
    class func taskForGETRequest<ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields =  [ "x-rapidapi-host": "booking-com.p.rapidapi.com", "x-rapidapi-key": "ZX4BjoSRbjmshLRPbUXKVb8gOqcWp1QZ3HsjsnMJ1FQpV2rY9T"]
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            do {
                let responseObject = try JSONDecoder().decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
        
    }
    
    class func downloadImage(photoUrl: String, completion: @escaping (Data?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.downloadPhoto(photoUrl).url) { data, response, error in
            
            DispatchQueue.main.async{
                completion(data, error)
            }
        }
        task.resume()
    }
    
}
