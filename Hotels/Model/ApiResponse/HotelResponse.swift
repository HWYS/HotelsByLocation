//
//  HotelResponse.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import Foundation

struct HotelResponse: Codable {
    let result: [Hotel]
}

struct Hotel: Codable {
    let hotelName: String
    let address: String
    let cityName: String
    let reviewScore: Double
    let photoUrl: String
    let websiteUrl: String
    let minPrice: Double
    
    enum CodingKeys: String, CodingKey {
        case hotelName = "hotel_name"
        case address
        case cityName = "city_name_en"
        case reviewScore  = "review_score"
        case photoUrl = "max_1440_photo_url"
        case websiteUrl = "url"
        case minPrice = "min_total_price"
    }
}
