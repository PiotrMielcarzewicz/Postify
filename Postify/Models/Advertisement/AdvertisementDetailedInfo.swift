//
//  AdvertisementDetailedInfo.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 06/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum AdvertisementDetailedInfo: Codable {
    case none
    case vinyl(Vinyl)
}

extension AdvertisementDetailedInfo {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(AdvertisementType.self, forKey: .type)
        switch type {
        case .vinyl:
            let vinyl = try Vinyl(from: decoder)
            self = .vinyl(vinyl)
        case .other:
            self = .none
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case let .vinyl(vinyl):
            try container.encode(vinyl.author, forKey: .author)
            try container.encode(vinyl.album, forKey: .album)
        case .none:
            break
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case author
        case album
    }
}
