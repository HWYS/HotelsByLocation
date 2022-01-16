//
//  WeatherResponse.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/17/22.
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let icon: String
}
struct Main: Codable {
    let temp: Double
}
