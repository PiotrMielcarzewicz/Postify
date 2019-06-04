//
//  Advertisements.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 29/10/2018.
//  Copyright © 2018 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

struct Advertisement {
    let id: String
    let title: String
    let description: String
    let price: Float
    let imageURLs: [URL]
    let timestamp: Int64
    let type: AdvertisementType
    let detailedInfo: AdvertisementDetailedInfo
    let isArchived: Bool
    let categoryId: String
    let ownerId: String
}

extension Advertisement: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case price
        case imageURLs
        case timestamp
        case type
        case detailedInfo
        case categoryId
        case isArchived
        case ownerId
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.price = try container.decode(Float.self, forKey: .price)
        let urlStrings = try container.decode([String].self, forKey: .imageURLs)
        let urls = try urlStrings.map { urlString -> URL in
            guard let url = URL(string: urlString) else { throw PostifyError.missingURL }
            return url
        }
        self.imageURLs = urls
        self.timestamp = try container.decode(Int64.self, forKey: .timestamp)
        self.type = (try? container.decode(AdvertisementType.self, forKey: .type)) ?? .other
        self.detailedInfo = try AdvertisementDetailedInfo(from: decoder)
        self.categoryId = try container.decode(String.self, forKey: .categoryId)
        self.isArchived = try container.decode(Bool.self, forKey: .isArchived)
        self.ownerId = try container.decode(String.self, forKey: .ownerId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(price, forKey: .price)
        try container.encode(imageURLs.map { $0.absoluteString }, forKey: .imageURLs)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(type.rawValue, forKey: .type)
        try container.encode(categoryId, forKey: .categoryId)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(ownerId, forKey: .ownerId)
        try detailedInfo.encode(to: encoder)
    }
}
