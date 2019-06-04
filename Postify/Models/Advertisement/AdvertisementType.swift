//
//  AdvertisementType.swift
//  Postify
//
//  Created by Piotr Mielcarzewicz on 06/01/2019.
//  Copyright © 2019 Piotr Mielcarzewicz. All rights reserved.
//

import Foundation

enum AdvertisementType: String, Codable {
    case vinyl
    case other
    
    var title: String {
        switch self {
        case .vinyl:
            return LocalizedStrings.vinyl
        case .other:
            return LocalizedStrings.other
        }
    }
}
