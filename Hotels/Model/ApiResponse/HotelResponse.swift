//
//  HotelResponse.swift
//  Hotels
//
//  Created by Htet Wai Yan Swe on 1/16/22.
//

import Foundation

struct HotelResponse: Codable {
    let results: [Hotel]
}

struct Hotel: Codable {
    let hotelName: String
    let hotelId: Int
    let address: String
    let reviewScore: Double
    let websiteUrl: String
    let photoUrl: String
    let city: String
    
    enum CodingKeys: String, CodingKey {
        case hotelName = "hotel_name"
        case hotelId = "hotel_id"
        case address
        case reviewScore = "review_score"
        case websiteUrl = "url"
        case photoUrl = "max_1440_photo_url"
        case city
    }
}
